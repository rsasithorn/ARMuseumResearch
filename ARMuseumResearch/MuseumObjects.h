//
//  MuseumObjects.h
//  ARMuseumSingleView
//
//  Created by Sasithorn Rattanarungrot on 06/05/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetaioSDKViewController.h"

@interface MuseumObjects : NSObject
@property(nonatomic,strong) NSString *cosName;
@property(nonatomic) NSString *objType;
@property(nonatomic) metaio::IGeometry *object;
@property(nonatomic,copy) NSString *data;
@property(nonatomic,copy)NSData *img;
@property(nonatomic,copy)NSString *imagePath;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;
@end
