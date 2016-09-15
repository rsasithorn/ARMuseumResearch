//
//  ViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 30/07/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)starWebserviceAR
{
    ARMuseumWebserviceViewController *arMuseumWebserviceViewController = [[ARMuseumWebserviceViewController alloc]initWithNibName:@"ARMuseumWebserviceViewController" bundle:Nil];
    arMuseumWebserviceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:arMuseumWebserviceViewController animated:YES completion:NULL];
    
}

- (IBAction)startAR {
    ARMuseumViewController *arMuseumViewController = [[ARMuseumViewController alloc]initWithNibName:@"ARMuseumViewController" bundle:Nil];
    arMuseumViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:arMuseumViewController animated:YES completion:NULL];
}

- (IBAction)viewPersonalAR
{
    ARBrowserViewController *arBrowserViewController = [[ARBrowserViewController alloc]initWithNibName:@"ARBrowserViewController" bundle:Nil];
    arBrowserViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:arBrowserViewController animated:YES completion:NULL];
}

- (IBAction)startPhotogrammetry
{
    PhotogrammetryViewController *photogrammetryViewController = [[PhotogrammetryViewController alloc]initWithNibName:@"PhotogrammetryViewController" bundle:Nil];
    photogrammetryViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:photogrammetryViewController animated:YES completion:NULL];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
@end
