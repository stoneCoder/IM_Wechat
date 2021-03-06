//
//  QBImagePickerController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Views
#import "QBImagePickerGroupCell.h"
#import "QBAssetsCollectionViewLayout.h"

// ViewControllers
#import "QBAssetsCollectionViewController.h"

ALAssetsFilter * ALAssetsFilterFromQBImagePickerControllerFilterType(QBImagePickerControllerFilterType type) {
    switch (type) {
        case QBImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case QBImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case QBImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface QBImagePickerController () <QBAssetsCollectionViewControllerDelegate>{
    NSIndexPath *selectedIndexPath;
}

@property (nonatomic, strong, readwrite) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy, readwrite) NSArray *assetsGroups;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedAssetURLs;

@end

@implementation QBImagePickerController

+ (BOOL)isAccessible
{
    return ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        // Property settings
        self.selectedAssetURLs = [NSMutableSet set];
        
        self.groupTypes = @[
                            @(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupPhotoStream),
                            @(ALAssetsGroupAlbum)
                            ];
        self.filterType = QBImagePickerControllerFilterTypeNone;
        self.showsCancelButton = YES;
        _selectedAssets = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%@",self.navigationItem.rightBarButtonItem);
    // View settings
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Create assets library instance
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.assetsLibrary = assetsLibrary;
    
    // Register cell classes
    [self.tableView registerClass:[QBImagePickerGroupCell class] forCellReuseIdentifier:@"GroupCell"];
    // View controller settings
    self.title = NSLocalizedStringFromTable(@"title", @"QBImagePickerController", nil);
    [self loadAssetsGroupsWithTypes:self.groupTypes
                         completion:^(NSArray *assetsGroups) {
                             self.assetsGroups = assetsGroups;
                             
                             [self.tableView reloadData];
                             //                             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                             if (self.assetsGroups.count) {
                                 [self pushToAssetsCollectionViewController:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
                             }
                         }];
    // Validation
//    self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
//        selectedIndexPath = nil;
//    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

#pragma mark - Accessors

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    // Show/hide cancel button
    if (showsCancelButton) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [self setupRightBarButtonItem:self withAction:@selector(cancel:) withViewController:nil];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
    
}

-(void)setupRightBarButtonItem:(id)target withAction:(SEL)selector withViewController:(UIViewController*)viewController{
    if (viewController == nil) {
        viewController = target;
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    [rightButton setTitle:NSLocalizedStringFromTable(@"cancel", @"QBImagePickerController", nil) forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//        rightButton.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {//iOS7 custom rightBarButtonItem 偏移
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -10;
        viewController.navigationItem.rightBarButtonItems = @[spaceButtonItem, rightBarButtonItem];
    }else{
        viewController.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

//- (void)setRemoveBarItemBackground:(BOOL)removeBarItemBackground{
//    _removeBarItemBackground = removeBarItemBackground;
//    if (removeBarItemBackground) {
//        NSArray *buttomItemViews = [[self.navigationItem.rightBarButtonItem view] subviews];
//        for (UIView *view in ) {
//            <#statements#>
//        }
//        
//    }
//}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
//    if (allowsMultipleSelection) {
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
//    } else {
//        [self.navigationItem setRightBarButtonItem:nil animated:NO];
//    }
}


#pragma mark - Actions

- (void)done:(id)sender
{
    [self passSelectedAssetsToDelegate];
}

- (void)cancel:(id)sender
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (void)pushToAssetsCollectionViewController: (NSIndexPath*)indexPath{
    [self pushToAssetsCollectionViewController:indexPath animated:YES];
}

- (void)pushToAssetsCollectionViewController: (NSIndexPath*)indexPath animated:(BOOL)animated{
    selectedIndexPath = indexPath;
    QBAssetsCollectionViewController *assetsCollectionViewController = [[QBAssetsCollectionViewController alloc] initWithCollectionViewLayout:[QBAssetsCollectionViewLayout layout]];
    assetsCollectionViewController.imagePickerController = self;
    assetsCollectionViewController.filterType = self.filterType;
//    assetsCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetsCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetsCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    assetsCollectionViewController.delegate = self;
    assetsCollectionViewController.assetsGroup = assetsGroup;
    
//    for (NSURL *assetURL in self.selectedAssetURLs) {
//        [assetsCollectionViewController selectAssetHavingURL:assetURL];
//    }
    
    [self.navigationController pushViewController:assetsCollectionViewController animated:animated];
}

#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    // Check the number of selected assets
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}


#pragma mark - Managing Assets

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(weakSelf.filterType)];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = [sortedAssetsGroups objectAtIndex:i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}

- (void)passSelectedAssetsToDelegate
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    
    for (NSURL *selectedAssetURL in self.selectedAssetURLs) {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary assetForURL:selectedAssetURL
                            resultBlock:^(ALAsset *asset) {
                                // Add asset
                                [assets addObject:asset];
                                
                                // Check if the loading finished
                                if (assets.count == weakSelf.selectedAssetURLs.count) {
                                    // Delegate
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:)]) {
                                        [self.delegate imagePickerController:self didSelectAssets:[assets copy]];
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    cell.assetsGroup = assetsGroup;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [backgroundView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        cell.selectedBackgroundView = backgroundView;
    }

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToAssetsCollectionViewController:indexPath];
}


#pragma mark - QBAssetsCollectionViewControllerDelegate

- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Add asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        if (![self.selectedAssetURLs containsObject:assetURL]) {
            [self.selectedAssetURLs addObject:assetURL];
            [self.selectedAssets addObject:asset];
        }
    } else {
        // Delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)]) {
            [self.delegate imagePickerController:self didSelectAsset:asset];
        }
    }
}

- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Remove asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs removeObject:assetURL];
        [self.selectedAssets removeObject:asset];
    }
}

- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController
{
    [self passSelectedAssetsToDelegate];
}

@end
