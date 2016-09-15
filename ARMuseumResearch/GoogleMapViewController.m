//
//  GoogleMapViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 15/03/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "GoogleMapViewController.h"

@interface GoogleMapViewController ()

@end

@implementation GoogleMapViewController
@synthesize mapImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*self.GoogleMapImage = [[UIImageView alloc]initWithImage:mapImage];
    self.GoogleMapImage.center = self.view.center;
    [self.view addSubview:self.GoogleMapImage];*/
    self.GoogleMapImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.GoogleMapImage.contentMode = UIViewContentModeScaleAspectFill;
    self.GoogleMapImage.image = mapImage;
    self.GoogleMapImage.center = self.view.center;
    [self.view addSubview:self.GoogleMapImage];
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

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
