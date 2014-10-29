//
//  RLActivity.h
//  manpower
//
//  Created by WangShunzhou on 14-9-17.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RLActivityItem;

@interface RLActivity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *activityItems;
@end

@interface RLActivity (CoreDataGeneratedAccessors)

- (void)addActivityItemsObject:(RLActivityItem *)value;
- (void)removeActivityItemsObject:(RLActivityItem *)value;
- (void)addActivityItems:(NSSet *)values;
- (void)removeActivityItems:(NSSet *)values;

@end
