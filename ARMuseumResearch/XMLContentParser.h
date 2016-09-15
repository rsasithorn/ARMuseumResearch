//
//  XMLContentParser.h
//  ARTestAppMetaio
//
//  Created by sr341 on 19/08/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagesElement.h"
#import "ModelElements.h"
#import "XMLElement.h"
#import "MuseumContentElement.h"

//@class XMLElement;


@interface XMLContentParser : NSObject <NSXMLParserDelegate>
{
   
    //NSMutableArray *contents;
    //XMLElement *rootElement;
}
@property(nonatomic,retain)NSString *parsingContentFile;
@property(nonatomic,strong)XMLElement *museumContent;
@property(nonatomic,strong)NSMutableArray *contents;
@property(nonatomic,strong)NSMutableArray *elementArray;
@property(nonatomic,strong)ModelElements *modelElement;
@property(nonatomic,strong)ImagesElement *imageElement;

-(void)parseXMLFile:(NSData *)xmlData;


@end
