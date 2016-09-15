//
//  RefereneObjectIDParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 09/10/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "RefereneObjectIDParser.h"

@implementation RefereneObjectIDParser

//@synthesize cosName;
//@synthesize cID;
@synthesize objectContents;
@synthesize referenceObjectID;
@synthesize element;
@synthesize data;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    BOOL success = [parser parse];
    if(success)
    {
        NSLog(@"Success = %d", success);
    }
    return self.objectContents;
    
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
    objectContents = [[NSMutableArray alloc]init];
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"Cos"])
    {
        referenceObjectID = [[ReferenceObjectID alloc]init];
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
        data = string;
    
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Name"])
    {
        referenceObjectID.cName = data;
        NSLog(@"%@",referenceObjectID.cName);
    }
    else if([elementName isEqualToString:@"CID"])
    {
        referenceObjectID.cid = data;
        NSLog(@"%@",referenceObjectID.cid);
    }
    else if([elementName isEqualToString:@"OID"])
    {
        referenceObjectID.oid = data;
        NSLog(@"%@",referenceObjectID.oid);
    }
    if ([elementName isEqualToString:@"Cos"])
    {
        [self.objectContents addObject:referenceObjectID];
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    //self.currentElementPointer=nil;
    //[objectContents addObject:NULL];
}
@end
