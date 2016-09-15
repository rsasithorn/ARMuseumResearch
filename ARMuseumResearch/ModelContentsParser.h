//
//  ModelContentsParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 15/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelElements.h"

@interface ModelContentsParser : NSObject <NSXMLParserDelegate>
@property(nonatomic,retain)NSString *parsingContentFile;
@property(nonatomic,strong)ModelElements *modelElements;
@property(nonatomic,strong)NSMutableArray *contents;
@property(nonatomic,strong)NSString *cosName;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
