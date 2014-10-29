//
//  IMImageHelper.m
//  manpower
//
//  Created by WangShunzhou on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "IMRecorder.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "SWHex.h"
#import "NSData+Encryption.h"

static NSString *const cryptPassword = @"cn.whzm.IM_Wang_Shunzhou";

@implementation IMMessageHelper

+ (NSString*) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImagePNGRepresentation(currentImage);//(currentImage, 1);
    
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(currentImage, 1);
    }
    
    // 获取沙盒目录
    NSString *fullPath = [IMAGE_DIR_PATH stringByAppendingPathComponent:imageName];
    [IMMessageHelper createDirectory:IMAGE_DIR_PATH];
    // 将图片写入文件
    if (![imageData writeToFile:fullPath atomically:NO]) {
        return nil;
    }
    return fullPath;
}

+ (BOOL)saveImage:(UIImage *)currentImage withFullFilePath:(NSString *)filePath
{
    NSData *imageData = UIImagePNGRepresentation(currentImage);//(currentImage, 1);
    
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(currentImage, 1);
    }
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    
    [IMMessageHelper createDirectory:directory];
    // 将图片写入文件
    if (![imageData writeToFile:filePath atomically:NO]) {
        return NO;
    }
    return YES;
}

+ (NSString*) saveImageToPhotoDirectory:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    // 获取沙盒目录
    NSString *fullPath = [PHOTO_DIR_PATH stringByAppendingPathComponent:imageName];
    if ([IMMessageHelper saveImage:currentImage withFullFilePath:fullPath]) {
        return fullPath;
    }
    return nil;
}

+ (BOOL)moveFile:(NSString*)currentPath to:(NSString*)toPath{
    if (currentPath.length ==0 || toPath.length == 0){
        DDLogError(@"====================================================\ncurrentPath为空====================================================");
        return NO;
    }
//    NSMutableString *toPathDir = [NSMutableString stringWithString:@""];
//    NSArray *components = [toPath componentsSeparatedByString:@"/"];
//    for(int i=0 ; i < components.count - 1 ; i++) {
//        NSString *component = components[i];
//        [toPathDir appendFormat:@"%@/",component];
//    }
    NSString *toPathDir = [toPath stringByDeletingLastPathComponent];
    [IMMessageHelper createDirectory:toPathDir];
    NSError *err = nil;
    [[NSFileManager defaultManager] moveItemAtPath:currentPath toPath:toPath error:&err];
    if (err) {
        DDLogError(@"Move file error: %@",err);
        return NO;
    }else{
        DDLogVerbose(@"================File Moved To: ===============\n%@",toPath);
    }
    return YES;
}

+ (UIImage*)getImage:(NSString*)imageName{
    NSString *imagePath = [IMAGE_DIR_PATH stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

+ (UIImage*)getPhoto:(NSString*)photoName{
    NSString *imagePath = [PHOTO_DIR_PATH stringByAppendingPathComponent:photoName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}



/**
 *  我的们目标是：能听清楚 ^_^
 *  采样率8000赫兹，单声道，线性PCM格式，低质量录音。文件大小大概12KB/S
 *  后期进行音频压缩
 */
+ (IMRecorder*)getRecorder{
    [IMMessageHelper createDirectory:TMP_DIR_PATH];
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:TMP_VOICE_FILE_NAME_FORMAT];
    NSString *tmpFileName = [formatter stringFromDate:date];
    NSString *wavTmpFilePath = [NSString stringWithFormat:@"%@/%@.wav", TMP_DIR_PATH, tmpFileName];
    NSString *amrTmpFilePath = [NSString stringWithFormat:@"%@/%@.amr", TMP_DIR_PATH, tmpFileName];
    NSURL *url = [NSURL fileURLWithPath:wavTmpFilePath];
    
    NSError *error;
    //初始化
    IMRecorder *recorder = [[IMRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    recorder.wavTmpFilePath = wavTmpFilePath;
    recorder.amrTmpFilePath = amrTmpFilePath;
    //开启音量检测
    recorder.meteringEnabled = YES;
    
    return recorder;
}

+ (AVAudioPlayer*)getPlayer{
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:<#(NSURL *)#> error:<#(NSError *__autoreleasing *)#>]
    return nil;
}

+ (NSString*)existVoice:(NSString*)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", VOICE_DIR_PATH,fileName];
    if (![fileManager fileExistsAtPath:path]) {
        return nil;
    }
    return path;
}

+ (BOOL)createDirectory:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDIR = NO;
    [fileManager fileExistsAtPath:path isDirectory:&isDIR];
    if (!isDIR) {
        [fileManager removeItemAtPath:path error:nil];
        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (NSString*)getTimestampString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:TMP_VOICE_FILE_NAME_FORMAT];
    NSString *tmpFileName = [formatter stringFromDate:date];
    return tmpFileName;
}

#pragma mark - Encrypt / Decrypt
+ (NSString*)encrypt:(NSString*)toBeEncString{
    NSString *retString = nil;
    NSError *err = nil;
    NSData *data = [toBeEncString dataUsingEncoding:NSUTF8StringEncoding];
//    data = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:cryptPassword error:&err];
    data = [data encryptWithKey:cryptPassword];
    if (!err) {
        retString = [data bytesString];
    }else{
        DDLogError(@"%@",err);
    }
    return retString;
}
+ (NSString*)decrypt:(NSString*)toBeDecString{
    NSString *retString = nil;
    NSError *err = nil;
    NSData *data = [toBeDecString dataFromBytesString];
//    data = [RNDecryptor decryptData:data withPassword:cryptPassword error:&err];
    data = [data decryptWithKey:cryptPassword];
    if (!err) {
        retString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        DDLogError(@"%@",err);
    }
    return retString;
}

+ (NSString *)generateUUID
{
	NSString *result = nil;
	
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	if (uuid)
	{
		result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
	}
	
	return result;
}
@end
