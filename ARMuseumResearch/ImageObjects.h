//
//  ImageObjects.h
//  ARMuseumSingleView
//
//  Created by Sasithorn Rattanarungrot on 01/05/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface ImageObjects : NSObject
@property (nonatomic, strong) NSString *cosName;
@property (nonatomic)metaio::IGeometry *imageObject;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) NSData *image;
@end
