//
//  ModelContentsParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 15/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ModelContentsParser.h"

@implementation ModelContentsParser
@synthesize parsingContentFile;
@synthesize modelElements;
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
    if([elementName isEqualToString:@"Cos"])
    {
        modelElements = [[ModelElements alloc]init];
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
    }
    else if([elementName isEqualToString:@"MFilename"])
    {
        modelElements.cosName = cosName;
        NSLog(@"%@",modelElements.cosName);
        modelElements.modelFilename = parsingContentFile;
        NSLog(@"%@",modelElements.modelFilename);
    }
    else if([elementName isEqualToString:@"MFiletype"])
    {
        modelElements.modelFileType = parsingContentFile;
        NSLog(@"%@",modelElements.modelFileType);
    }
    
    if([elementName isEqualToString:@"Cos"])
    {
        if([cosName isEqualToString:@"null"])
        {
            modelElements.cosName = cosName;
            [self.contents addObject:modelElements];
        }
        else
        {
            [self.contents addObject:modelElements];
        }
    }

}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}
@end
