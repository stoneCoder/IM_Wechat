//
//  FriendDataHelp.m
//  manpower
//
//  Created by hanjin on 14-6-13.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "FriendDataHelp.h"
#import "XMPPManager.h"
@implementation FriendDataHelp
DEFINE_SINGLETON_FOR_CLASS(FriendDataHelp)

-(NSMutableArray *)friendGroupList{
    
    if (!self.groupList) {
        self.groupList=[[NSMutableArray alloc]init];
//        [[self fetchedResultsController] performFetch:nil];
//        NSArray * list= [[self fetchedResultsController] fetchedObjects];
//        if (list && list>0) {
//            for (XMPPGroupCoreDataStorageObject * group in list) {
//                SectionInfoModel * model=[[SectionInfoModel alloc]init];
//                model.name=group.name;
//                [self.groupList addObject:model];
//            }
//        }
    }
    NSArray * list= [[self fetchedResultsController] fetchedObjects];
    [self.groupList removeAllObjects];
    for (XMPPGroupCoreDataStorageObject * group in list) {
        SectionInfoModel * model=[[SectionInfoModel alloc]init];
        model.name=group.name;
        [self.groupList addObject:model];
    }

    return self.groupList;
}
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[XMPPManager sharedInstance] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"XMPPGroupCoreDataStorageObject"
                              inManagedObjectContext:moc];
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"name"
                                                                                  cacheName:nil];
		[fetchedResultsController setDelegate:self];
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
        
        NSArray * groupList= [[self fetchedResultsController] fetchedObjects];
        BOOL hasDefaultGroup = NO;
        for (XMPPGroupCoreDataStorageObject * group in groupList) {
            if ([group.name isEqualToString:kDefaultGroupName]) {
                hasDefaultGroup = YES;
                break;
            }
        }
        if (!hasDefaultGroup) {
            [XMPPGroupCoreDataStorageObject insertGroupName:kDefaultGroupName inManagedObjectContext:moc];
            [moc save:nil];
        }

	}
    
	return fetchedResultsController;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    NSArray * list= [[self fetchedResultsController] fetchedObjects];
//    [self.groupList removeAllObjects];
//    for (XMPPGroupCoreDataStorageObject * group in list) {
//        SectionInfoModel * model=[[SectionInfoModel alloc]init];
//        model.name=group.name;
//        [self.groupList addObject:model];
//    }
}

@end
