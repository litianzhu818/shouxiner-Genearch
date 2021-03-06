//
//  CPLGModelAccount.m
//  icouple
//
//  Created by yong wei on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CPLGModelAccount.h"

#import "CoreUtils.h"

@implementation CPLGModelAccount
@synthesize loginName = loginName_;
@synthesize pwdMD5 = pwdMD5_;
@synthesize isAvtived = isActived_;
@synthesize queryAbTime = queryAbTime_;
@synthesize isVerifiedCode = isVerifiedCode_;
@synthesize mobileNumber = mobileNumber_;
@synthesize canUploadAb = canUploadAb_;
@synthesize uploadAbTime = uploadAbTime_;
@synthesize friTimeStamp = friTimeStamp_;
@synthesize converTimeStamp = converTimeStamp_;
@synthesize hasCommendUsers = hasCommendUsers_;
@synthesize myProfileTimeStamp = myProfileTimeStamp_;
@synthesize token = token_;
@synthesize suid = suid_;
@synthesize domain = domain_;
@synthesize isUploadDeviceToken = isUploadDeviceToken_;
@synthesize deviceToken = deviceToken_;
@synthesize hasSavePersonalInfoName = hasSavePersonalInfoName_;
@synthesize isAutoLogin = isAutoLogin_;
@synthesize willCoupleName = willCoupleName_;
@synthesize willCoupleUserName = willCoupleUserName_;
@synthesize willCoupleRealtionType = willCoupleRealtionType_;
@synthesize uid = uid_;

-(NSString *)getSelfBgFilePath
{
    NSString *filePath = PERSONAL_BG_FILE;
    NSString *documentPath = [CoreUtils getDocumentPath];
    return [NSString stringWithFormat:@"%@/%@/%@.jpg",documentPath,self.loginName,filePath];
}
-(NSString *)getSelfHeaderFilePath
{
    NSString *filePath = PERSONAL_HEADER_FILE;
    NSString *documentPath = [CoreUtils getDocumentPath];
    return [NSString stringWithFormat:@"%@/%@/%@.jpg",documentPath,self.loginName,filePath];
}
-(NSString *)getSelfCoupleFilePath
{
    NSString *filePath = PERSONAL_COUPLE_FILE;
    NSString *documentPath = [CoreUtils getDocumentPath];
    return [NSString stringWithFormat:@"%@/%@/%@.jpg",documentPath,self.loginName,filePath];
}
-(NSString *)getSelfBabyFilePath
{
    NSString *filePath = PERSONAL_BABY_FILE;
    NSString *documentPath = [CoreUtils getDocumentPath];
    return [NSString stringWithFormat:@"%@/%@/%@.jpg",documentPath,self.loginName,filePath];
}

@end
