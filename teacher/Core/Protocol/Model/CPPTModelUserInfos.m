//
//  CPPTModelUserInfos.m
//  iCouple
//
//  Created by yl s on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CPPTModelUserInfos.h"
#import "CPPTModelUserInfo.h"

#define K_USERINFOS_KEY_PRIMARY           @"list"

#define K_USERINFOS_VALUE_NULL            @""

@implementation CPPTModelUserInfos

@synthesize userInfoList = userInfoList_;

+ (CPPTModelUserInfos *)fromJsonDict:(NSDictionary *)jsonDict
{
    CPPTModelUserInfos *userInfos = nil;
    
    if(jsonDict)
    {
        userInfos = [[CPPTModelUserInfos alloc] init];
        if(userInfos)
        {
            NSMutableArray *userInfosArray = [[NSMutableArray alloc] init];
            
            NSDictionary *contactArray = [jsonDict objectForKey:K_USERINFOS_KEY_PRIMARY];
            NSEnumerator *keys = [contactArray keyEnumerator];
            id key;
            while (key = [keys nextObject]) {
                NSDictionary *dic = [contactArray objectForKey:key];
                CPPTModelUserInfo *userInfo = [CPPTModelUserInfo fromJsonDict:dic];
                [userInfosArray addObject:userInfo];
            }
//            for(NSDictionary *dict in contactArray)
//            {
//                CPPTModelUserInfo *userInfo = [CPPTModelUserInfo fromJsonDict:dict];
//                
//            }
            
            userInfos.userInfoList = userInfosArray;
        }
    }
    
    return userInfos;
}

- (NSMutableDictionary *)toJsonDict
{
    if(!self.userInfoList)
    {
        CPLogWarn(@"invalid user infos!!!");
        return nil;
    }
    
    NSMutableArray *userInfoArray = [[NSMutableArray alloc] init];
    
    for(CPPTModelUserInfo* userInfo in self.userInfoList)
    {
        [userInfoArray addObject:[userInfo toJsonDict]];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userInfoArray forKey:K_USERINFOS_KEY_PRIMARY];
    
    return dict;
}

@end
