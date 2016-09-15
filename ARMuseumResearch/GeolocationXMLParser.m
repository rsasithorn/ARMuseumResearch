//
//  GeolocationXMLParser.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 14/04/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "GeolocationXMLParser.h"

@implementation GeolocationXMLParser
@synthesize location;
@synthesize geolocation;
@synthesize parsingContentFile;
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
    return self.location;
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
    location = [[NSMutableArray alloc]init];
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"Cos"])
    {
        geolocation = [[Location alloc]init];
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
        geolocation.cosName = parsingContentFile;
        NSLog(@"%@",geolocation.cosName);
    }
    else if([elementName isEqualToString:@"Latitude"])
    {
        geolocation.latitude = parsingContentFile;
        NSLog(@"%@",geolocation.latitude);
    }
    else if([elementName isEqualToString:@"Longitude"])
    {
        geolocation.longitude = parsingContentFile;
        NSLog(@"%@",geolocation.longitude);
    }
    if([elementName isEqualToString:@"Cos"])
    {
        [self.location addObject:geolocation];
    }
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}
@end
