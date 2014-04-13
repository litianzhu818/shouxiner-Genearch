
#import "BBBJQViewController.h"
#import "BBXXXViewController.h"
#import "BBJFViewController.h"

#import "BBCellHeight.h"
#import "BBBJQManager.h"
#import "CoreUtils.h"

#import "CPUIModelManagement.h"
#import "CPUIModelPersonalInfo.h"



@interface BBBJQViewController ()
@property (nonatomic,strong) BBTopicModel *tempTopModel;
@property (nonatomic,strong) BBTopicModel *tempTopModelInput;
@property (nonatomic,copy) NSString *inputText;

@property (nonatomic,strong) MessagePictrueViewController *messagePictrueController;

@end

@implementation BBBJQViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"groupListResult" isEqualToString:keyPath])  // 班级列表
    {
        
        self.isLoading = NO;
        
        NSDictionary *result = [PalmUIManagement sharedInstance].groupListResult;
        
        if (![result[@"hasError"] boolValue]) { // 没错
            bjDropdownView.listData = [NSArray arrayWithArray:result[@"data"]];
            
            if ([bjDropdownView.listData count]>0) {
                
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                int index = [def integerForKey:@"saved_topic_group_index"];  // 上次选中的班级
                
                if ([bjDropdownView.listData count]>index) {
                    _currentGroup = bjDropdownView.listData[index];
                    [titleButton setTitle:_currentGroup.alias forState:UIControlStateNormal];
                }else{
                    _currentGroup = bjDropdownView.listData[0];
                    [titleButton setTitle:_currentGroup.alias forState:UIControlStateNormal];
                }
                
                //            if ([_currentGroup.avatar length]>0) {
                //                avatar.imageURL = [NSURL URLWithString:_currentGroup.avatar];
                //            }
                
                [bjqTableView triggerPullToRefresh];
                
            }
        }else{
            [self showProgressWithText:@"班级列表加载失败" withDelayTime:0.1];
        }
    }
    
    if ([@"groupTopicListResult" isEqualToString:keyPath])  // 圈信息列表
    {
        
        self.isLoading = NO;
        
        NSDictionary *result = [PalmUIManagement sharedInstance].groupTopicListResult;
        
        switch (self.loadStatus) {
            case TopicLoadStatusRefresh:
                //
            {
                if ([result[@"hasError"] boolValue]) { // 有错
                    [bjqTableView.pullToRefreshView stopAnimating];
                }else{
                
                    NSArray *arr = [NSArray arrayWithArray:result[@"data"]];
                    [self.allTopicList removeAllObjects];
                    [self.allTopicList addObjectsFromArray:arr];
                    
                    [bjqTableView.pullToRefreshView stopAnimating];
                    
                    NSDate *now = [CoreUtils convertDateToLocalTime:[NSDate date]];
                    NSString *date = [NSString stringWithFormat:@"最近更新: %@",[[now description] substringToIndex:16]];
                    [bjqTableView.pullToRefreshView setSubtitle:date forState:SVPullToRefreshStateAll];
                }
            }
                break;
            case TopicLoadStatusAppend:
                //
            {
                if ([result[@"hasError"] boolValue]) { // 有错
                    [bjqTableView.infiniteScrollingView stopAnimating];
                }else{
                    NSArray *arr = [NSArray arrayWithArray:result[@"data"]];
                    [self.allTopicList addObjectsFromArray:arr];
                    
                    [bjqTableView.infiniteScrollingView stopAnimating];
                }
                
            }
                break;
            default:
                break;
        }
        
        [bjqTableView reloadData];
    }
    
    if ([@"notifyCount" isEqualToString:keyPath])  // 新消息
    {
        NSDictionary *dict = [PalmUIManagement sharedInstance].notifyCount;
        int count = [dict[@"data"][@"count"] intValue];
        
        //int count = 3;
        
        if (notifyCount != count) {
            notifyCount = count;
            [bjqTableView reloadData];
        }
    }
    
    if ([@"userCredits" isEqualToString:keyPath])  // 刷新积分
    {
        NSDictionary *dict = [PalmUIManagement sharedInstance].userCredits;
        NSNumber *credits = dict[@"data"][@"credits"];
        point.text = [NSString stringWithFormat:@"           你已有%d积分可以兑换",[credits intValue]];
    }
    
    if ([@"praiseResult" isEqualToString:keyPath])  // 赞
    {
        if ([[[PalmUIManagement sharedInstance].praiseResult objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            return;
        }
        NSDictionary *result = [[PalmUIManagement sharedInstance].praiseResult objectForKey:ASI_REQUEST_DATA];
        if ([result[@"errno"] intValue] == 0) {
            BBPraiseModel *praise = [[BBPraiseModel alloc] init];
            CPLGModelAccount *account = [[CPSystemEngine sharedInstance] accountModel];
            praise.uid = [NSNumber numberWithInteger:[account.uid integerValue]];;
            praise.username = [CPUIModelManagement sharedInstance].uiPersonalInfo.nickName;
            
            self.tempTopModel.am_i_like = [NSNumber numberWithBool:1];
            NSMutableArray *p = [[NSMutableArray alloc] initWithArray:self.tempTopModel.praises];
            [p addObject:praise];
            self.tempTopModel.praises = [NSArray arrayWithArray:p];
            self.tempTopModel.praisesStr = [NSString stringWithFormat:@"%@%@,",self.tempTopModel.praisesStr,praise.username];
            [bjqTableView reloadData];
        }
    }
    
    if ([@"commentResult" isEqualToString:keyPath])  // 评论
    {
        /*
         @property(nonatomic,strong) NSString *comment;
         @property(nonatomic,strong) NSNumber *id;
         @property(nonatomic,strong) NSNumber *replyto;
         @property(nonatomic,strong) NSString *replyto_username;
         @property(nonatomic,strong) NSNumber *timestamp;
         @property(nonatomic,strong) NSNumber *uid;
         @property(nonatomic,strong) NSString *username;
         */
        if ([[[PalmUIManagement sharedInstance].commentResult objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            return;
        }
        NSDictionary *result = [[PalmUIManagement sharedInstance].commentResult objectForKey:ASI_REQUEST_DATA];
        if ([result[@"errno"] intValue] == 0) {
            BBCommentModel *comment = [[BBCommentModel alloc] init];
            CPLGModelAccount *account = [[CPSystemEngine sharedInstance] accountModel];
            comment.comment = self.inputText;
            comment.replyto = self.tempTopModelInput.author_uid;
            comment.replyto_username = self.tempTopModelInput.author_username;
            comment.uid = [NSNumber numberWithInteger:[account.uid integerValue]];;
            comment.username = [CPUIModelManagement sharedInstance].uiPersonalInfo.nickName;
            
            NSMutableArray *p = [[NSMutableArray alloc] initWithArray:self.tempTopModel.comments];
            [p addObject:comment];
            self.tempTopModel.comments = [NSArray arrayWithArray:p];
            NSUInteger len = [comment.username length]+2;
            NSString *text = [NSString stringWithFormat:@"%@: %@\n",comment.username,comment.comment];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a7f9d"] range:NSMakeRange(0,len)];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.tempTopModelInput.commentsStr];
            [str appendAttributedString:attributedText];
            self.tempTopModelInput.commentsStr = str;
            [bjqTableView reloadData];
        }
    }
    
    if ([@"uiPersonalInfoTag" isEqualToString:keyPath]) {
        NSLog(@"%@",[CPUIModelManagement sharedInstance].uiPersonalInfo);
        NSString *path = [[CPUIModelManagement sharedInstance].uiPersonalInfo selfHeaderImgPath];
        if (path) {
            avatar.image = [UIImage imageWithContentsOfFile:path];
        }

    }
}

-(void)addObservers{
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"groupListResult" options:0 context:NULL];
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"groupTopicListResult" options:0 context:NULL];
    
    // 积分
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"userCredits" options:0 context:NULL];
    
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"notifyCount" options:0 context:NULL];
    
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"praiseResult" options:0 context:NULL];
    [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"commentResult" options:0 context:NULL];
    
}

-(void)removeObservers{

    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"groupListResult"];
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"groupTopicListResult"];
    
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"userCredits"];
    
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"notifyCount"];
    
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"praiseResult"];
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"commentResult"];

}

-(void)checkNotify{

    [[PalmUIManagement sharedInstance] getNotiCount];
    [self performSelector:@selector(checkNotify) withObject:nil afterDelay:15];

}

-(void)addNewTaped:(id)sender{

    [[UIApplication sharedApplication].keyWindow addSubview:fsDropdownView];
    [fsDropdownView show];
}

-(void)newNotifyTaped:(id)sender{

    BBXXXViewController *xxx = [[BBXXXViewController alloc] init];
    xxx.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xxx animated:YES];
}

-(void)bjButtonTaped:(id)sender{

    if (self.isLoading) {  // 屏蔽事件
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:bjDropdownView];
    if (bjDropdownView.unfolded) {
        [bjDropdownView dismiss];
    }else{
        [bjDropdownView show];
    }
}

-(void)pointTaped:(UITapGestureRecognizer *)gesture{
    BBJFViewController *jf = [[BBJFViewController alloc] init];
    jf.hidesBottomBarWhenPushed = YES;
    jf.url = [NSURL URLWithString:@"http://baidu.com"];
    [self.navigationController pushViewController:jf animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allTopicList = [[NSMutableArray alloc] init];
    
    // 不要移除，用户其他页面更新头像后，此页面同步更新
    [[CPUIModelManagement sharedInstance] addObserver:self forKeyPath:@"uiPersonalInfoTag" options:0 context:NULL];
    

    notifyCount = 0;
    
    hasNew = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.view.backgroundColor = [UIColor brownColor];

    bjqTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, 320, self.view.bounds.size.height-20) style:UITableViewStylePlain];
    bjqTableView.backgroundColor = [UIColor colorWithRed:242/255.f green:236/255.f blue:230/255.f alpha:1.f];
    //bjqTableView.separatorColor = [UIColor clearColor];
    //bjqTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bjqTableView.dataSource = self;
    bjqTableView.delegate = self;
    [self.view addSubview:bjqTableView];
    [bjqTableView reloadData];
    
    
    __weak BBBJQViewController *weakSelf = self;
    // 刷新
    [bjqTableView addPullToRefreshWithActionHandler:^{
        
        weakSelf.isLoading = YES;
        
        weakSelf.loadStatus = TopicLoadStatusRefresh;
        
        [[PalmUIManagement sharedInstance] getGroupTopic:[weakSelf.currentGroup.groupid intValue] withTimeStamp:1 withOffset:0 withLimit:30];
    }];
    
    // 追加
    [bjqTableView addInfiniteScrollingWithActionHandler:^{
        
        weakSelf.isLoading = YES;
        
        weakSelf.loadStatus = TopicLoadStatusAppend;
        
        int offset = [weakSelf.allTopicList count];
        
        BBTopicModel *model = [weakSelf.allTopicList lastObject];
        
        int st = [model.ts intValue];
        
        [[PalmUIManagement sharedInstance] getGroupTopic:[weakSelf.currentGroup.groupid intValue] withTimeStamp:1 withOffset:offset withLimit:30];
        
    }];
    
    
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 210+20)];
    //head.backgroundColor = [UIColor whiteColor];
    head.backgroundColor = [UIColor colorWithRed:242/255.f green:236/255.f blue:230/255.f alpha:1.f];
    head.userInteractionEnabled = YES;
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 214)];
    //headImage.backgroundColor = [UIColor orangeColor];
    headImage.image = [UIImage imageNamed:@"BBTopBGNew"];
    [head addSubview:headImage];
    
    point = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 23)];
    point.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [head addSubview:point];
    point.text = @"           你已有0积分可以兑换";
    point.textAlignment = NSTextAlignmentCenter;
    point.font = [UIFont boldSystemFontOfSize:12];
    point.textColor = [UIColor whiteColor];
    point.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(pointTaped:)];
    [point addGestureRecognizer:gesture];
    
    
    avatar = [[EGOImageView alloc] initWithFrame:CGRectMake(22, 145, 80, 80)];
    avatar.backgroundColor = [UIColor grayColor];
    //avatar.image = [UIImage imageNamed:@"girl"];
    
    NSString *path = [[CPUIModelManagement sharedInstance].uiPersonalInfo selfHeaderImgPath];
    if (path) {
        avatar.image = [UIImage imageWithContentsOfFile:path];
    }
    
    [head addSubview:avatar];
    CALayer *roundedLayer = [avatar layer];
    [roundedLayer setMasksToBounds:YES];
    roundedLayer.cornerRadius = 40.0;
    roundedLayer.borderWidth = 2;
    roundedLayer.borderColor = [[UIColor whiteColor] CGColor];
    
    bjqTableView.tableHeaderView = head;
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0.f, 7.f, 30.f, 30.f)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"BBAdd"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNewTaped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BBAdd"] style:UIBarButtonItemStylePlain  target:self action:@selector(addNewTaped:)];
    
    titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    [titleButton setTitle:@"班级" forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    [titleButton addTarget:self action:@selector(bjButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(124, 9, 22, 22)];
    [titleButton addSubview:arrow];
    arrow.image = [UIImage imageNamed:@"BBDown"];
    
    bjDropdownView = [[BBBJDropdownView alloc] initWithFrame:self.view.bounds];
    bjDropdownView.delegate = self;
    
    fsDropdownView = [[BBFSDropdownView alloc] initWithFrame:self.view.bounds];
    fsDropdownView.delegate = self;
    
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    inputBar = [[BBInputView alloc] initWithFrame:CGRectMake(0, h, 320, 44)];
    inputBar.delegate = self;
    
    [[PalmUIManagement sharedInstance] getGroupList];
    
    [[PalmUIManagement sharedInstance] getUserCredits];
    
    [self checkNotify];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isLoading = NO;
    [self addObservers];
    
    [bjqTableView triggerPullToRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [inputBar endEdit];
    
    [self removeObservers];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allTopicList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (notifyCount>0) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
        //backView.backgroundColor = [UIColor whiteColor];
        backView.backgroundColor = [UIColor colorWithRed:242/255.f green:236/255.f blue:230/255.f alpha:1.f];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 8, backView.bounds.size.height)];
        //line.backgroundColor = [UIColor lightGrayColor];
        line.image = [UIImage imageNamed:@"BBLine"];
        //line.alpha = 0.5;
        [backView addSubview:line];
        
        UIButton *newNotify = [UIButton buttonWithType:UIButtonTypeCustom];
        newNotify.frame = CGRectMake(K_LEFT_PADDING, 3, 172, 38);
        [newNotify setBackgroundImage:[UIImage imageNamed:@"BBNewMessage"] forState:UIControlStateNormal];
        newNotify.backgroundColor = [UIColor clearColor];
        [backView addSubview:newNotify];
        [newNotify addTarget:self action:@selector(newNotifyTaped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 4, 30, 30)];
        [newNotify addSubview:icon];
        CALayer *roundedLayer = [icon layer];
        [roundedLayer setMasksToBounds:YES];
        roundedLayer.cornerRadius = 15.0;
        roundedLayer.borderWidth = 1;
        roundedLayer.borderColor = [[UIColor whiteColor] CGColor];
        icon.image = [UIImage imageNamed:@"girl"];
        
        NSString *path = [[CPUIModelManagement sharedInstance].uiPersonalInfo selfHeaderImgPath];
        if (path) {
            icon.image = [UIImage imageWithContentsOfFile:path];
        }
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(50, 9, 100, 20)];
        [newNotify addSubview:msg];
        msg.textColor = [UIColor whiteColor];
        msg.backgroundColor = [UIColor clearColor];
        msg.font = [UIFont boldSystemFontOfSize:13];
        msg.text = [NSString stringWithFormat:@"你有%d条新消息",notifyCount];
        
        return backView;
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"defCell";
    static NSString *cellIdentifier1 = @"linkCell";
    static NSString *cellIdentifier2 = @"replyCell";
    static NSString *cellIdentifier3 = @"imageCell";
    
    BBTopicModel *model = self.allTopicList[indexPath.row];
    /*
    1 班级通知
    2 家庭作业
    3 安全教育
    4 班级生活
    6 安全作业
    7 转发“有指示”
    */
    
    // 发作业2，发通知1，拍表现4，随便说4
    
    switch ([model.topictype intValue]) {
        case 1:  // 发通知1
            //
        {
        
            BBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell) {
                cell = [[BBWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:model];
            cell.delegate = self;
            return cell;
        }
            break;
        case 2:  // 发作业2
            //
        {
            
            BBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell) {
                cell = [[BBWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:model];
            cell.delegate = self;
            return cell;
        }
            break;
        case 4:  // 拍表现4，随便说4
            //
        {
            BBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (!cell) {
                cell = [[BBImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:model];
            cell.delegate = self;
            return cell;
        }
            break;

        case 7:  // 转发 forword
            //
        {
            BBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            
            if (!cell) {
                cell = [[BBLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setData:model];
            cell.delegate = self;
            return cell;
        }
            break;
        default:   // 默认，随便说
            
            //
        {
            BBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (!cell) {
                cell = [[BBImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:model];
            cell.delegate = self;
            return cell;
        }
            
            break;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //return 340;
    return [BBCellHeight heightOfData:self.allTopicList[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (notifyCount>0) { // hasNew
        return 46;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [inputBar endEdit];
}

#pragma mark - BBFSDropdownViewDelegate

-(void)bbFSDropdownView:(BBFSDropdownView *) dropdownView_ didSelectedAtIndex:(NSInteger) index_{
    BBFZYViewController *fzy = [[BBFZYViewController alloc] init];
    fzy.hidesBottomBarWhenPushed = YES;
    fzy.style = index_;
    fzy.currentGroup = _currentGroup;
    [self.navigationController pushViewController:fzy animated:YES];
}

-(void)bbFSDropdownViewTaped:(BBFSDropdownView *) dropdownView_{

}

#pragma mark - BBBJDropdownViewDelegate
-(void)bbBJDropdownView:(BBBJDropdownView *) dropdownView_ didSelectedAtIndex:(NSInteger) index_{
    _currentGroup = dropdownView_.listData[index_];
    [titleButton setTitle:_currentGroup.alias forState:UIControlStateNormal];
    
//    avatar.image = nil;
//    if ([_currentGroup.avatar length]>0) {
//        avatar.imageURL = [NSURL URLWithString:_currentGroup.avatar];
//    }
    
    
//    self.loadStatus = TopicLoadStatusRefresh;
//    [[PalmUIManagement sharedInstance] getGroupTopic:[_currentGroup.groupid intValue] withTimeStamp:1 withOffset:0 withLimit:30];
    
    [bjqTableView triggerPullToRefresh];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:index_ forKey:@"saved_topic_group_index"];
    [def synchronize];
    
}

-(void)bbBJDropdownViewTaped:(BBBJDropdownView *) dropdownView_{

}

#pragma mark - BBBaseTableViewCellDelegate

// 赞
-(void)bbBaseTableViewCell:(BBBaseTableViewCell *)cell likeButtonTaped:(UIButton *)sender{

    self.tempTopModel = cell.data;
    if ([self.tempTopModel.am_i_like boolValue]) {
        return;
    }
    [[PalmUIManagement sharedInstance] postPraise:[self.tempTopModel.topicid longLongValue]];
}

// 评论
-(void)bbBaseTableViewCell:(BBBaseTableViewCell *)cell replyButtonTaped:(UIButton *)sender{

    [[UIApplication sharedApplication].keyWindow addSubview:inputBar];
    inputBar.data = cell.data;
    [inputBar beginEdit];
    
    NSIndexPath *indexPath = [bjqTableView indexPathForCell:cell];
    CGRect r0 = [bjqTableView rectForRowAtIndexPath:indexPath];
    CGRect r1 = [bjqTableView convertRect:r0 toView:nil];
    int x = [UIScreen mainScreen].bounds.size.height-260-r1.origin.y-r1.size.height;
    CGPoint p = CGPointMake(0, bjqTableView.contentOffset.y-x);
    
    [bjqTableView setContentOffset:p animated:YES];
}

// 点击大图
-(void)bbBaseTableViewCell:(BBBaseTableViewCell *)cell imageButtonTaped:(EGOImageButton *)sender{

    [inputBar endEdit];
    
    BBTopicModel *model = cell.data;
    
    float height = 0.0f;
    if (isIPhone5) {
        height = 568.0f;
    }else{
        height = 480.0f;
    }
    
    CGRect imageRect = sender.frame;
    CGRect superViewRect = [cell convertRect:imageRect toView:nil];
    
    NSString *url = model.imageList[sender.tag];
    
    self.messagePictrueController = [[MessagePictrueViewController alloc] initWithPictrueURL:url withRect:superViewRect];
    self.messagePictrueController.delegate = self;
    self.messagePictrueController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication].keyWindow addSubview:self.messagePictrueController.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [inputBar endEdit];
}

#pragma mark - BBInputViewDelegate

-(void)bbInputView:(BBInputView *)view sendText:(NSString *)text{
    // send
    
//    BBTopicModel *model = view.data;
    self.tempTopModelInput = view.data;
    self.inputText = text;
    [[PalmUIManagement sharedInstance] postComment:text
                                    withReplyToUid:[self.tempTopModelInput.author_uid intValue]
                                       withTopicID:[self.tempTopModelInput.topicid longLongValue]];
    
}

#pragma 展示图片的委托实现开始
-(void)beganCloseImageAnimation{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
-(void)endCloseImageAnimation
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) dealloc{
    [[CPUIModelManagement sharedInstance] removeObserver:self forKeyPath:@"uiPersonalInfoTag"];
}
@end
