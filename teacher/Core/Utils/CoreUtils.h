//
//  CoreUtils.h
//  iCouple
//
//  Created by yong wei on 12-3-21.
//  Copyright (c) 2012年 fanxer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define convertMpeg4IsSucess @"isSucess"
#define convertMpeg4FileSize @"fileSize"
#define convertMpeg4MediaTime @"mediaTime"

typedef enum
{
    CONVERT_PCM_TYPE_NO = 0,
    CONVERT_PCM_TYPE_DEFAULT = 1,
    CONVERT_PCM_TYPE_CS = 2,
    CONVERT_PCM_TYPE_CQ = 3,
    CONVERT_PCM_TYPE_TTW = 4,
    CONVERT_PCM_TYPE_ALARM = 5
}ConverPcmType;

@interface CoreUtils : NSObject

+(BOOL)stringIsNotNull:(NSString *)str;

+(NSString *)getGlobalDeviceIdentifier;
+(NSString *)getDeviceIdentifier;
+(NSString*)getCellularProviderName;
+(NSString*)getMobileCountryCode;
+(NSString*)getMobileNetworkCode;
+(NSString *)getCountryCode;
+(NSString *)getLanguageCode;
+(BOOL)isJailbroken;
+(NSString *)getDocumentPath;
+(NSData *)getFileDataWithName:(NSString *)fileName;
+(BOOL)fileIsExistWithPah:(NSString *)path;
+(NSData *)getFileDataWithPathName:(NSString *)filePathName;
+(NSNumber *)getFileSizeWithName:(NSString *)fileName;
+(BOOL)copyFileWithSrcPath:(NSString *)srcPath andDstPath:(NSString *)dstPath;
+(BOOL)moveFileWithSrcPath:(NSString *)srcPath andDstPath:(NSString *)dstPath;

+(NSString *)convertMobileLabelToAbLabel:(NSString *)addBookLabel;
+ (NSString*) filterMobileNumber:(NSString*)phoneNumber;

+(NSNumber *)getLongFormatWithDate:(NSDate *)date;
+(NSNumber *)getLongFormatWithNowDate;
+(NSDate *)getDateFormatWithLong:(NSNumber *)dateLong;
+(NSString *)getDateDescriptiontWithLong:(NSNumber *)dateLong;
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate;
+(BOOL)createPath:(NSString *)path;
+(BOOL)writeToFileWithData:(NSData *)data file_name:(NSString *)fileName andPath:(NSString *)path;
+(NSString *)getUUID;
+(NSNumber *)getDateWithDesc:(NSString *)dateDesc;
+(NSNumber *)getLongFormatWithDateString:(NSString *)dateString;
+(NSString *)getStringFormatWithDate:(NSDate *)date;
+(NSString *)getStringFormatWithNumber:(NSNumber *)dateNumber;
+(NSString *)getStringNormalFormatWithNumber:(NSNumber *)dateNumber;
+(NSString *)filterResponseDescWithCode:(NSNumber *)resultCode;
+(NSNumber *)getMediaTimeWithUrl:(NSURL *)url;

+(NSDictionary *)convertMpeg4WithUrl:(NSURL *)url andDstFilePath:(NSString *)dstFilePath;
+(BOOL)convertPCM:(NSString *)pcmPath toAMR:(NSString *)amrPath transType:(NSInteger )transformType;
@end
