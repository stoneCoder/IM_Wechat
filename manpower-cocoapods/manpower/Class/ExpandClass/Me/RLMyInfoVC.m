//
//  RLMyInfo.m
//  manpower
//
//  Created by WangShunzhou on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLMyInfoVC.h"
#import "XMPPManager.h"
#import "IMLabel.h"
#import "XMPPvCardTemp.h"
#import "IBActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RLMyInfoHeaderView.h"
#import "RLMyInfo.h"
#import <objc/runtime.h>
#import "SWDatePickerView.h"
#import "RLSignatureVC.h"
#import "RLResetPasswordVC.h"
#import "IMMessageHelper.h"
#import "UIImage+Resize.h"
#import "UIImage+MostColor.h"
#import "UIColor+ColorComponent.h"

//static void *kPhotoActionSheetKey = "kPhotoActionSheetKey";
static void *kGenderActionSheetKey = "kGenderActionSheetKey";
static void *kCurrentActionSheetKey;


@interface RLMyInfoVC()<IBActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SWDatePickerViewDelegate>{
    UILabel *signatureLabel;
    RLMyInfo *myInfo;
    NSIndexPath *selectedIndexPath;
    SWDatePickerView *datePicker;
}
@property(strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@end

@implementation RLMyInfoVC

static NSString *photoCell = @"PhotoCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleText:@"个人信息"];
        [self makeNaviLeftButtonVisible:YES];
        self.hidesBottomBarWhenPushed = YES;
        xmpp = [XMPPManager sharedInstance];
        [xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        myInfo = [RLMyInfo sharedRLMyInfo];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self setupHeaderView];
    if (iOS7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (myInfo.birthday.length) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:myInfo.birthday];
        datePicker = [SWDatePickerView datePickerViewWithDate:date];
    }else{
        datePicker = [SWDatePickerView datePickerView];
    }
    datePicker.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initailize views
-(void)setupHeaderView{
    self.headerView = [RLMyInfoHeaderView headerViewWithViewController:self];
    
    // 设置tableview大小
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self bindMyInfoValuesToView];
}

-(void)bindMyInfoValuesToView{
    // 自己的昵称
    @weakify(self);
    [RACObserve(myInfo, name) subscribeNext:^(NSString *newName){
        @strongify(self);
        self.headerView.titleTextField.text = newName;
    }];
    
    /*
    [RACObserve(myInfo, localPhoto) subscribeNext:^(NSString *newName){
        @strongify(self);
        UIImage *photoImage;
        if (myInfo.localPhoto.length) {
            photoImage = [UIImage imageWithContentsOfFile:myInfo.localPhoto];
        }else{
            photoImage = [UIImage imageNamed:@"defaultPerson"];
        }
        self.headerView.photoIV.image = photoImage;
    }];
    
    [RACObserve(myInfo, localBackground) subscribeNext:^(NSString *newName){
        @strongify(self);
        UIImage *backgroundImage;
        if (myInfo.localBackground.length) {
            backgroundImage = [UIImage imageWithContentsOfFile:myInfo.localBackground];
        }else{
            backgroundImage = [UIImage imageNamed:@"contact_bg"];
        }
        self.headerView.backgroundIV.image = backgroundImage;
    }];*/
    
    [RACObserve(myInfo, photo) subscribeNext:^(NSString *newName){
        @strongify(self);
        NSURL *url = [NSURL URLWithString:newName];
        UIImage *defaultPhoto = self.headerView.photoIV.image ? self.headerView.photoIV.image : IMAGE_DEFAULT_PERSON;
        [self.headerView.photoIV sd_setImageWithURL:url placeholderImage:defaultPhoto];
    }];
    
    [RACObserve(myInfo, background) subscribeNext:^(NSString *newName){
        @strongify(self);
        NSURL *url = [NSURL URLWithString:newName];
        UIImage *defaultBackground = self.headerView.backgroundIV.image ? self.headerView.backgroundIV.image : IMAGE_DEFAULT_BACKGROUND;
        [self.headerView.backgroundIV sd_setImageWithURL:url placeholderImage:defaultBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){}];
    }];
    
    [RACObserve(self.headerView.backgroundIV, image) subscribeNext:^(UIImage *image){
        @strongify(self);
        UIImage *rightBottomImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(100, 280, 200, 36))];
        UIColor *color = [rightBottomImage mostColor];
        BOOL isLightColor = [color isLightColor];
        UIColor *textColor = isLightColor ? [UIColor blackColor] : [UIColor whiteColor];
        self.headerView.titleTextField.textColor = textColor;
    }];
    
}

#pragma mark

-(void)changePhotoWithImage:(UIImage *)image
{
    NSString *filename = [IMMessageHelper generateUUID];
    NSString *fullPath = [APP_TMP_DIR_PATH stringByAppendingPathComponent:filename];
    if ([IMMessageHelper saveImage:image withFullFilePath:fullPath]) {
        myInfo.localPhoto = fullPath;
        [myInfo updatePhoto];
    }

}

-(void)changeBackgroundWithImage:(UIImage *)image
{
    NSString *filename = [IMMessageHelper generateUUID];
    NSString *fullPath = [APP_TMP_DIR_PATH stringByAppendingPathComponent:filename];
    if ([IMMessageHelper saveImage:image withFullFilePath:fullPath]) {
        myInfo.background = fullPath;
        [myInfo updateBackground];
    }
    
}


#pragma mark - tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == 0) {
        row = 3;
    }else{
        row = 1;
    }
    return row;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    CGFloat height = 0;
//    if (section==0) {
//        height = 20;
//    }
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    if (indexPath.section == 0 && indexPath.row == 2){
        signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
        signatureLabel.font = [UIFont systemFontOfSize:14];
        signatureLabel.numberOfLines = 0;
        signatureLabel.text = myInfo.signature;
        [signatureLabel sizeToFit];
        height = signatureLabel.frame.size.height+20;
        height = height < 50 ? 50 :height;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    footerView.backgroundColor = UIColorFromRGB(0xeeeeee);
    UIImageView *topSeperatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    topSeperatorIV.backgroundColor = UIColorFromRGB(0xcccccc);
//    topSeperatorIV.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIImageView *bottomSeperatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, 0.5)];
    bottomSeperatorIV.backgroundColor = UIColorFromRGB(0xcccccc);
//    topSeperatorIV.layer.shadowOffset = CGSizeMake(0, 0);

    
//    [footerView addSubview:topSeperatorIV];
//    [footerView addSubview:bottomSeperatorIV];
    return footerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    __block UITableView *weakTableView = tableView;
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:photoCell];
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = UIColorFromRGB(0xeeeeee);
        cell.selectedBackgroundView = selectedBackgroundView;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
//        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
//            [RACObserve(cell, isSelected) subscribeNext:^(NSNumber *selected){
//                if ([selected boolValue]) {
//                    cell.textLabel.textColor = [UIColor blackColor];
//                    cell.detailTextLabel.textColor = [UIColor blackColor];
//                }
//            }];
//        }
    }



    if (indexPath.section == 0) {
        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"昵称";
//                cell.detailTextLabel.text = xmpp.xmppStream.myJID.user;
//                break;
            case 0:
                cell.textLabel.text = @"性别";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (myInfo.sex) {
                    __block NSString *gender;
                    // 绑定性别
                    [RACObserve(myInfo, sex) subscribeNext:^(NSNumber *newValue){
                        switch ([newValue integerValue]) {
                            case 0:
                                gender = @"男";
                                break;
                                
                            default:
                                gender = @"女";
                                break;
                        }
                        cell.detailTextLabel.text = gender;
                    }];
                }else{
                    cell.detailTextLabel.text = @"";
                }
                break;
            case 1:
            {
                cell.textLabel.text = @"生日";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (myInfo.sex) {
                    // 绑定生日
                    [RACObserve(myInfo, birthday) subscribeNext:^(NSString *newValue){
                        cell.detailTextLabel.text = newValue;
                    }];
                }else{
                    cell.detailTextLabel.text = @"";
                }

                break;
            }
                //        case 3:
                //            cell.textLabel.text = @"所在地";
                //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //            break;
            case 2:{
                cell.textLabel.text = @"个性签名";
                cell.detailTextLabel.text = myInfo.signature;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.numberOfLines = 0;
                [cell.detailTextLabel sizeToFit];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [RACObserve(myInfo, signature) subscribeNext:^(NSString *newValue){
                    cell.detailTextLabel.text = newValue;
//                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                }];
                break;
            }
            default:
                break;
        }
    }else{
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block UITableView *weakTableView = tableView;
    selectedIndexPath = indexPath;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{    //性别
                IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"女" otherButtonTitles:@"男", nil];
                void (^genderSelectBlock)(NSInteger);
                genderSelectBlock = ^(NSInteger buttonIndex){
                    if (buttonIndex == 0) {
                        myInfo.sex = @1;
                        [myInfo updateInfo];
                    }else if (buttonIndex == 1){
                        myInfo.sex = @0;
                        [myInfo updateInfo];
                    }
                    [weakTableView deselectRowAtIndexPath:indexPath animated:YES];
                };
                objc_setAssociatedObject(actionSheet, kGenderActionSheetKey, genderSelectBlock, OBJC_ASSOCIATION_COPY);
                kCurrentActionSheetKey = kGenderActionSheetKey;
                [actionSheet showInView:self.view];
                break;
            }
            case 1:{    //生日

                [datePicker showInView:self.view];

                break;
            }
            case 2:{    //个性签名
                RLSignatureVC *signatureVC = [[RLSignatureVC alloc] init];
                [self.navigationController pushViewController:signatureVC animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
                        // 修改密码
        RLResetPasswordVC *resetPasswordVC = [[RLResetPasswordVC alloc] init];
        [self.navigationController pushViewController:resetPasswordVC animated:YES];
    }

}

#pragma mark - actionsheet delegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    void(^block)(NSInteger) = objc_getAssociatedObject(actionSheet, kCurrentActionSheetKey);
    block(buttonIndex);
}

#pragma mark - DatePickerView Delegate
-(void)datePickerView:(SWDatePickerView *)datePickerView withDate:(NSDate *)date cancel:(BOOL)cancel{
    if (!cancel) {
        NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        myInfo.birthday = [dateFormatter stringFromDate:date];
        [myInfo updateInfo];
    }
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}
@end
