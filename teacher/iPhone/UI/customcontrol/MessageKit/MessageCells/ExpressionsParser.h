//
//  ExpressionsParser.h
//  Components_xxx
//
//  Created by ming bright on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 文本内容最大宽度
#define kMaxWidth 220

#define kDefaultTextHeight       30
#define kDefaultExpressionHeight 35

@interface ExpressionsParser : NSObject
{
    //NSArray *expressions;
    
    NSString *inputText;
    UIFont   *font;
    
    NSMutableArray  *resultArray;
    NSArray  *widthsArray;
    
    //分成多行，每一行是一个元素
    NSArray  *departedContentArray;
    //行高数组,该行是否含有表情
    NSArray  *departedHeightArray;
    
    NSArray  *departedWidthArray;
}

@property(nonatomic,strong) NSString *inputText;
@property(nonatomic,strong) UIFont   *font;
@property(nonatomic,strong) NSMutableArray  *resultArray;
@property(nonatomic,strong) NSArray  *widthsArray;

@property(nonatomic,strong) NSArray  *departedContentArray;
@property(nonatomic,strong) NSArray  *departedHeightArray;
@property(nonatomic,strong) NSArray  *departedWidthArray;

-(id)initWithMessage:(NSString *)text font:(UIFont *) ft;
-(id)initWithMessage:(NSString *)text;
-(void)parse;


- (CGFloat)height;

+(NSArray *)expressions;

@end
