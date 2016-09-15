//
//  BillboardContentParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 08/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "BillboardContentParser.h"

@implementation BillboardContentParser
@synthesize parsingContentFile;
@synthesize billboardElement;
@synthesize contents;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    //contents = [[NSMutableArray alloc]init];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    BOOL success = [parser parse];
    if(success)
    {
        NSLog(@"Success = %d", success);
    }
    return self.contents;
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
    contents = [[NSMutableArray alloc]init];
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"Cos"])
    {
        billboardElement = [[BillboardSingleElement alloc]init];
    }
}
    
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    parsingContentFile = string;
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Name"])
    {
        billboardElement.cosName = parsingContentFile;
        NSLog(@"%@",billboardElement.cosName);
    }
    else if([elementName isEqualToString:@"Title"])
    {
        billboardElement.title = parsingContentFile;
        NSLog(@"%@",billboardElement.title);
    }
    else if([elementName isEqualToString:@"Details"])
    {
        billboardElement.details = parsingContentFile;
        NSLog(@"%@",billboardElement.details);
    }
    else if([elementName isEqualToString:@"Place"])
    {
        billboardElement.place = parsingContentFile;
        NSLog(@"%@",billboardElement.place);
    }
    
    if([elementName isEqualToString:@"Cos"])
    {
        [self.contents addObject:billboardElement];
    }
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}
@end

