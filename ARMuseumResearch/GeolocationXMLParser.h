//
//  GeolocationXMLParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 14/04/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
@interface GeolocationXMLParser : NSObject <NSXMLParserDelegate>
@property(nonatomic,retain)NSString *parsingContentFile;
@property (nonatomic,strong)Location *geolocation;
@property (nonatomic,strong)NSMutableArray *location;
-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
