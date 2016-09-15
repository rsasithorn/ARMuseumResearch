//
//  BillboardContentParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 08/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillboardSingleElement.h"

@interface BillboardContentParser : NSObject <NSXMLParserDelegate>
@property(nonatomic,retain)NSString *parsingContentFile;
@property(nonatomic,strong)BillboardSingleElement *billboardElement;
@property(nonatomic,strong)NSMutableArray *contents;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
