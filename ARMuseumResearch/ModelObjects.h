//
//  ModelObjects.h
//  ARMuseumSingleView
//
//  Created by Sasithorn Rattanarungrot on 06/05/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MetaioSDKViewController.h"

@interface ModelObjects : NSObject
@property (nonatomic, strong)NSString *cosName;
@property (nonatomic) metaio::IGeometry *model;
@property (nonatomic, strong)NSString *modelName;
@property (nonatomic, strong)NSString *modeltype;
@end
