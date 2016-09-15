//
//  ImageContentsParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 12/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagesElement.h"

@interface ImageContentsParser : NSObject <NSXMLParserDelegate>
@property(nonatomic,retain)NSString *parsingContentFile;
@property(nonatomic,strong)ImagesElement *imageElement;
@property(nonatomic,strong)NSMutableArray *contents;
@property(nonatomic,retain)NSString *cosName;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
