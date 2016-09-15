//
//  GoogleMapViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 15/03/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleMapViewController : UIViewController
@property (strong, nonatomic) UIImage *mapImage;
@property (strong, nonatomic) IBOutlet UIImageView *GoogleMapImage;
- (IBAction)closeView:(id)sender;

@end
