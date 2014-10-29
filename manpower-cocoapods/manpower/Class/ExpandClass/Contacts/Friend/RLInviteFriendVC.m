//
//  RLInviteFriendVC.m
//  manpower
//
//  Created by Wang Shunzhou on 10/27/14.
//  Copyright (c) 2014 WHZM. All rights reserved.
//

#import "RLInviteFriendVC.h"
#import <AddressBook/AddressBook.h>

@interface RLInviteFriendVC ()

@end

@implementation RLInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNaviLeftButtonVisible:YES];
    
    CFErrorRef err;
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(nil, &err);
    ABAddressBookRequestAccessWithCompletion(ab, ^(bool granted, CFErrorRef error){
        if (granted) {
            CFIndex count = ABAddressBookGetPersonCount(ab);
            NSLog(@"%d=======",(int)count);
            NSArray *array = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(ab));
            NSLog(@"%@",array);
        }else{
            NSLog(@"not granted");
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
