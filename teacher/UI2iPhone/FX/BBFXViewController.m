//
//  BBFXViewController.m
//  teacher
//
//  Created by mac on 14/11/7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import "BBFXViewController.h"
#import "BBFXTableViewCell.h"
#import "BBFXGridView.h"
#import "BBFXModel.h"
#import "BBFXDetailViewController.h"
#import "BBFXAdScrollView.h"

@interface BBFXViewController ()
{
    BBFXGridView *tempGrid;
    BBFXAdScrollView *adScrollView;
}
@property (nonatomic, strong) NSMutableArray *discoverArray;
@property (nonatomic, strong) NSMutableArray *serviceArray;
@end

@implementation BBFXViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"discoverResult" isEqualToString:keyPath]){
        [self initContentData];
    }
}

-(id)init{
    self = [super init];
    if (self) {
        [[PalmUIManagement sharedInstance] addObserver:self forKeyPath:@"discoverResult" options:0 context:nil];
        _discoverArray = [[NSMutableArray alloc] init];
        _serviceArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"发现";
    CGFloat heightFix = 20.f;
    if (IOS7) {
        heightFix = 20.f;
    }else{
        heightFix = 0;
    }
    
    fxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.screenHeight-44-49-heightFix) style:UITableViewStylePlain];
    [fxTableView setRowHeight:108];
    [fxTableView setSeparatorColor:[UIColor clearColor]];
    [fxTableView setDelegate:(id<UITableViewDelegate>)self];
    [fxTableView setDataSource:(id<UITableViewDataSource>)self];
    [self.view addSubview:fxTableView];
    [self initContentData];
}

-(void)initContentData
{
    if ([PalmUIManagement sharedInstance].discoverResult) {
        NSDictionary *discoverResult = [PalmUIManagement sharedInstance].discoverResult;
        if ([discoverResult[@"errno"] integerValue]==0) {
            [self.discoverArray removeAllObjects];
            if (![discoverResult[@"discover"] isKindOfClass:[NSNull class]]) {
                NSDictionary *discoverDic = discoverResult[@"discover"];
                for (NSString *key in [discoverDic allKeys]) {
                    NSDictionary *oneDiscover = discoverDic[key];
                    BBFXModel *oneModel = [[BBFXModel alloc] initWithJson:oneDiscover];
                    [self.discoverArray addObject:oneModel];
                }
            }
            if (![discoverResult[@"service"] isKindOfClass:[NSNull class]]) {
                [self.serviceArray removeAllObjects];
                NSDictionary *serviceDic = discoverResult[@"service"];
                for (NSString *key in [serviceDic allKeys]) {
                    NSDictionary *oneService = serviceDic[key];
                    BBFXModel *model = [[BBFXModel alloc] initWithJson:oneService];
                    [self.serviceArray addObject:model];
                }
                
            }
        }
//        /*ceshi:::*/
        if ([self.discoverArray count]==0) {
            for (int i=0; i<3; i++) {
                BBFXModel *model = [[BBFXModel alloc] init];
                model.title = [NSString stringWithFormat:@"%d-----%d", i, i];
                model.url = @"http://www.baidu.com";
                model.isNew = (i%2?YES:NO);
                model.image = (i%2?@"http://img.sccnn.com/bimg/322/599.jpg":@"http://pic23.nipic.com/20120817/5236266_171208039361_2.jpg");
                [self.discoverArray addObject:model];
                model = nil;
            }
        }
        if ([self.serviceArray count] == 0) {
            for (int i=0; i<5; i++) {
                BBFXModel *model = [[BBFXModel alloc] init];
                model.title = [NSString stringWithFormat:@"%d-----%d", i, i];
                model.url = @"http://www.baidu.com";
                model.isNew = (i%2?YES:NO);
                model.image = (i%2?@"http://g.hiphotos.baidu.com/baike/w%3D268/sign=fcf18d39b3de9c82a665fe89548080d2/4610b912c8fcc3cead54a0339245d688d43f201d.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=7760bd9a32fa828bd1239debcd1e41cd/6ca62b3b5bb5c9eade903a7cd439b6003bf3b38f.jpg");
                [self.serviceArray addObject:model];
                model = nil;
            }
        }
        /*end*/
        [fxTableView reloadData];
        [self addDiscoverHeader];
    }else{
        [[PalmUIManagement sharedInstance] getDiscoverData];
    }
}

-(void)addDiscoverHeader
{
    if ([self.discoverArray count]>0) {
        if (!adScrollView) {
            adScrollView = [[BBFXAdScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
            [adScrollView setDelegate:(id<BBFXAdScrollViewDelegate>)self];
            [self.view addSubview:adScrollView];
        }
        [adScrollView setAdsArray:self.discoverArray];
        [UIView animateWithDuration:0.5f animations:^{
            fxTableView.tableHeaderView = adScrollView;
        } completion:^(BOOL finished){
            
        }];
    }else{
        if (adScrollView) {
            [self removeDiscoverHeader];
        }
    }
    
}

-(void)removeDiscoverHeader
{
    [UIView animateWithDuration:0.5f animations:^{
        fxTableView.tableHeaderView = nil;
    } completion:^(BOOL finished){
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int residue = [self.serviceArray count] % 3;
    if (residue > 0) residue = 1;
    return [self.serviceArray count]/3 + residue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FXCellIdentifier = @"FXCellIdentifier";
    
    BBFXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FXCellIdentifier];
    if (nil == cell) {
        cell = [[BBFXTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FXCellIdentifier];
    }
    NSInteger count = [self.serviceArray count];
    CGFloat x = 0.0f;
    for (int i=0; i<3; i++) {
        NSInteger index = i + indexPath.row * 3;
        if (index >= count){
            if ([cell.contentView.subviews count] > i) {
                ((BBFXGridView *)[cell.contentView.subviews objectAtIndex:i]).hidden = YES;
            }
            continue;
        }
        if (index < count) {
            BBFXModel *model = [self.serviceArray objectAtIndex:index];
            if ([cell.contentView.subviews count] > i) {
                tempGrid = [cell.contentView.subviews objectAtIndex:i];
            } else {
                tempGrid = nil;
            }
            
            BBFXGridView *gridView = [self dequeueReusableGridView];
            if (gridView.superview != cell.contentView) {
                [gridView removeFromSuperview];
                [cell.contentView addSubview:gridView];
                [gridView addTarget:self action:@selector(tapOneGrid:) forControlEvents:UIControlEventTouchUpInside];
            }
            gridView.hidden = NO;
            [gridView setViewData:model];
            gridView.rowIndex = indexPath.row;
            gridView.colIndex = i;
            [gridView setFrame:CGRectMake(x, 0, 107, 107)];
            x = x + 107.0f+1;
        }else{
            BBFXGridView *gridView = (BBFXGridView *)[cell.contentView.subviews objectAtIndex:i];
            gridView.hidden = YES;
        }
    }
    return cell;
}

-(void)tapOneGrid:(BBFXGridView *)gridView
{
    NSInteger index = gridView.rowIndex*3 + gridView.colIndex;
    BBFXModel *model = [self.serviceArray objectAtIndex:index];
    model.isNew = NO;
    [gridView.flagNew setHidden:YES];
    BBFXDetailViewController *detailViewController = [[BBFXDetailViewController alloc] init];
    detailViewController.url = [NSURL URLWithString:model.url];
    [detailViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(BBFXGridView *)dequeueReusableGridView{
    BBFXGridView* temp = tempGrid;
    tempGrid = nil;
    if (temp == nil) {
        temp = [[BBFXGridView alloc] init];
    }
    return temp;
}

#pragma adscrollview
-(void)adViewTapped:(BBFXModel *)model
{
    BBFXDetailViewController *detailViewController = [[BBFXDetailViewController alloc] init];
    detailViewController.url = [NSURL URLWithString:model.url];
    [detailViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc
{
    [[PalmUIManagement sharedInstance] removeObserver:self forKeyPath:@"discoverResult"];
}

@end
