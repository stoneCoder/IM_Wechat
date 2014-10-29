//
//  Service.h
//  AutoTour
//
//  Created by hanjin on 14-3-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface Service : NSObject
DEFINE_SINGLETON_FOR_HEADER(Service)
-(void) post:(NSString*)uri Parameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *, id ))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(void) get:(NSString*)uri Parameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation *, id ))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
