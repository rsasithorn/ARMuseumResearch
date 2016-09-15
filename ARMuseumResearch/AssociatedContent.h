//
//  AssociatedContent.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 21/04/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetaioSDKViewController.h"

@interface AssociatedContent : NSObject
@property(nonatomic,strong)NSString *cosName;
@property(nonatomic,strong) NSString *objNumber;
@property(nonatomic) NSString *objType;
@property(nonatomic) metaio::IGeometry *objImage;
@property(nonatomic,copy) NSString *urldata;
@property(nonatomic,copy)NSData *img;
@property(nonatomic)NSString *latitude;
@property(nonatomic)NSString *longitude;
@end
