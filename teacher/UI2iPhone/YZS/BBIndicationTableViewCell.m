//
//  BBIndicationTableViewCell.m
//  BBTeacher
//
//  Created by xxx on 14-3-5.
//  Copyright (c) 2014年 xxx. All rights reserved.
//

#import "BBIndicationTableViewCell.h"
#import "ColorUtil.h"

@implementation BBIndicationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self addSubview:icon];
        icon.backgroundColor = [UIColor grayColor];
        
        CALayer *roundedLayer = [icon layer];
        [roundedLayer setMasksToBounds:YES];
        roundedLayer.cornerRadius = 25.0;
        //roundedLayer.borderWidth = 2;
        roundedLayer.borderColor = [[UIColor grayColor] CGColor];
        
        
        mark = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 20, 20)];
        [self addSubview:mark];
        mark.font = [UIFont systemFontOfSize:14];
        mark.textColor = [UIColor whiteColor];
        mark.backgroundColor = [UIColor orangeColor];
        mark.textAlignment = NSTextAlignmentCenter;
        CALayer *roundedLayer1= [mark layer];
        //[roundedLayer setMasksToBounds:YES];
        roundedLayer1.cornerRadius = 10.0;
        roundedLayer1.borderWidth = 0.5;
        roundedLayer1.borderColor = [[UIColor grayColor] CGColor];
        
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 230, 20)];
        [self addSubview:title];
        title.textColor = [UIColor colorWithHexString:@"#4a7f9d"];
        title.backgroundColor = [UIColor clearColor];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 50, 20)];
        [self addSubview:time];
        time.textColor =[UIColor grayColor];
        time.backgroundColor = [UIColor clearColor];
        
        content = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 230, 20)];
        [self addSubview:content];
        content.textColor =[UIColor grayColor];
        content.backgroundColor = [UIColor clearColor];
        
        
        title.font = [UIFont systemFontOfSize:14];
        time.font = [UIFont systemFontOfSize:14];
        content.font = [UIFont systemFontOfSize:14];
        
        mark.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:212/255.f green:212/255.f blue:212/255.f alpha:1.f];
    }else
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.f green:236/255.f blue:230/255.f alpha:1.f];
    }
}

-(void)setData:(id)data{
    _data = data;
    
    title.text = @"XX总局";
    
    time.text = @"12:23";
    
    int m = arc4random()%25+1;
    
    mark.text = [NSString stringWithFormat:@"%d",m];
    CGFloat width = [mark.text sizeWithFont:[UIFont systemFontOfSize:12]
                          constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    if (width<17) {
        width = 20;
    }else{
        width = width + 8;
    }
    mark.frame = CGRectMake(40, 3, width, 20);
    
//    [mark sizeThatFits:CGSizeMake(20, 20)];
    
    content.text = @"XX总局重要指示，！＃@¥％％……％&＊&¥％¥＃％…………&&＊";
    
    icon.image = [UIImage imageNamed:@"girl"];
}

@end
