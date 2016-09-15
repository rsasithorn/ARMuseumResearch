//
//  XMLContentParser.m
//  ARTestAppMetaio
//
//  Created by sr341 on 19/08/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import "XMLContentParser.h"

@implementation XMLContentParser
@synthesize parsingContentFile;
@synthesize museumContent;
@synthesize elementArray;
@synthesize contents;
@synthesize modelElement;
@synthesize imageElement;

//@synthesize rootElement;
-(void)parseXMLFile:(NSData *)xmlData
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
    //return self.contents;
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
   
    contents = [[NSMutableArray alloc]init];

}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
   if([elementName isEqualToString:@"Cos"])
   {
        museumContent = [[XMLElement alloc]init];
   }
   if([elementName isEqualToString:@"Model"])
   {
       modelElement = [[ModelElements alloc]init];
   }
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
        museumContent.cosName = parsingContentFile;
        NSLog(@"%@",museumContent.cosName);
    }
    else if([elementName isEqualToString:@"Title"])
    {
        museumContent.title = parsingContentFile;
        NSLog(@"%@",museumContent.title);
    }
    else if([elementName isEqualToString:@"Details"])
    {
        museumContent.details = parsingContentFile;
        NSLog(@"%@",museumContent.details);
    }
    else if([elementName isEqualToString:@"MFilename"])
    {
        modelElement.modelFilename = parsingContentFile;
        NSLog(@"%@",modelElement.modelFilename);
    }
    else if ([elementName isEqualToString:@"MFiletype"])
    {
        modelElement.modelFileType = parsingContentFile;
        NSLog(@"%@",modelElement.modelFileType);
        [museumContent.models addObject:modelElement];
    }
    else if ([elementName isEqualToString:@"IFilename"])
    {
        imageElement.picFilename = parsingContentFile;
        NSLog(@"%@",imageElement.picFilename);
    }
    else if ([elementName isEqualToString:@"IFiletype"])
    {
        imageElement.picFileType = parsingContentFile;
        NSLog(@"%@",imageElement.picFileType);
        [museumContent.images addObject:imageElement];
    }
    
    if([elementName isEqualToString:@"Cos"])
    {
        [self.contents addObject:museumContent];
        
    }
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}

@end
