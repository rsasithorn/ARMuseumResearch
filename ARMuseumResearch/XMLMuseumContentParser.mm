//
//  XMLMuseumContentParser.m
//  ARTestAppMetaio
//
//  Created by sr341 on 03/10/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import "XMLMuseumContentParser.h"

@implementation XMLMuseumContentParser
@synthesize objectContents;
@synthesize image;
@synthesize descriptions;
@synthesize object;
@synthesize museumContent1;
@synthesize museumContent2;
@synthesize museumContent3;
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
    //self.rootElement = nil;
    //self.currentElementPointer = nil;
    //museumContent = [[MuseumContentElement alloc]init];
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"Object"])
    {
        //museumContent1 = [[MuseumContentElement alloc]init];
        //museumContent1.elementName = @"object";
        element = elementName;
    }
    else if([elementName isEqualToString:@"Description"])
    {
        //museumContent2 = [[MuseumContentElement alloc]init];
        //museumContent2.elementName = @"description";
        element = elementName;
    }
    else if([elementName isEqualToString:@"media"])
    {
        //museumContent3 = [[MuseumContentElement alloc]init];
        //museumContent3.elementName = @"media";
        element = elementName;
    }
    else if([elementName isEqualToString:@"Museum"])
    {
        element = elementName;
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    /*if([self.currentElementPointer.text length] > 0)
    {
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
    }
    else
    {
        self.currentElementPointer.text=string;
    }*/
    if ([element isEqualToString:@"Object"])
    {
        //museumContent1.data = string;
        object = string;
        //NSLog(@"%@",object);
        //[self.objectContents addObject:museumContent1];
    }
    else if([element isEqualToString:@"Description"])
    {
        //museumContent2.data = string;
        object = string;
        //NSLog(@"%@",object);
        //NSLog(@"%@",museumContent2.data);
        //[self.objectContents addObject:museumContent2];
    }
    else if([element isEqualToString:@"media"])
    {
        //museumContent3.data = string;
        //NSLog(@"%@",museumContent3.data);
        //[self.objectContents addObject:museumContent3];
        object = string;
        //NSLog(@"%@",object);
    }
    else if([element isEqualToString:@"Museum"])
    {
        object = string;
    }
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    /*XMLElement *newElement = [[XMLElement alloc]init];
     newElement = nil;
     [self.currentElementPointer.subElements addObject:newElement];*/
    //self.currentElementPointer = self.currentElementPointer.parent;
    if ([elementName isEqualToString:@"Object"])
    {
        museumContent1 = [[MuseumContentElement alloc]init];
        museumContent1.elementName = @"object";
        museumContent1.data = object;
        [objectContents addObject:museumContent1];
        museumContent1 = NULL;
    }
    else if([elementName isEqualToString:@"Description"])
    {
        museumContent2 = [[MuseumContentElement alloc]init];
        museumContent2.elementName = @"description";
        museumContent2.data = object;
        [objectContents addObject:museumContent2];
        museumContent2 = NULL;
    }
    else if([elementName isEqualToString:@"media"])
    {
        museumContent3 = [[MuseumContentElement alloc]init];
        museumContent3.elementName = @"media";
        museumContent3.data = object;
        [objectContents addObject:museumContent3];
        museumContent3 = NULL;
    }
    else if([elementName isEqualToString:@"Museum"])
    {
        museumContent1 = [[MuseumContentElement alloc]init];
        museumContent1.elementName = @"museum";
        museumContent1.data = object;
        [objectContents addObject:museumContent1];
        museumContent1 = NULL;
    }
    element = NULL;
    object = NULL;
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    museumContent1 = [[MuseumContentElement alloc]init];
    museumContent1.elementName = @"null";
    museumContent1.data = @"null";
    [objectContents addObject:museumContent1];
}
@end
