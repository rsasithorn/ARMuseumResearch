//
//  PersonalARViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 20/02/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "MetaioSDKViewController.h"
#import "MuseumObjects.h"
@interface PersonalARViewController : MetaioSDKViewController
@property (nonatomic, strong) NSManagedObject *selectedContents;
@property (nonatomic, strong) NSMutableArray *arrayOfSelectedContents;
@property (nonatomic) std::vector<metaio::TrackingValues> poses;
@property (nonatomic, strong) NSString *trackingDataFile;
@property (nonatomic) metaio::IBillboardGroup *billboardGroup;
@end
