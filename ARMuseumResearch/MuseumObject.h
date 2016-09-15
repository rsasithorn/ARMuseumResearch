//
//  MuseumObject.h
//  ARTestAppMetaio
//
//  Created by sr341 on 14/10/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface MuseumObject : NSObject
@property (nonatomic,strong)NSString *cosName;
@property (nonatomic)metaio::IGeometry *title;
@property (nonatomic)NSString *billboardTitle;
@property (nonatomic)metaio::IGeometry *details;
@property (nonatomic)NSString *billboardDetails;
@property (nonatomic)metaio::IGeometry *place;
@property (nonatomic)NSString *placeName;

@end
