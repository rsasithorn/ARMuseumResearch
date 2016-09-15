//
//  XMLMuseumContentParser.h
//  ARTestAppMetaio
//
//  Created by sr341 on 03/10/2013.
//  Copyright (c) 2013 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MuseumContentElement.h"
@interface XMLMuseumContentParser : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *objectContents;
    NSString *object;
    NSString *descriptions;
    UIImage *image;
}
@property(nonatomic, strong) NSMutableArray *objectContents;
@property(nonatomic, strong) NSString *object;
@property(nonatomic, strong) NSString *descriptions;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *element;
@property(nonatomic, strong) MuseumContentElement *museumContent1;
@property(nonatomic, strong) MuseumContentElement *museumContent2;
@property(nonatomic, strong) MuseumContentElement *museumContent3;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;

@end
