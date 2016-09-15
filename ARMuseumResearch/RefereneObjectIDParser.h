//
//  RefereneObjectIDParser.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 09/10/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReferenceObjectID.h"
@interface RefereneObjectIDParser : NSObject <NSXMLParserDelegate>
{
    NSString *object;
    NSString *descriptions;
    UIImage *image;
}
@property(nonatomic, strong) NSMutableArray *objectContents;
@property(nonatomic, strong) ReferenceObjectID *referenceObjectID;
@property(nonatomic, strong) NSString *data;
@property(nonatomic, strong) NSString *element;

-(NSMutableArray *)parseXMLFile:(NSData *)xmlData;
@end
