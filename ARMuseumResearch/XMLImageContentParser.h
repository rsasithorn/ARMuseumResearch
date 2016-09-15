//
//  XMLImageContentParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 29/06/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MuseumContentElement.h"
@interface XMLImageContentParser : NSObject <NSXMLParserDelegate>
@property(nonatomic, strong) NSMutableArray *objectContents;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *element;
@property(nonatomic, strong) NSString *object;
@property(nonatomic, strong) MuseumContentElement *museumContent;
-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
