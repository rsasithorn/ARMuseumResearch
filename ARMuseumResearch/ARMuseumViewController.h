//
//  ARMuseumViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 30/07/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaioSDKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMLMuseumContentParser.h"
#import "XMLContentParser.h"
#import "MuseumObject.h"
#import "MuseumObjects.h"
#import "MuseumImages.h"
#import "XMLElement.h"
#import "MuseumContentElement.h"
#import "ImagesElement.h"
#import "ImageObjects.h"
#import "MuseumModels.h"
#import "ModelObjects.h"
#import "BillboardGroup.h"
#import "BillboardContentParser.h"
#import "BillboardSingleElement.h"
#import "ImageContentsParser.h"
#import "ModelContentsParser.h"
#import "RefereneObjectIDParser.h"
#import "ReferenceObjectID.h"
#import "MoreDetailsBoard.h"
#import "ReferenceObjectID.h"
#import "AssociatedContent.h"
#import "ObjectFromWebService.h"
#import "PreferredObjects.h"
#import "Model.h"
#import "GeoLocation.h"
#import "GeolocationXMLParser.h"
#import "Location.h"
#import "ImageBillboard.h"
#import "TextBillboard.h"
#import "Video.h"

@interface ARMuseumViewController : MetaioSDKViewController
@property (nonatomic, strong) NSMutableArray *arrayOfItem;
@property (nonatomic, strong) MuseumContentElement *museumContent;
@property (nonatomic, strong) NSMutableArray *museumObjectsArray;
@property (nonatomic) metaio::IGeometry* theLoadedModel;
@property (nonatomic) metaio::IGeometry* theLoadedModel1;
@property (nonatomic, strong) NSMutableArray *billboardImagesArray;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) NSMutableArray *moreDetailsBoardArray;
@property (nonatomic, strong) NSMutableArray *downloadedContentArray;
@property (nonatomic) metaio::IBillboardGroup *billboardGroup;
@property (nonatomic) metaio::IBillboardGroup *imageBillboardGroup;
@property (nonatomic, strong) NSMutableArray *museumDownloadedObjectArray;
@property (nonatomic, strong) NSMutableArray *associatedContent;
@property (nonatomic,strong) NSMutableArray *apiReferenceContent;
@property (nonatomic, strong) NSString *cosName;
@property (nonatomic,strong) NSMutableArray *contentFromWebServices;
@property (nonatomic, strong) NSMutableArray *selectedContent;
@property (nonatomic)int flag;
@property (nonatomic)int flag1;
@property (nonatomic)int flag2;
@property (nonatomic)int num;
@property (nonatomic)int set;
@property (nonatomic, strong) NSManagedObjectContext *newmanageObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *manageObjectModel;
@property (nonatomic ,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PreferredObjects *preferredObjects;
@property (nonatomic, strong) ImageBillboard *imageBillboard;
@property (nonatomic, strong) TextBillboard *textBillboard;
@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) GeoLocation *geoLocation;
@property (nonatomic, copy) NSString *selectedCosName;
@property (nonatomic, strong) NSMutableArray *location;

- (void)CreateBillboardARContent:(NSMutableArray *) data;
- (void)CreateBillboardImages:(NSMutableArray*) data;
- (void)CreateModels:(NSMutableArray*) data;
- (UIImage*)getBillboardImageForTitle:(NSString*) title;
- (void)connectWebservice:(NSString*)cid;
- (void)createMuseumContents;
- (void)createDownloadedDataContent:(NSDictionary *) data;
- (IBAction)startRequestAssociatedContent:(UIButton *)sender;
- (void)createWebserviceDataContent:(NSArray *)data;
- (IBAction)saveSelectedGeometires:(id)sender;
- (IBAction)startRequestContents:(id)sender;
- (IBAction)reset:(id)sender;

@end
