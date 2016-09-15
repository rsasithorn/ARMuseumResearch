//
//  ImageContentsParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 12/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ImageContentsParser.h"

@implementation ImageContentsParser
@synthesize parsingContentFile;
@synthesize imageElement;
@synthesize contents;
@synthesize cosName;

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
    if([elementName isEqualToString:@"Image"])
    {
        imageElement = [[ImagesElement alloc]init];
    
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
        cosName = parsingContentFile;
        if([cosName isEqualToString:@"null"])
        {
            imageElement = [[ImagesElement alloc]init];
            imageElement.cosName = cosName;
            [self.contents addObject:imageElement];
        }
    }
    else if([elementName isEqualToString:@"IFilename"])
    {
        imageElement.cosName = cosName;
        NSLog(@"%@",imageElement.cosName);
        imageElement.picFilename = parsingContentFile;
        NSLog(@"%@",imageElement.picFilename);
    }
    else if([elementName isEqualToString:@"IFiletype"])
    {
        imageElement.picFileType = parsingContentFile;
        NSLog(@"%@",imageElement.picFileType);
    }
    
    if([elementName isEqualToString:@"Image"])
    {
        [self.contents addObject:imageElement];
    }
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}
@end
