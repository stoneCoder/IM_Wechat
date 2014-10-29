//
//  AFHTTPRequestOperationManager+Progress.h
//  manpower
//
//  Created by WangShunzhou on 14-8-22.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPRequestOperationManager (Progress)

/**
 *  Upload file with progress
 *
 *  @param URLString
 *  @param parameters
 *  @param uploadProgress
 *  @param block          AFMultipartFormData    Construct form data.
 *  @param success
 *  @param failure
 *
 *  @return AFHttpRequestOperation
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                        progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  Download file with progress
 *
 *  @param URLString
 *  @param parameters
 *  @param filePath
 *  @param downloadProgress
 *  @param success
 *  @param failure          
 *
 *  @return AFHTTPRequestOperation
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                       filePath:(NSString*)filePath
               downloadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))downloadProgress
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
