//
//  AFHTTPRequestOperationManager+Progress.m
//  manpower
//
//  Created by WangShunzhou on 14-8-22.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Progress.h"

@implementation AFHTTPRequestOperationManager (Progress)

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                        progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setUploadProgressBlock:uploadProgress];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                      parameters:(id)parameters
                       filePath:(NSString*)filePath
                        downloadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))downloadProgress
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation setDownloadProgressBlock:downloadProgress];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
@end
