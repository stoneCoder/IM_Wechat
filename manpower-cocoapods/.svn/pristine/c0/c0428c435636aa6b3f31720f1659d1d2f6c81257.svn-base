//
//  IMImageHelper.h
//  manpower
//
//  Created by WangShunzhou on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IMAGE_DIR_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MessageImages"]
#define PHOTO_DIR_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"]
#define VOICE_DIR_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Vocie"]
#define TMP_DIR_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmp"]
#define APP_TMP_DIR_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define TMP_VOICE_FILE_NAME_FORMAT @"yyyyMMddHHmmssSSS"


@class AVAudioRecorder;
@class IMRecorder;

@interface IMMessageHelper : NSObject

+ (NSString*) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+ (BOOL)saveImage:(UIImage *)currentImage withFullFilePath:(NSString *)filePath;
+ (NSString*) saveImageToPhotoDirectory:(UIImage *)currentImage withName:(NSString *)imageName;

+ (UIImage*)getImage:(NSString*)imageName;
+ (IMRecorder*)getRecorder;
+ (NSString*)existVoice:(NSString*)fileName;
+ (BOOL)createDirectory:(NSString*)path;
+ (BOOL)moveFile:(NSString*)currentPath to:(NSString*)toPath;
+ (NSString*)getTimestampString;

+ (NSString*)encrypt:(NSString*)toBeEncString;
+ (NSString*)decrypt:(NSString*)toBeEncString;

+ (NSString *)generateUUID;
@end

