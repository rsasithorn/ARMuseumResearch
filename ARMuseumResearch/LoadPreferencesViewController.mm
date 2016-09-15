//
//  LoadPreferencesViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 14/02/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import "LoadPreferencesViewController.h"

@interface LoadPreferencesViewController ()

@end

@implementation LoadPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"SelectedObjectTracking" ofType:@"xml" inDirectory:@"Assets1"];
    //NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"Tracking" ofType:@"xml" inDirectory:@"Assets1"];
    if(trackingDataFile)
    {
        bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
        if( !success)
        {
            NSLog(@"No success loading the tracking configuration for the first obj");
        }
        
    }


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
-(void)setArrayOfContents:(NSMutableArray *)arrayOfPreferredContent
{
    if(arrayOfPreferredContent)
    {
        //arrayOfSelectedObject = [[NSMutableArray alloc]initWithObjects: arrayOfPreferredContent, nil];
        arrayOfSelectedObject = [[NSMutableArray alloc]init];
        MuseumObjects *objects = [[MuseumObjects alloc]init];
        arrayOfSelectedObject = arrayOfPreferredContent;
        NSLog(@"Selected contents received");
        for(int i=0;i<=10;i++)
        {
            objects = arrayOfSelectedObject[i];
            NSLog(@"%@",objects.cosName);
           
            if([objects.cosName isEqualToString:@"null"])
            {
                break;
            }
            
        }
    }
}
- (void)drawFrame
{
    [super drawFrame];
    
    // return if the metaio SDK has not been initialiyed yet
    
    if( !m_metaioSDK )
        return;
    
    selectedObjects = [[MuseumObjects alloc]init];
    std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();
    if(poses.size())
    {
        NSString *cosname = [NSString stringWithFormat:@"%s",poses[0].cosName.c_str()];
        //NSLog(@"Found %@",cosname);
        for(int i=0;i<=10;i++)
        {
            selectedObjects = arrayOfSelectedObject[i];
            if([selectedObjects.cosName isEqualToString:cosname])
            {
                NSLog(@"Found %@",selectedObjects.cosName);
                selectedObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                selectedObjects.object->setVisible(true);
            }
            else if([selectedObjects.cosName isEqualToString:@"null"])
            {
                break;
            }
        }
    }
    
}
@end
