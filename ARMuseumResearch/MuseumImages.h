//
//  MuseumImages.h
//  ARMuseumSingleView
//
//  Created by Sasithorn Rattanarungrot on 10/04/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface MuseumImages : NSObject
@property (nonatomic,strong)NSString *cosName;
@property (nonatomic,strong)NSMutableArray *arrayImages;
@end