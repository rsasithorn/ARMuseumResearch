//
//  PersonalARViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 20/02/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "PersonalARViewController.h"
#import "EAGLView.h"
@interface PersonalARViewController ()
@end

@implementation PersonalARViewController
@synthesize selectedContents;
@synthesize arrayOfSelectedContents;
@synthesize poses;
@synthesize trackingDataFile;
@synthesize billboardGroup;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[selectedContents valueForKey:@"source"] isEqualToString:@"Home-based"])
    {
        trackingDataFile = [[NSBundle mainBundle] pathForResource:@"HomeBasedPersonalARTracking" ofType:@"xml" inDirectory:@"Assets1"];
    }
    else if([[selectedContents valueForKey:@"source"] isEqualToString:@"Museum-based"])
    {
        trackingDataFile = [[NSBundle mainBundle] pathForResource:@"MuseumBasedPersonalARTracking" ofType:@"xml" inDirectory:@"Assets1"];
    }
    
    /*billboardGroup = m_metaioSDK->createBillboardGroup(0.5f, 3.0f);
    billboardGroup->setBillboardExpandFactors(0.8, 8, 10 );
    m_metaioSDK->setRendererClippingPlaneLimits(10, 2000000);
    billboardGroup->setViewCompressionValues(0.7, 3.0);*/
    
    billboardGroup = m_metaioSDK->createBillboardGroup(1.0f, 3.0f);
    billboardGroup->setBillboardExpandFactors(1, 2, 10 );
    m_metaioSDK->setRendererClippingPlaneLimits(10, 200000);
    if(trackingDataFile)
    {
        bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
        if( !success)
        {
            NSLog(@"No success loading the tracking configuration for the first obj");
        }
        UIImage *image;
        arrayOfSelectedContents = [[NSMutableArray alloc]init];
        NSSet *billboards = [selectedContents valueForKey:@"text"];
        id billboard;
        NSEnumerator *it = [billboards objectEnumerator];
        while((billboard = [it nextObject]) != nil)
        {
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = [selectedContents valueForKey:@"cosname"];
            NSLog(@"%@",museumObjects.cosName);
            museumObjects.data = [billboard valueForKey:@"textonbillboard"];
            NSLog(@"%@",museumObjects.data);
            museumObjects.objType = [billboard valueForKey:@"billboardtype"];
            NSLog(@"%@",museumObjects.objType);
            image = [self getBillboardImageForTitle:museumObjects.data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("TextBillboard", [image CGImage],true);
            billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            [self.arrayOfSelectedContents addObject:museumObjects];
        }
        NSSet *images = [selectedContents valueForKey:@"image"];
        id imagebillboard;
        NSEnumerator *itImage = [images objectEnumerator];
        while((imagebillboard = [itImage nextObject]) != nil)
        {
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = [selectedContents valueForKey:@"cosname"];
            NSLog(@"%@",museumObjects.cosName);
            museumObjects.img = [imagebillboard valueForKey:@"imageonbillboard"];
            NSLog(@"%@",museumObjects.img);
            UIImage *image = [[UIImage alloc]initWithData:museumObjects.img];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Media", [image CGImage], true);
            billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            [self.arrayOfSelectedContents addObject:museumObjects];
        }
        MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
        museumObjects.cosName = @"null";
        [self.arrayOfSelectedContents addObject:museumObjects];
    }
}
- (void)drawFrame
{
    [super drawFrame];
    
    // return if the metaio SDK has not been initialiyed yet
    
    if( !m_metaioSDK )
        return;
    NSLog(@"Found");
    
    MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
    poses = m_metaioSDK->getTrackingValues();
    // m_metaioSDK->setCosOffset(poses[0].coordinateSystemID, objectPose);
    NSString  *trackedCosName;
    if(poses.size())
    {
        trackedCosName = [NSString stringWithFormat:@"%s",poses[0].cosName.c_str()];
        NSLog(@"Found %@",trackedCosName);
        NSLog(@"%f",poses[0].translation.x);
        NSLog(@"%f",poses[0].translation.y);
        NSLog(@"%f",poses[0].translation.z);
        for(int i=0;i<=10;i++)
        {
                museumObjects = arrayOfSelectedContents[i];
                if([museumObjects.cosName isEqualToString:@"null"])
                {
                    break;
                }
                if([museumObjects.cosName isEqualToString:trackedCosName])
                {
                        museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                        museumObjects.object->setVisible(true);
                }
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage*) getBillboardImageForTitle: (NSString*) title
{
    // first lets find out if we're drawing retina resolution or not
    float scaleFactor = [UIScreen mainScreen].scale;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scaleFactor = 2;        // draw in high-res for iPad
    
    // then lets draw
    UIImage* bgImage = nil;
    NSString* imagePath;
    //if( scaleFactor == 1 )	// potentially this is not necessary anyway, because iOS automatically picks 2x version for iPhone4
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"POI_bg" ofType:@"png" inDirectory:@"Assets1/Billboards"];
    
    /*else
     {
     imagePath = [[NSBundle mainBundle] pathForResource:@"POI_bg@2x" ofType:@"png" inDirectory:@"Assets5"];
     }*/
    
    bgImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    UIGraphicsBeginImageContext( bgImage.size );			// create a new image context
    CGContextRef currContext = UIGraphicsGetCurrentContext();
    
    // mirror the context transformation to draw the images correctly
    CGContextTranslateCTM( currContext, 0, bgImage.size.height );
    CGContextScaleCTM(currContext, 1.0, -1.0);
    CGContextDrawImage(currContext,  CGRectMake(0, 0, bgImage.size.width, bgImage.size.height), [bgImage CGImage]);
    
    // now bring the context transformation back to what it was before
    CGContextScaleCTM(currContext, 1.0, -1.0);
    CGContextTranslateCTM( currContext, 0, -bgImage.size.height );
    
    // and add some text...
    CGContextSetRGBFillColor(currContext, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetTextDrawingMode(currContext, kCGTextFill);
    CGContextSetShouldAntialias(currContext, true);
    
    // draw the heading
    float border = 3;//*scaleFactor;
    [title drawInRect:CGRectMake(border, border, bgImage.size.width - 2 * border, bgImage.size.height - 2 * border ) withFont:[UIFont systemFontOfSize:9]];//*scaleFactor]];
    
    // retrieve the screenshot from the current context
    UIImage* blendetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendetImage;
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
