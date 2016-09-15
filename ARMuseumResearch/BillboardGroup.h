//
//  BillboardGroup.h
//  ARMuseumSingleView
//
//  Created by Sasithorn Rattanarungrot on 28/05/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface BillboardGroup : NSObject
@property (nonatomic) metaio::IBillboardGroup *billboardGroup;
@end
