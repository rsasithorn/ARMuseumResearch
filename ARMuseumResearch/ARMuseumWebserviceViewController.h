//
//  ARMuseumWebserviceViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 28/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "MetaioSDKViewController.h"
#import "XMLMuseumContentParser.h"
#import "XMLImageContentParser.h"
#import "MuseumContentElement.h"
#import "MuseumObjects.h"
#import "ReferenceObjectID.h"
#import "RefereneObjectIDParser.h"
#import "MuseumObject.h"
#import "ImageObjects.h"
#import "ModelObjects.h"
#import "LoadPreferencesViewController.h"
#import "PreferredObjects.h"
#import "Model.h"
#import "GeoLocation.h"
#import "ImageBillboard.h"
#import "TextBillboard.h"
#import "Video.h"
#import "ModelContentsParser.h"
#import "ModelElements.h"
#import "ModelObjects.h"

@interface ARMuseumWebserviceViewController : MetaioSDKViewController <UIAlertViewDelegate>
{
    UIImage *billboardImage;
    NSString *mapFileName;
    NSMutableArray *arrayOfContent;
    metaio::IGeometry *museumobjectName;
    int flag;
    NSString *selectedCosName;
    int num;
}
@property (strong, nonatomic) IBOutlet UIWebView *arWebView;
@property (nonatomic, retain) NSString *urlWebView;
@property(nonatomic,retain) UIImage *billboardImage;
@property (nonatomic) std::vector<metaio::TrackingValues> poses;
@property (nonatomic, retain) NSMutableArray *arrayOfContent;
@property (nonatomic) NSComparisonResult cosNameResult;
@property (nonatomic, retain) NSMutableArray *museumobjectImagesArray;
@property (nonatomic) metaio::IGeometry *museumobjectName;
@property (nonatomic) metaio::IBillboardGroup *billboardGroup;
@property (nonatomic) metaio::IBillboardGroup *imageBillboardGroup;
@property (nonatomic, retain) NSMutableArray *referenceObject;
@property (nonatomic, retain) NSMutableArray *arrayOfAllContent;
@property (nonatomic, retain) NSMutableArray *arrayOfAllSelectedContent;
@property (nonatomic, retain) MuseumObject *museumObject;
@property (nonatomic, strong) NSMutableArray *arrayOfImage;
@property (nonatomic, retain) NSMutableArray *arrayOfModel;
@property (nonatomic) int set;
@property (nonatomic) int mset;
@property (nonatomic) int request;
@property (nonatomic,strong) NSString *service;
@property (nonatomic) metaio::TrackingValues objectPose;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, retain) NSManagedObject *cName;
@property (nonatomic, strong) NSManagedObjectContext *newmanageObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *manageObjectModel;
@property (nonatomic ,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) PreferredObjects *preferredObjects;
@property (nonatomic, strong) ImageBillboard *imageBillboard;
@property (nonatomic, strong) TextBillboard *textBillboard;
@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) GeoLocation *geoLocation;
@property (nonatomic, copy) NSString *source;
@property (nonatomic) metaio::IGeometry *bowlModel;
@property (nonatomic) metaio::IGeometry *tinModel;
@property (nonatomic, retain) NSMutableArray *locations;
@property (nonatomic, retain) NSString  *trackedCosName;

//- (IBAction)openWebView:(id)sender;
- (UIImage*)getBillboardImageForTitle:(NSString*)title;
//- (IBAction)connection;
- (IBAction)requestAssociatedContent:(id)sender;
- (void)manageMuseumContents;
- (IBAction)downloadARMuseumContent;
- (void)connectWebServices:(NSString*)cosName;
- (IBAction)loadUserPreferences;
- (IBAction)saveGeometries:(id)sender;
- (IBAction)restartTracking:(id)sender;
- (void)saveToCoreDataDB:(NSString*)preferrenceName;
- (void)createModels:(NSString*)cosName;
- (UIImage*)getAnnotationImageForTitle:(NSString*)title;
- (void)getLocation:(NSString *)museum;
@end
