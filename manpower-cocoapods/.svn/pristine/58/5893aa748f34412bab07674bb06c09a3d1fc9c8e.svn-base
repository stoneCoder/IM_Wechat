//
//  SelectionCell.h
//  ComboBox
//
//  Created by Eric Che on 7/17/13.
//  Copyright (c) 2013 Eric Che. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectionCell;
@protocol SelectionCellDelegate <NSObject>
- (void)delAction:(SelectionCell*)cell;
@end


@interface SelectionCell : UITableViewCell
@property (strong,nonatomic) id<SelectionCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet UILabel *lb;
@property (retain, nonatomic) IBOutlet UIImageView *avaterImage;
@property (retain, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)delAction:(id)sender;
@end
