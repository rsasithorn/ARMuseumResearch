//
//  ObjectFromWebService.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 18/08/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface ObjectFromWebService : NSObject
@property (nonatomic, strong)NSString *cosName;
@property (nonatomic) metaio::IGeometry *physicalDescription;
@property (nonatomic) NSString *description;
@property (nonatomic) metaio::IGeometry *object;
@property (nonatomic) NSString *objName;
@property (nonatomic) metaio::IGeometry *details;
@property (nonatomic) NSString *objDetails;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic, copy) NSData *image;
@property (nonatomic) metaio::IGeometry *imageBillboard;
@property (nonatomic) NSString *urlPath;
@property (nonatomic) NSString *place;
@property (nonatomic) metaio::IGeometry *placeBillboard;
@end
