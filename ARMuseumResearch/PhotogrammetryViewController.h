//
//  PhotogrammetryViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 26/06/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectionViewCell.h"
static NSString *kCollectionViewCellIdentifier = @"Cells";
@interface PhotogrammetryViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
- (IBAction)close:(id)sender;
- (IBAction)sendRequest:(id)sender;
- (IBAction)takePhotos:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)startTakingPhotos:(id)sender;
- (IBAction)stopTakingPicturesAtIntervals:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startStopButton;
@property (strong, nonatomic) IBOutlet UIView *cameraView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic,strong) NSMutableArray *capturedImages;
@property (nonatomic) NSArray *dataArray;
@end
