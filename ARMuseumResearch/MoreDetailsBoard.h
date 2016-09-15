//
//  MoreDetailsBoard.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 09/02/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface MoreDetailsBoard : NSObject
@property (nonatomic, strong) NSString *cosName;
@property (nonatomic) metaio::IGeometry *moreDetailsObject;
@end
