//
//  ACUtilities.h
//  AC_PAZZCK
//
//  Created by 陈 玉龙 on 12-8-14.
//  Copyright (c) 2012年 陈 玉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *ac_PathInDocumentDirectory(NSString *fileName);
NSString *ac_PathInLibraryDirectory(NSString *fileName);
NSString *ac_PathInCachesDirectory(NSString *fileName);
NSString *ac_md5(NSString *str);
NSString *ac_MD5(NSString *str);