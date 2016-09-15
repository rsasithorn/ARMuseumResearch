//
//  XMLElement.h
//  ARTestAppMetaio
//
//  Created by Sasithorn Rattanarungrot on 01/09/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject
@property (nonatomic, strong) NSString *cosName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *images;
@end
