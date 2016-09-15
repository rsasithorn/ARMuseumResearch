//
//  ARBrowserViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 17/02/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ARBrowserViewController.h"

@interface ARBrowserViewController ()

@end

@implementation ARBrowserViewController
@synthesize tabBarController = _tabBarController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController = [[UITabBarController alloc]init];
    [self.view addSubview:self.tabBarController.view];
    
    PersonalARTableViewController *personalARTableViewController = [[PersonalARTableViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navPersonalAR = [[UINavigationController alloc]initWithRootViewController:personalARTableViewController];
    //[self.tabBarController setViewControllers:[NSArray arrayWithObjects:navPersonalAR,nil]];
    
    GeolocationTableViewController *geoLocationTableViewcontroller = [[GeolocationTableViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navGeoLocation = [[UINavigationController alloc]initWithRootViewController:geoLocationTableViewcontroller];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:navPersonalAR,navGeoLocation,nil]];

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
