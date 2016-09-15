//
//  ARMuseumViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 30/07/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ARMuseumViewController.h"
#import "EAGLView.h"

@interface ARMuseumViewController ()

@end

@implementation ARMuseumViewController
@synthesize arrayOfItem;
@synthesize museumContent;
@synthesize museumObjectsArray;
@synthesize theLoadedModel;
@synthesize theLoadedModel1;
@synthesize billboardImagesArray;
@synthesize modelsArray;
@synthesize billboardGroup;
@synthesize imageBillboardGroup;
@synthesize moreDetailsBoardArray;
@synthesize downloadedContentArray;
@synthesize museumDownloadedObjectArray;
@synthesize cosName;
@synthesize associatedContent;
@synthesize flag;
@synthesize flag1;
@synthesize flag2;
@synthesize set;
@synthesize apiReferenceContent;
@synthesize contentFromWebServices;
@synthesize newmanageObjectContext;
@synthesize manageObjectModel= _manageObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize source = _source;
@synthesize selectedContent;
@synthesize textField;
@synthesize preferredObjects;
@synthesize imageBillboard;
@synthesize textBillboard;
@synthesize model;
@synthesize video;
@synthesize geoLocation;
@synthesize selectedCosName;
@synthesize num;
@synthesize location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"Tracking" ofType:@"xml" inDirectory:@"Assets1"];
    if(trackingDataFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
		if( !success)
        {
			NSLog(@"No success loading the tracking configuration for the first obj");
        }
        
        NSString *parsingXMLFile = [[NSBundle mainBundle]pathForResource:@"Contents" ofType:@"xml" inDirectory:@"Assets1"];
        NSData *xmlFile = [NSData dataWithContentsOfFile:parsingXMLFile];
        
        billboardGroup = m_metaioSDK->createBillboardGroup(1.0f, 3.0f);
        billboardGroup->setBillboardExpandFactors(1, 2, 10 );
        m_metaioSDK->setRendererClippingPlaneLimits(10, 200000);
        
        /*imageBillboardGroup = m_metaioSDK->createBillboardGroup(1.0f, 3.0f);
        imageBillboardGroup->setBillboardExpandFactors(1, 2, 10 );
        m_metaioSDK->setRendererClippingPlaneLimits(10, 100000);*/
        
        NSMutableArray *billboardContents = [[NSMutableArray alloc]init];
        BillboardContentParser *contentParser = [[BillboardContentParser alloc]init];
        billboardContents = [contentParser parseXMLFile:xmlFile];
        if(billboardContents)
        {
            NSLog(@"success");
            [self CreateBillboardARContent:billboardContents];
        }
        
        NSMutableArray *imageContents = [[NSMutableArray alloc]init];
        ImageContentsParser *imaeContentsParser = [[ImageContentsParser alloc]init];
        imageContents = [imaeContentsParser parseXMLFile:xmlFile];
        if(imageContents)
        {
            NSLog(@"success");
            [self CreateBillboardImages:imageContents];
        }
        
        NSMutableArray *modelContents = [[NSMutableArray alloc]init];
        ModelContentsParser *modelContentsParser = [[ModelContentsParser alloc]init];
        modelContents = [modelContentsParser parseXMLFile:xmlFile];
        if(modelContents)
        {
            NSLog(@"success");
            [self CreateModels:modelContents];
        }
        
        location = [[NSMutableArray alloc]init];
        GeolocationXMLParser *geolocationXMLParser = [[GeolocationXMLParser alloc]init];
        location = [geolocationXMLParser parseXMLFile:xmlFile];
        if(location)
        {
            Location *loc = [[Location alloc]init];
            loc = location[0];
            NSLog(@"%@",loc.cosName);
            NSLog(@"%@",loc.latitude);
            NSLog(@"%@",loc.longitude);
            NSLog(@"Success");
        }
        
        associatedContent = [[NSMutableArray alloc]init];
        selectedContent = [[NSMutableArray alloc]init];
        
        NSPersistentStoreCoordinator *psc = [self persistentStoreCoordinator];
        newmanageObjectContext = [[NSManagedObjectContext alloc] init];
        [newmanageObjectContext setPersistentStoreCoordinator:psc];
        num = 0;
        flag1 = 0;
        flag2 = 0;
        set = 0;
        
        NSString *parsingXMLAPIFile = [[NSBundle mainBundle]pathForResource:@"ContentDetails" ofType:@"xml" inDirectory:@"Assets1"];
        NSData *xmlAPIFile = [NSData dataWithContentsOfFile:parsingXMLAPIFile];
        //apiReferenceContent = [[NSMutableArray alloc]init];
        RefereneObjectIDParser *referenceObjectIDParser = [[RefereneObjectIDParser alloc]init];
        apiReferenceContent = [referenceObjectIDParser parseXMLFile:xmlAPIFile];
        if(apiReferenceContent)
        {
            NSLog(@"success");
        }
        selectedContent = [[NSMutableArray alloc]init];
    }
}
- (NSString *)source
{
    _source = @"Museum-based";
    return _source;
}
-(NSManagedObjectModel *)manageObjectModel
{
    if(_manageObjectModel != nil)
    {
        return _manageObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MuseumContents" withExtension:@"momd"];
    _manageObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _manageObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ARMuseumContents.sqlite"];
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self manageObjectModel]];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
- (void)CreateBillboardARContent:(NSMutableArray *)data
{
    BillboardSingleElement *billboardElement = [[BillboardSingleElement alloc]init];
    museumObjectsArray = [[NSMutableArray alloc]init];
    UIImage *billboardImage;
    UIImage *billboardDetails;
    UIImage *billboardPlace;
    for(int i=0;i<=10;i++)
    {
        billboardElement = data[i];
        MuseumObject *museumObject = [[MuseumObject alloc]init];
        if([billboardElement.cosName isEqualToString:@"null"])
        {
            museumObject.cosName = billboardElement.cosName;
            [self.museumObjectsArray addObject:museumObject];
            NSLog(@"End building billboard objects");
            break;
        }
        else
        {
            
            museumObject.cosName = billboardElement.cosName;
            museumObject.billboardTitle = billboardElement.title;
            museumObject.billboardDetails = billboardElement.details;
            museumObject.placeName = billboardElement.place;
            NSLog(@"%@",museumObject.cosName);
            NSLog(@"%@",billboardElement.title);
            billboardImage = [self getBillboardImageForTitle:billboardElement.title];
            museumObject.title = m_metaioSDK->createGeometryFromCGImage("Title", [billboardImage CGImage], true);
            museumObject.title->setVisible(false);
            NSLog(@"%@",billboardElement.details);
            billboardDetails = [self getBillboardImageForTitle:billboardElement.details];
            museumObject.details = m_metaioSDK->createGeometryFromCGImage("Details", [billboardDetails CGImage], true);
            museumObject.details->setVisible(false);
            NSLog(@"%@",billboardElement.place);
            billboardPlace = [self getBillboardImageForTitle:billboardElement.place];
            museumObject.place = m_metaioSDK->createGeometryFromCGImage("Place",[billboardPlace CGImage],true);
            museumObject.place->setVisible(false);
            NSLog(@"Done billboards");
            [self.museumObjectsArray addObject:museumObject];
        }
    }
}
- (void)CreateBillboardImages:(NSMutableArray*)data
{
    ImagesElement *imagesElement = [[ImagesElement alloc]init];
    billboardImagesArray = [[NSMutableArray alloc]init];
    moreDetailsBoardArray = [[NSMutableArray alloc]init];
    
    for(int i=0;i<=10;i++)
    {
        
        imagesElement = data[i];
        NSLog(@"%@",imagesElement.cosName);
        
        if([imagesElement.cosName isEqualToString:@"null"])
        {
            MoreDetailsBoard *moreDetails = [[MoreDetailsBoard alloc]init];
            moreDetails.cosName = imagesElement.cosName;
            [self.moreDetailsBoardArray addObject:moreDetails];
            
            ImageObjects *image = [[ImageObjects alloc ]init];
            image.cosName = imagesElement.cosName;
            [self.billboardImagesArray addObject:image];
            break;
        }
        else
        {
            NSLog(@"creating image objects");
            NSLog(@"%@ %@",imagesElement.picFilename,imagesElement.picFileType);
            NSString* imagepath = [[NSBundle mainBundle] pathForResource:imagesElement.picFilename ofType:imagesElement.picFileType inDirectory:@"Assets1"];
            
            if(imagepath)
            {
                // if this call was successful, theLoadedModel will contain a pointer to the 3D model
                //m_metaioSDK->createGeometryFromCGImage("Title", [billboardImage CGImage], true);
                if([imagesElement.picFilename isEqualToString:@"MoreDetails"])
                {
                    MoreDetailsBoard *moreDetails = [[MoreDetailsBoard alloc]init];
                    moreDetails.cosName = imagesElement.cosName;
                    moreDetails.moreDetailsObject = m_metaioSDK->createGeometryFromImage([imagepath UTF8String],true);
                    moreDetails.moreDetailsObject->setVisible(false);
                    [self.moreDetailsBoardArray addObject:moreDetails];
                    //billboardGroup->addBillboard(moreDetails.moreDetailsObject);
                }
                else
                {   ImageObjects *image = [[ImageObjects alloc]init];
                    image.cosName = imagesElement.cosName;
                    image.imageObject =  m_metaioSDK->createGeometryFromImage([imagepath UTF8String],true);
                    //image.imagePath = imagepath;
                    image.image = [[NSData alloc]initWithContentsOfFile:imagepath];
                    NSLog(@"%@",image.image);
                    image.imageObject->setVisible(false);
                    [self.billboardImagesArray addObject:image];
                    //billboardGroup->addBillboard(image.imageObject);
                }
            }
            else
            {
                NSLog(@"error, could not load %@", imagepath);
            }
        }
    }
    NSLog(@"Done images");
}
-(void)CreateModels:(NSMutableArray *)data
{
    ModelElements *models = [[ModelElements alloc]init];
    modelsArray = [[NSMutableArray alloc]init];
    //MuseumModels *museumModels = [[MuseumModels alloc]init];
    for(int i=0;i<=10;i++)
    {
        models = data[i];
        ModelObjects *modelObject = [[ModelObjects alloc]init];
        modelObject.cosName = models.cosName;
        NSLog(@"%@",modelObject.cosName);
        
        if([modelObject.cosName isEqualToString:@"null"])
        {
            [modelsArray addObject:modelObject];
            break;
        }
        else
        {
            NSLog(@"Creating model objects");
            NSLog(@"%@ %@",models.modelFilename, models.modelFileType);
            NSLog(@"creating model objects");
            NSString *modelpath = [[NSBundle mainBundle]pathForResource:models.modelFilename ofType:models.modelFileType inDirectory:@"Assets1"];
            if (modelpath)
            {
                modelObject.model = m_metaioSDK->createGeometry([modelpath UTF8String]);
                modelObject.model->setTranslation(metaio::Vector3d(-80, -100, 0),true);
                modelObject.model->setVisible(false);
                [self.modelsArray addObject:modelObject];
            }
            else
            {
                NSLog(@"error, could not load %@",modelpath);
            }
        }
    }
    NSLog(@"Done models");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)connectWebservice:(NSString*)cid
{
            NSString *urlString = cid;
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            [urlRequest setTimeoutInterval:30.0f];
            [urlRequest setHTTPMethod:@"GET"];
            NSLog(@"%@",urlRequest);
            NSLog(@"connect web service");
            NSOperationQueue *queue = [[NSOperationQueue alloc]init];
            //downloadedContentArray = [[NSMutableArray alloc]init];
            //museumContent = [[MuseumContentElement alloc]init];
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 if([data length] > 0 && error == nil)
                 {
                     NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"HTML = %@",html);
                     NSError *error = nil;
                     id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                     if(jsonObject != nil && error == nil)
                     {
                         NSLog(@"Successfully deserialized...");
                         if([jsonObject isKindOfClass:[NSDictionary class]])
                         {
                             NSDictionary *deserializedDictionary = jsonObject;
                             NSLog(@"Deserialized JSON Dictionary = %@",deserializedDictionary);
                             if(set == 1)
                             {
                                 [self createDownloadedDataContent:deserializedDictionary];
                                  NSLog(@"Create contents");
                             }
                             else if (set == 0)
                             {
                                 [self createDownloadedDataContent:deserializedDictionary];
                                 NSLog(@"create contents");
                             }
                         }
                         else if([jsonObject isKindOfClass:[NSArray class]])
                         {
                             NSArray *deserializedArray = (NSArray *)jsonObject;
                             NSLog(@"Deserialized JSON Array = %@",deserializedArray);
                             if(set == 1)
                             {
                                 [self createWebserviceDataContent:deserializedArray];
                                 NSLog(@"Create web service contents");
                             }
                         }
                     }
                     else if(error != nil)
                     {
                         NSLog(@"An error happended while deserializing the JSON data.");
                     }
                }
                 else if(error != nil)
                 {
                     NSLog(@"Error happended = %@",error);
                 }
                 
             }
             ];
}

-(void) createWebserviceDataContent:(NSArray *)data
{
    NSString *substr;
    NSURL *url;
    NSData *imageData;
    contentFromWebServices = [[NSMutableArray alloc]init];
    ObjectFromWebService *objectFromWebService = [[ObjectFromWebService alloc]init];
    NSArray *webserviceMuseumData = [[data objectAtIndex:0] objectForKey:@"fields"];
    objectFromWebService.cosName = cosName;
    objectFromWebService.objName = [webserviceMuseumData valueForKey:@"object"];
    NSLog(@"%@",objectFromWebService.objName);
    objectFromWebService.description = [webserviceMuseumData valueForKey:@"history_note"];
    NSLog(@"%@",objectFromWebService.description);
    objectFromWebService.objDetails = [webserviceMuseumData valueForKey:@"public_access_description"];
    NSLog(@"%@",objectFromWebService.objDetails);
    NSString *primaryImageID = [webserviceMuseumData valueForKey:@"primary_image_id"];
    NSLog(@"%@",primaryImageID);
    substr = [primaryImageID substringToIndex:6];
    NSString *urlString = @"http://media.vam.ac.uk/media/thira/collection_images/";
    urlString = [urlString stringByAppendingString:substr];
    urlString = [urlString stringByAppendingString:@"/"];
    urlString = [urlString stringByAppendingString:primaryImageID];
    urlString = [urlString stringByAppendingString:@".jpg"];
    NSLog(@"urlString = %@",urlString);
    url = [NSURL URLWithString:urlString];
    imageData = [NSData dataWithContentsOfURL:url];
    objectFromWebService.image = imageData;
    objectFromWebService.urlPath = urlString;
    objectFromWebService.latitude = [webserviceMuseumData valueForKey:@"latitude"];
    objectFromWebService.longitude = [webserviceMuseumData valueForKey:@"longitude"];
    objectFromWebService.place = [webserviceMuseumData valueForKey:@"place"];
    [contentFromWebServices addObject:objectFromWebService];
    ObjectFromWebService *lastElement = [[ObjectFromWebService alloc]init];
    lastElement.cosName = @"null";
    [contentFromWebServices addObject:lastElement];
}
- (IBAction)saveSelectedGeometires:(id)sender
{
    MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
    museumObjects.cosName = @"null";
    [selectedContent addObject:museumObjects];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Save Selected Geometries"
                                                       message:@"Please enter name of your preference"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    [alertView show];
}
- (IBAction)startRequestContents:(id)sender
{
    UIImage *billboardImage;
    //UIImage *image;
    ObjectFromWebService *objectFromWebService = [[ObjectFromWebService alloc]init];
    for(int i = 0;i<=5;i++)
    {
       objectFromWebService = contentFromWebServices[i];
       if([objectFromWebService.cosName isEqualToString:@"null"])
       {
           break;
       }
        billboardImage = [self getBillboardImageForTitle:objectFromWebService.objName ];
        objectFromWebService.object = m_metaioSDK->createGeometryFromCGImage("Title", [billboardImage CGImage], true);
        objectFromWebService.object->setVisible(false);
        billboardImage = [self getBillboardImageForTitle:objectFromWebService.description];
        objectFromWebService.physicalDescription = m_metaioSDK->createGeometryFromCGImage("PhysicalDescription", [billboardImage CGImage], true);
        objectFromWebService.physicalDescription->setVisible(false);
        billboardImage = [self getBillboardImageForTitle:objectFromWebService.objDetails];
        objectFromWebService.details = m_metaioSDK->createGeometryFromCGImage("Details", [billboardImage CGImage], true);
        objectFromWebService.details->setVisible(false);
        NSURL *url = [NSURL URLWithString:objectFromWebService.urlPath];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        billboardImage = [[UIImage alloc]initWithData:imageData];
        objectFromWebService.imageBillboard = m_metaioSDK->createGeometryFromCGImage("ImageModel",[billboardImage CGImage], true);
        objectFromWebService.imageBillboard->setScale(metaio::Vector3d(1.0,1.0,1.0));
        objectFromWebService.imageBillboard->setVisible(false);
        billboardImage = [self getBillboardImageForTitle:objectFromWebService.place];
        objectFromWebService.placeBillboard = m_metaioSDK->createGeometryFromCGImage("Place", [billboardImage CGImage], true);
        objectFromWebService.object->setVisible(false);
    }
    flag2 = 1;
    NSLog(@"Done creating web service contents");
}
- (IBAction)reset:(id)sender
{
    flag = 0;
    //flag2 = 0;
    set = 0;
    AssociatedContent *content = [[AssociatedContent alloc]init];
    for(int i=0;i<=30;i++)
    {
        content = associatedContent[i];
        if([content.cosName isEqualToString:@"null"])
        {
            break;
        }
        content.objImage->setVisible(false);
    }
    associatedContent = [[NSMutableArray alloc]init];
    //selectedContent = [[NSMutableArray alloc]init];
    billboardGroup->removeAllBillboards();
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel...");
        selectedContent = [[NSMutableArray alloc]init];
    }
    else if([buttonTitle isEqualToString:@"OK"])
    {
        NSLog(@"OK....");
        NSString *input = textField.text;
        NSLog(@"%@",input);
        [self saveToCoreDataDB:textField.text];
    }
}
-(void)saveToCoreDataDB:(NSString *)preferrenceName
{
    MuseumObjects *savedObjects = [[MuseumObjects alloc]init];
    preferredObjects = [NSEntityDescription insertNewObjectForEntityForName:@"PreferredObjects" inManagedObjectContext:newmanageObjectContext];
    if(preferredObjects != nil)
    {
        preferredObjects.cosname = selectedCosName;
        preferredObjects.preferencename = preferrenceName;
        preferredObjects.datecreate = [NSDate date];
        preferredObjects.source = [self source];
        preferredObjects.id = [NSNumber numberWithInt:++num];
        for(int i=0;i<=10;i++)
        {
            savedObjects = selectedContent[i];
            if([savedObjects.cosName isEqualToString:@"null"])
            {
                break;
            }
            if([savedObjects.objType isEqualToString:@"media"] || [savedObjects.objType isEqualToString:@"Associated Image"])
            {
                imageBillboard = [NSEntityDescription insertNewObjectForEntityForName:@"ImageBillboard" inManagedObjectContext:newmanageObjectContext];
                imageBillboard.imagepath = savedObjects.imagePath;
                NSLog(@"%@",imageBillboard.imagepath);
                imageBillboard.imageonbillboard = savedObjects.img;
                NSLog(@"%@",imageBillboard.imageonbillboard);
                [preferredObjects addImageObject:imageBillboard];
            }
            else if([savedObjects.objType isEqualToString:@"object"]||[savedObjects.objType isEqualToString:@"description"])
            {
                textBillboard = [NSEntityDescription insertNewObjectForEntityForName:@"TextBillboard" inManagedObjectContext:newmanageObjectContext];
                textBillboard.textonbillboard = savedObjects.data;
                NSLog(@"%@",textBillboard.textonbillboard);
                textBillboard.billboardtype = savedObjects.objType;
                NSLog(@"%@",textBillboard.billboardtype);
                [preferredObjects addTextObject:textBillboard];
            }
            else if([savedObjects.objType isEqualToString:@"details"])
            {
                textBillboard = [NSEntityDescription insertNewObjectForEntityForName:@"TextBillboard" inManagedObjectContext:newmanageObjectContext];
                textBillboard.textonbillboard = savedObjects.data;
                textBillboard.billboardtype = savedObjects.objType;
                [preferredObjects addTextObject:textBillboard];
            }
            else if([savedObjects.objType isEqualToString:@"geolocation"])
            {
                geoLocation = [NSEntityDescription insertNewObjectForEntityForName:@"GeoLocation" inManagedObjectContext:newmanageObjectContext];
                geoLocation.latitude = [savedObjects.latitude doubleValue];
                NSLog(@"%f",geoLocation.latitude);
                geoLocation.longitude = [savedObjects.longitude doubleValue];
                NSLog(@"%f",geoLocation.longitude);
                preferredObjects.location = geoLocation;
            }
            /*else if([savedObjects.objType isEqualToString:@"museum"])
            {
                preferredObjects.museum = savedObjects.data;
            }*/
        }
        preferredObjects.museum = @"Victoria & Albert Museum";
        NSError *savingError = nil;
        if([self.newmanageObjectContext save:&savingError])
        {
            NSLog(@"Successfully saved the context");
        }
        else
        {
            NSLog(@"Failed to save the context. Error %@",savingError);
        }
    }
    else
    {
        NSLog(@"Failed to create the new table object");
    }
    selectedContent = [[NSMutableArray alloc]init];
    //associatedContent = [[NSMutableArray alloc]init];
    flag = 0;
}
-(void) createDownloadedDataContent:(NSDictionary *)data
{
    NSDictionary *jsonMuseumData = [data objectForKey:@"records"];
    NSInteger i;
    i = [data count];
    NSString *substr;
    NSURL *url;
    NSData *imageData;
    UIImage *image;
    NSLog(@"no of entry : %li",(long)i );
    for(NSDictionary *record in jsonMuseumData)
    {
        NSLog(@"%@",[record objectForKey:@"pk"]);
        NSDictionary *field = [record objectForKey:@"fields"];
        NSLog(@"%@",[field objectForKey:@"primary_image_id"]);
        AssociatedContent *imageObject = [[AssociatedContent alloc]init];
        imageObject.cosName = cosName;
        imageObject.objNumber = [field objectForKey:@"object_number"];
        NSString *primaryImageID = [field objectForKey:@"primary_image_id"];
        substr = [primaryImageID substringToIndex:6];
        
        NSLog(@"%@",substr);
        NSString *urlString = @"http://media.vam.ac.uk/media/thira/collection_images/";
        urlString = [urlString stringByAppendingString:substr];
        urlString = [urlString stringByAppendingString:@"/"];
        urlString = [urlString stringByAppendingString:primaryImageID];
        urlString = [urlString stringByAppendingString:@".jpg"];
        NSLog(@"urlString = %@",urlString);
        url = [NSURL URLWithString:urlString];
        imageData = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc]initWithData:imageData];
        imageObject.urldata = urlString;
        imageObject.latitude = [field objectForKey:@"latitude"];
        imageObject.longitude = [field objectForKey:@"longitude"];
        imageObject.img = imageData;
        [associatedContent addObject:imageObject];
    }
    AssociatedContent *imageObject = [[AssociatedContent alloc]init];
    imageObject.cosName = @"null";
    [associatedContent addObject:imageObject];
}

- (IBAction)startRequestAssociatedContent:(UIButton *)sender
{
    [self createMuseumContents];
}
-(void)createMuseumContents
{
    NSURL *url;
    NSData *imageData;
    UIImage *image;
    AssociatedContent *content = [[AssociatedContent alloc]init];
    for(int i=0;i<=30;i++)
    {
        content = associatedContent[i];
        if([content.cosName isEqualToString:@"null"])
        {
            break;
        }
        
    url = [NSURL URLWithString:content.urldata];
    imageData = [NSData dataWithContentsOfURL:url];
    image = [[UIImage alloc]initWithData:imageData];
    content.objImage = m_metaioSDK->createGeometryFromCGImage("ImageModel",[image CGImage], true);
    content.objImage->setScale(metaio::Vector3d(1.0,1.0,1.0));
    content.objImage->setVisible(false);
    }
    flag = 1;
}

- (UIImage*) getBillboardImageForTitle: (NSString*) title
{
    // first lets find out if we're drawing retina resolution or not
    float scaleFactor = [UIScreen mainScreen].scale;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scaleFactor = 2;        // draw in high-res for iPad
    
    // then lets draw
    UIImage* bgImage = nil;
    NSString *imagePath;
    //if( scaleFactor == 1 )	// potentially this is not necessary anyway, because iOS automatically picks 2x version for iPhone4
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"POI_bg" ofType:@"png" inDirectory:@"Assets1/Billboards"];
    
    /*else
     {
     imagePath = [[NSBundle mainBundle] pathForResource:@"POI_bg@2x" ofType:@"png" inDirectory:@"Assets5"];
     }*/
    
    bgImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    UIGraphicsBeginImageContext( bgImage.size );			// create a new image context
    CGContextRef currContext = UIGraphicsGetCurrentContext();
    
    // mirror the context transformation to draw the images correctly
    CGContextTranslateCTM( currContext, 0, bgImage.size.height );
    CGContextScaleCTM(currContext, 1.0, -1.0);
    CGContextDrawImage(currContext,  CGRectMake(0, 0, bgImage.size.width, bgImage.size.height), [bgImage CGImage]);
    
    // now bring the context transformation back to what it was before
    CGContextScaleCTM(currContext, 1.0, -1.0);
    CGContextTranslateCTM( currContext, 0, -bgImage.size.height );
    
    // and add some text...
    CGContextSetRGBFillColor(currContext, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetTextDrawingMode(currContext, kCGTextFill);
    CGContextSetShouldAntialias(currContext, true);
    
    // draw the heading
    float border = 3;//*scaleFactor;
    [title  drawInRect:CGRectMake(border, border, bgImage.size.width - 2 * border, bgImage.size.height - 2 * border ) withFont:[UIFont systemFontOfSize:9]];//*scaleFactor]];
    
    // retrieve the screenshot from the current context
    UIImage* blendetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendetImage;
}
- (void)drawFrame
{
    [super drawFrame];
    NSLog(@"Tracking is now working");
    
    // return if the metaio SDK has not been initialiyed yet
    if( !m_metaioSDK )
        return;
    // get all the detected poses/targets
    std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();

    //if we have detected one, attach our metaioman to this coordinate system I
    if(poses.size())
    {
        MuseumObject *museumObject = [[MuseumObject alloc]init];
        ImageObjects *imageObject = [[ImageObjects alloc]init];
        ModelObjects *modelObject = [[ModelObjects alloc]init];
        MoreDetailsBoard *moreDetails = [[MoreDetailsBoard alloc]init];
        ReferenceObjectID *referenceObject = [[ReferenceObjectID alloc]init];
        
        NSLog(@"Found");
        NSLog(@"%s",poses[0].cosName.c_str());
        cosName = [NSString stringWithFormat:@"%s",poses[0].cosName.c_str()];
        NSLog(@"%@",cosName);
        for(int i=0;i<=10;i++)
        {
                referenceObject = apiReferenceContent[i];
                if([cosName isEqualToString:referenceObject.cName])
                {
                    if(flag2 == 0 && set == 0)
                    {
                        set = 1;
                        [self connectWebservice:referenceObject.cid];
                        NSLog(@"%i",set);
                        break;
                    }
                    else if (flag2 == 0 && set == 1)
                    {
                        break;
                    }
                    
                    if(flag2 == 1)
                    {
                        billboardGroup->removeAllBillboards();
                        ObjectFromWebService *objectFromWebService = [[ObjectFromWebService alloc]init];
                        for(int i=0;i<=10;i++)
                        {
                            objectFromWebService = contentFromWebServices[i];
                            if([objectFromWebService.cosName isEqualToString:@"null"])
                            {
                                break;
                            }
                            else
                            {
                                if(flag == 1)
                                {
                                    objectFromWebService.object->setVisible(false);
                                    objectFromWebService.details->setVisible(false);
                                    objectFromWebService.physicalDescription->setVisible(false);
                                    objectFromWebService.placeBillboard->setVisible(false);
                                    objectFromWebService.imageBillboard->setVisible(false);
                                }
                                else
                                {
                                    billboardGroup->addBillboard(objectFromWebService.object);
                                    objectFromWebService.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                                    objectFromWebService.object->setVisible(true);
                                    billboardGroup->addBillboard(objectFromWebService.details);
                                    objectFromWebService.details->setCoordinateSystemID(poses[0].coordinateSystemID);
                                    objectFromWebService.details->setVisible(true);
                                    billboardGroup->addBillboard(objectFromWebService.physicalDescription);
                                    objectFromWebService.physicalDescription->setCoordinateSystemID(poses[0].coordinateSystemID);
                                    objectFromWebService.physicalDescription->setVisible(true);
                                    billboardGroup->addBillboard(objectFromWebService.imageBillboard);
                                    objectFromWebService.imageBillboard->setCoordinateSystemID(poses[0].coordinateSystemID);
                                    objectFromWebService.imageBillboard->setVisible(true);
                                    billboardGroup->addBillboard(objectFromWebService.placeBillboard);
                                    objectFromWebService.placeBillboard->setCoordinateSystemID(poses[0].coordinateSystemID);
                                    objectFromWebService.placeBillboard->setVisible(true);
                                }
                            }
                        }
                        //flag = 0;
                    }
                }
                else if([referenceObject.cName isEqualToString:@"null"])
                {
                    break;
                }
        }
        for(int i=0;i<=10;i++)
        {
             museumObject = museumObjectsArray[i];
             if([cosName isEqualToString:museumObject.cosName])
             {
                 if(flag == 1)
                 {
                     museumObject.title->setVisible(false);
                     museumObject.details->setVisible(false);
                     museumObject.place->setVisible(false);
                     break;
                 }
                 billboardGroup->addBillboard(museumObject.title);
                 museumObject.title->setCoordinateSystemID(poses[0].coordinateSystemID);
                 billboardGroup->addBillboard(museumObject.details);
                 museumObject.details->setCoordinateSystemID(poses[0].coordinateSystemID);
                 billboardGroup->addBillboard(museumObject.place);
                 museumObject.place->setCoordinateSystemID(poses[0].coordinateSystemID);
                 museumObject.title->setVisible(true);
                 museumObject.details->setVisible(true);
                 museumObject.place->setVisible(true);
                 break;
    
             }
             else if([museumObject.cosName isEqualToString:@"null"])
             {
                break;
             }
         }
        for(int i=0;i<=10;i++)
        {
            imageObject = billboardImagesArray[i];
            if([cosName isEqualToString:imageObject.cosName])
            {
                
                if(flag == 1)
                {
                    imageObject.imageObject->setVisible(false);
                    break;
                }
                billboardGroup->addBillboard(imageObject.imageObject);
                imageObject.imageObject->setCoordinateSystemID(poses[0].coordinateSystemID);
                imageObject.imageObject->setVisible(true);
                break;
            }
            else if([imageObject.cosName isEqualToString:@"null"])
            {
                break;
            }
        }
        
        for(int i=0;i<=10;i++)
        {
            modelObject = modelsArray[i];
            if([cosName isEqualToString:modelObject.cosName])
            {
                if(flag == 1)
                {
                    modelObject.model->setVisible(false);
                    break;
                }
                modelObject.model->setCoordinateSystemID(poses[0].coordinateSystemID);
                modelObject.model->setVisible(true);
                break;
            }
            else if([modelObject.cosName isEqualToString:@"null"])
            {
                break;
            }
        }
        for(int i=0;i<=10;i++)
        {
            moreDetails = moreDetailsBoardArray[i];
            if([cosName isEqualToString:moreDetails.cosName])
            {
                if(flag == 1)
                {
                    moreDetails.moreDetailsObject->setVisible(false);
                    break;
                }
                billboardGroup->addBillboard(moreDetails.moreDetailsObject);
                moreDetails.moreDetailsObject->setCoordinateSystemID(poses[0].coordinateSystemID);
                moreDetails.moreDetailsObject->setVisible(true);
                break;
            }
            else if([moreDetails.cosName isEqualToString:@"null"])
            {
                break;
            }
        }
        if (flag == 1)
        {
            billboardGroup->removeAllBillboards();
            AssociatedContent *imageObjects = [[AssociatedContent alloc]init];
            for(int i=0;i<=7;i++)
            {
                imageObjects = associatedContent[i];
                billboardGroup->addBillboard(imageObjects.objImage);
                imageObjects.objImage->setCoordinateSystemID(poses[0].coordinateSystemID);
                imageObjects.objImage->setVisible(true);
            }
        }
        
        //billboardGroup->removeAllBillboards();
        //billboard->removeBillboard(museumObject.title);
        //billboard->removeBillboard(museumObject.details);
    }
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"start touching............");
    // Here's how to pick a geometry
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:glView];
    
    MoreDetailsBoard *details = [[MoreDetailsBoard alloc]init];
    MuseumObject *museumObject = [[MuseumObject alloc]init];
    ImageObjects *imageObject = [[ImageObjects alloc]init];
    ModelObjects *modelObject = [[ModelObjects alloc]init];
    AssociatedContent *imageObjects = [[AssociatedContent alloc]init];
    ObjectFromWebService *objectFromWebService = [[ObjectFromWebService alloc]init];
    
    // get the scale factor (will be 2 for retina screens)
    float scale = glView.contentScaleFactor;
    
    // ask sdk if the user picked an object
    // the 'true' flag tells sdk to actually use the vertices for a hit-test, instead of just the bounding box
    metaio::IGeometry *selectedObject = m_metaioSDK->getGeometryFromViewportCoordinates(loc.x * scale, loc.y * scale, true);
    if(selectedObject)
    {
        NSLog(@"Touched an object");
        
    for(int i=0;i<=10;i++)
    {
        
        details = moreDetailsBoardArray[i];
        
        modelObject = modelsArray[i];
        if([details.cosName isEqualToString:@"null"])
        {
            break;
        }
        NSLog(@".................searching.......................");
        if(selectedObject == details.moreDetailsObject)
        {
            NSLog(@"Selected");
            NSString *parsingXMLFile = [[NSBundle mainBundle]pathForResource:@"AssociatedMuseumContents" ofType:@"xml" inDirectory:@"Assets1"];
            NSData *xmlFile = [NSData dataWithContentsOfFile:parsingXMLFile];
            RefereneObjectIDParser *referenceObjectIDParser = [[RefereneObjectIDParser alloc]init];
            NSMutableArray *referenceObject = [referenceObjectIDParser parseXMLFile:xmlFile];
            ReferenceObjectID *referenceObjectID = [[ReferenceObjectID alloc]init];
            for(int i=0;i<=2;i++)
            {
                referenceObjectID = referenceObject[i];
                
                if([referenceObjectID.cName isEqualToString:@"null"])
                {
                    break;
                }
                else if([referenceObjectID.cName isEqualToString:details.cosName])
                {
                    NSLog(@"%@",referenceObjectID.cid);
                    [self connectWebservice:referenceObjectID.cid];
                }
            }
            //break;
        }
    }
    for(int i=0;i<=10;i++)
    {
        museumObject = museumObjectsArray[i];
        if([museumObject.cosName isEqualToString:@"null"])
        {
            break;
        }
        NSLog(@".................searching.......................");
        if(selectedObject == museumObject.title)
        {
            NSLog(@"Selected title");
            MuseumObjects *selectedObject = [[MuseumObjects alloc]init];
            selectedObject.cosName = museumObject.cosName;
            selectedObject.objType = @"object";
            selectedObject.data = museumObject.billboardTitle;
            selectedCosName = museumObject.cosName;
            [selectedContent addObject:selectedObject];
            break;
        }
        if(selectedObject == museumObject.details)
        {
            NSLog(@"Selected details");
            MuseumObjects *selectedObject = [[MuseumObjects alloc]init];
            selectedObject.cosName = museumObject.cosName;
            selectedObject.objType = @"description";
            selectedObject.data = museumObject.billboardDetails;
            selectedCosName = museumObject.cosName;
            [selectedContent addObject:selectedObject];
            break;
        }
        if(selectedObject == museumObject.place)
        {
            NSLog(@"Selected place");
            MuseumObjects *selectedObject = [[MuseumObjects alloc]init];
            selectedObject.cosName = museumObject.cosName;
            selectedObject.objType = @"geolocation";
            selectedObject.data = museumObject.placeName;
            selectedCosName = museumObject.cosName;
            //NSLog(@"%@",museumObject.cosName);
            Location *geolocation = [[Location alloc]init];
            for(int i=0;i<=2;i++)
            {
                geolocation = location[i];
                if([geolocation.cosName isEqualToString:@"null"])
                {
                    break;
                }
                if([selectedCosName isEqualToString:geolocation.cosName])
                {
                    NSLog(@"%@",selectedCosName);
                    selectedObject.latitude = geolocation.latitude;
                    NSLog(@"%@",geolocation.latitude);
                    selectedObject.longitude = geolocation.longitude;
                    NSLog(@"%@",geolocation.longitude);
                }
            }
            [selectedContent addObject:selectedObject];
            break;
        }
    }
    for(int i=0;i<=10;i++)
    {
        imageObject = billboardImagesArray[i];
        if([imageObject.cosName isEqualToString:@"null"])
        {
            break;
        }
        NSLog(@".................searching.......................");
        if(selectedObject == imageObject.imageObject)
        {
            NSLog(@"Selected image");
            MuseumObjects *selectedObject = [[MuseumObjects alloc]init];
            selectedObject.cosName = imageObject.cosName;
            selectedObject.objType = @"media";
            selectedObject.imagePath = imageObject.imagePath;
            selectedObject.img = imageObject.image;
            selectedCosName = imageObject.cosName;
            [selectedContent addObject:selectedObject];
            break;
        }
    }
    if(flag == 1)
    {
        for(int i=0;i<=10;i++)
        {
            imageObjects = associatedContent[i];
            if([imageObjects.cosName isEqualToString:@"null"])
            {
                break;
            }
            NSLog(@"................searching........................");
            if(selectedObject == imageObjects.objImage)
            {
                NSLog(@"Selected image");
                MuseumObjects *selectedObject = [[MuseumObjects alloc]init];
                selectedObject.cosName = imageObjects.cosName;
                selectedObject.objType = @"Associated Image";
                selectedObject.imagePath = imageObjects.urldata;
                selectedCosName = imageObjects.cosName;
                selectedObject.latitude = imageObjects.latitude;
                selectedObject.longitude = imageObjects.longitude;
                selectedObject.img = imageObjects.img;
                [selectedContent addObject:selectedObject];
            }
        }
    }
    if(set==1)
    {
    for(int i=0;i<=10;i++)
    {
        objectFromWebService = contentFromWebServices[i];
        if([objectFromWebService.cosName isEqualToString:@"null"])
        {
            break;
        }
        NSLog(@"..................searching......................");
        if(selectedObject == objectFromWebService.object)
        {
            NSLog(@"Selected contents form web service");
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = objectFromWebService.cosName;
            museumObjects.objType = @"object";
            museumObjects.data = objectFromWebService.objName;
            selectedCosName = objectFromWebService.cosName;
            [selectedContent addObject:museumObjects];
            break;
        }
        else if(selectedObject == objectFromWebService.physicalDescription)
        {
            NSLog(@"Selected contents form web service");
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = objectFromWebService.cosName;
            museumObjects.objType = @"details";
            museumObjects.data = objectFromWebService.description;
            selectedCosName = objectFromWebService.cosName;
            [selectedContent addObject:museumObjects];
            break;
        }
        else if(selectedObject == objectFromWebService.details)
        {
            NSLog(@"Selected contents form web service");
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = objectFromWebService.cosName;
            museumObjects.objType = @"details";
            museumObjects.data = objectFromWebService.objDetails;
            selectedCosName = objectFromWebService.cosName;
            [selectedContent addObject:museumObjects];
            break;
        }
        else if(selectedObject == objectFromWebService.imageBillboard)
        {
            NSLog(@"Selected contents from web service");
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = objectFromWebService.cosName;
            museumObjects.objType = @"media";
            museumObjects.imagePath = objectFromWebService.urlPath;
            museumObjects.img = objectFromWebService.image;
            selectedCosName = objectFromWebService.cosName;
            [selectedContent addObject:museumObjects];
            NSString *search, *replace;
            NSMutableString *pathToObject;
            NSRange substr;
            search = @" ";
            replace = @"%20";
            NSString *urlString = @"http://www.vam.ac.uk/api/json/museumobject/?q=";
            urlString = [urlString stringByAppendingString:objectFromWebService.objName];
            NSLog(@"V&A url string : %@",urlString);
            pathToObject = [NSMutableString stringWithString:urlString];
            substr = [pathToObject rangeOfString:search];
            while(substr.location != NSNotFound)
            {
                [pathToObject replaceCharactersInRange:substr withString:replace];
                substr = [pathToObject rangeOfString:search];
            }
            NSLog(@"GoogleMap url string : %@",pathToObject);
            [self connectWebservice:pathToObject];
            break;
        }
        else if(selectedObject == objectFromWebService.placeBillboard)
        {
            NSLog(@"Selected contens from web service");
            MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
            museumObjects.cosName = objectFromWebService.cosName;
            museumObjects.objType = @"geolocation";
            museumObjects.latitude = objectFromWebService.latitude;
            museumObjects.longitude = objectFromWebService.longitude;
            [selectedContent addObject:museumObjects];
        }
    }
    }
    }
    NSLog(@"Done");
}
@end
