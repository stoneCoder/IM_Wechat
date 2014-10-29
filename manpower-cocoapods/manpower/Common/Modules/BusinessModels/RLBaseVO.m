//
//  RLBaseVO.m
//  manpower
//
//  Created by hanjin on 14-6-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVO.h"

@implementation RLBaseVO
-(id) initWithDictionary:(NSMutableDictionary*) jsonObject{
    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    self.unDefine=value;
}
@end
