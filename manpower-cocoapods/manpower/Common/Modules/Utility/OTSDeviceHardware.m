//
//  OTSDeviceHardware.m
//  OneStore
//
//  Created by huang jiming on 13-5-4.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "OTSDeviceHardware.h"
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation OTSDeviceHardware
DEFINE_SINGLETON_FOR_CLASS(OTSDeviceHardware)

+ (NSString*)staticPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString * platformStr = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    free(machine);
    return platformStr;
}

- (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString * platformStr = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platformStr;
}

- (NSString *)platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}
-(BOOL) supportCarmera {
    
    NSString *deviceString=[self platformString];
    BOOL ret = YES;
    if ([deviceString isEqualToString:@"iPhone 1G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPhone 3G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 1G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 2G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 3G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPad"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"Simulator"] ) {
        ret = NO;
    }
    return ret;
}

@end
