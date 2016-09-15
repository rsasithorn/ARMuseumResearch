//
//  XMLImageContentParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 29/06/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "XMLImageContentParser.h"
@implementation XMLImageContentParser
@synthesize objectContents;
@synthesize image;
@synthesize object;
@synthesize museumContent;
@synthesize element;
-(NSMutableArray *)parseXMLFile:(NSData *)xmlData
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    objectContents = [[NSMutableArray alloc]init];
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
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"small"])
    {
        element = elementName;
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([element isEqualToString:@"small"])
    {
        object = string;
    }
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"datum"])
    {
        museumContent = [[MuseumContentElement alloc]init];
        museumContent.elementName = @"media";
        museumContent.data = object;
       [objectContents addObject:museumContent];
        museumContent = NULL;
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    museumContent = [[MuseumContentElement alloc]init];
    museumContent.elementName = @"null";
    museumContent.data = @"null";
    [objectContents addObject:museumContent];
}
@end
