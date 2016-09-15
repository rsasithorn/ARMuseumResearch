//
//  PhotogrammetryViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 26/06/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import "PhotogrammetryViewController.h"

@interface PhotogrammetryViewController ()
@end

@implementation PhotogrammetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.capturedImages = [[NSMutableArray alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:3];
        [self.toolBar setItems:toolbarItems animated:NO];
        NSLog(@"The camera is not working");
    }
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.capturedImages count];
    NSLog(@"set up the number of items");

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.imageViewBackgroundImage.image = self.capturedImages[indexPath.row];
    cell.imageViewBackgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
-(UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.itemSize = CGSizeMake(200.0f, 200.0f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    return flowLayout;
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

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendRequest:(id)sender
{
    
    
}

- (IBAction)takePhotos:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}
- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}
- (IBAction)startTakingPhotos:(id)sender
{
    /*
     Start the timer to take a photo every 1.5 seconds.
     
     CAUTION: for the purpose of this sample, we will continue to take pictures indefinitely.
     Be aware we will run out of memory quickly.  You must decide the proper threshold number of photos allowed to take from the camera.
     One solution to avoid memory constraints is to save each taken photo to disk rather than keeping all of them in memory.
     In low memory situations sometimes our "didReceiveMemoryWarning" method will be called in which case we can recover some memory and keep the app running.
     */
    self.startStopButton.title = NSLocalizedString(@"Stop", @"Title for overlay view controller start/stop button");
    [self.startStopButton setAction:@selector(stopTakingPicturesAtIntervals:)];
    
    //self.doneButton.enabled = NO;
    //self.delayedPhotoButton.enabled = NO;
    //self.takePictureButton.enabled = NO;
    
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:YES];
    [self.cameraTimer fire]; // Start taking pictures right away.
}
- (IBAction)stopTakingPicturesAtIntervals:(id)sender
{
    // Stop and reset the timer.
    [self.cameraTimer invalidate];
    self.cameraTimer = nil;
    //[self finishAndUpdate];
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"CameraView" owner:self options:nil];
        self.cameraView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.cameraView;
        self.cameraView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        NSLog(@"Taken an image");
        return;
    }
    
    [self finishAndUpdate];
}
- (void)finishAndUpdate
{
    NSLog(@"get in finish and update");
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    
    /* end of subclass-based cells block */
    // Configure layout
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    /*if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            //[self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }*/
    
    self.imagePickerController = nil;
}
@end
