//
//  QBAssetsCollectionCheckmarkView.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2014/01/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QBAssetsCollectionCheckmarkViewDelegate;
@class QBAssetsCollectionViewCell;

@interface QBAssetsCollectionCheckmarkView : UIView

@property (nonatomic,assign) BOOL checked;

@property (nonatomic,assign) BOOL animated;

@property (nonatomic,assign) BOOL bounced;

@property (nonatomic, assign) id<QBAssetsCollectionCheckmarkViewDelegate> delegate;

@property (nonatomic, assign) QBAssetsCollectionViewCell *assetCollectionCell;

- (void)check;
- (void)uncheck;

@end


@protocol QBAssetsCollectionCheckmarkViewDelegate<NSObject>
@optional

-(BOOL)checkmarkViewShouldCheck:(QBAssetsCollectionCheckmarkView*)checkmarkView;
-(void)checkmarkViewDidCheck:(QBAssetsCollectionCheckmarkView*)checkmarkView;
-(void)checkmarkViewDidUncheck:(QBAssetsCollectionCheckmarkView*)checkmarkView;


@end