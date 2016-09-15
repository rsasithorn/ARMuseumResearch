//
//  LoadPreferencesViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 14/02/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaioSDKViewController.h"
#import "MuseumObjects.h"

@interface LoadPreferencesViewController : MetaioSDKViewController
{

    NSMutableArray *arrayOfSelectedObject;
    MuseumObjects *selectedObjects;

}
-(void)setArrayOfContents:(NSMutableArray *)arrayOfPreferredContent;

@end
