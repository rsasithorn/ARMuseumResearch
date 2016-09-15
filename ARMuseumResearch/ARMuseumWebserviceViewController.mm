//
//  ARMuseumWebserviceViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 28/09/2014.
//  Copyright (c) 2014 Sasithorn Rattanarungrot. All rights reserved.
//

#import "ARMuseumWebserviceViewController.h"
#import "EAGLView.h"
@interface ARMuseumWebserviceViewController ()

@end

@implementation ARMuseumWebserviceViewController
@synthesize billboardImage;
@synthesize poses;
@synthesize arrayOfContent;
@synthesize cosNameResult;
@synthesize museumobjectImagesArray;
@synthesize museumobjectName;
@synthesize billboardGroup;
@synthesize imageBillboardGroup;
@synthesize referenceObject;
@synthesize arrayOfAllContent;
@synthesize museumObject;
@synthesize arrayOfImage;
@synthesize set;
@synthesize mset;
@synthesize request;
@synthesize service;
@synthesize objectPose;
@synthesize arrayOfAllSelectedContent;
@synthesize textField;
@synthesize cName;
@synthesize newmanageObjectContext;
@synthesize fetchedResultsController;
@synthesize manageObjectModel= _manageObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize source = _source;
@synthesize preferredObjects;
@synthesize imageBillboard;
@synthesize textBillboard;
@synthesize model;
@synthesize video;
@synthesize geoLocation;
@synthesize bowlModel;
@synthesize tinModel;
@synthesize arrayOfModel;
@synthesize locations;
@synthesize trackedCosName;

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
    // Do any additional setup after loading the view from its nib.
    //NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_ML3DMultipleObj" ofType:@"xml" inDirectory:@"Assets1"];
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"MarkerlessTracking" ofType:@"xml" inDirectory:@"Assets1"];
    //NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"Tracking" ofType:@"xml" inDirectory:@"Assets1"];
    if(trackingDataFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
		if( !success)
        {
			NSLog(@"No success loading the tracking configuration for the first obj");
        }
        
        NSString *parsingXMLFile = [[NSBundle mainBundle]pathForResource:@"AssociatedContents" ofType:@"xml" inDirectory:@"Assets1"];
        NSData *xmlFile = [NSData dataWithContentsOfFile:parsingXMLFile];
        RefereneObjectIDParser *referenceObjectIDParser = [[RefereneObjectIDParser alloc]init];
        referenceObject = [referenceObjectIDParser parseXMLFile:xmlFile];
        
        arrayOfAllContent = [[NSMutableArray alloc]init];
        arrayOfAllSelectedContent = [[NSMutableArray alloc ]init];
        arrayOfModel = [[NSMutableArray alloc]init];
        //arrayOfImage = [[NSMutableArray alloc]init];
        
        //billboardPose.translation = metaio::Vector3d(-250,100,0);
        //imagePose.translation = metaio::Vector3d(-100,250,0);
        //coreDataContext = [[CoreDataContext alloc]init];
        objectPose.translation = metaio::Vector3d(-250,100,0);
        //m_metaioSDK->setCosOffset(metaio::Vector3d(-250,100,0), poses);
        
        billboardGroup = m_metaioSDK->createBillboardGroup(1.0f, 3.0f);
        billboardGroup->setBillboardExpandFactors(1, 2, 10 );
        m_metaioSDK->setRendererClippingPlaneLimits(10, 200000);
        
        MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
        museumObjects.cosName = @"firstobject";
        museumObjects.object = NULL;
        flag = 0;
        num = 0;
        [arrayOfAllContent addObject:museumObjects];
        
        ModelObjects *modelObjects = [[ModelObjects alloc]init];
        modelObjects.cosName = @"firstobject";
        [arrayOfModel addObject:modelObjects];
        
        if(referenceObject)
        {
            NSLog(@"Parsed");
        }
        
        NSPersistentStoreCoordinator *psc = [self persistentStoreCoordinator];
        newmanageObjectContext = [[NSManagedObjectContext alloc] init];
        [newmanageObjectContext setPersistentStoreCoordinator:psc];
    }
}
- (NSString *)source
{
    _source = @"Home-based";
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
    //return [[[NSFileManager defaultManager] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask] lastObject];
}
-(void)createModels:(NSString *)cosName
{
    NSString *parsingXMLFile = [[NSBundle mainBundle]pathForResource:@"ModelObjects" ofType:@"xml" inDirectory:@"Assets1"];
    NSData *xmlFile = [NSData dataWithContentsOfFile:parsingXMLFile];
    ModelContentsParser *modelContentParser = [[ModelContentsParser alloc]init];
    //self.modelElement = [modelContentParser parseXMLFile:xmlFile];
    NSMutableArray *modelArray = [modelContentParser parseXMLFile:xmlFile];
    ModelElements *modelElements = [[ModelElements alloc]init];
    for(int i = 0;i<=10;i++)
    {
        modelElements = modelArray[i];
         if([modelElements.cosName isEqualToString:cosName])
         {
             NSString* metaioModel = [[NSBundle mainBundle] pathForResource:modelElements.modelFilename ofType:modelElements.modelFileType inDirectory:@"Assets1/Bowl2Obj"];
             if(metaioModel)
             {
                 // if this call was successful, theLoadedModel will contain a pointer to the 3D model
                 ModelObjects *modelObjects = [[ModelObjects alloc]init];
                 modelObjects.model =  m_metaioSDK->createGeometry([metaioModel UTF8String]);
                 if( modelObjects.model )
                 {
                     modelObjects.model->setScale(metaio::Vector3d(1.0,1.0,1.0));
                     modelObjects.model->setTranslation(metaio::Vector3d(500, 220, 0),TRUE);
                     modelObjects.model->setRotation(metaio::Rotation(metaio::Vector3d(-M_PI_2, -M_PI, 0)));
                     //bowlModel->setRotation(metaio::Rotation(metaio::Vector3d(-M_PI_2, 0, -M_PI)));
                     //bowlModel->setRotation(metaio::Rotation(metaio::Vector3d(0,-M_PI_2,-M_PI)));
                     modelObjects.model->setVisible(false);
                 }
                 else
                 {
                     NSLog(@"error, could not load %@", metaioModel);
                     break;
                 }
                 modelObjects.cosName = cosName;
                 modelObjects.modelName = modelElements.modelFilename;
                 modelObjects.modeltype = modelElements.modelFileType;
                 ModelObjects *obj = [[ModelObjects alloc]init];
                 for(int i=0;i<=10;i++)
                 {
                     obj = arrayOfModel[i];
                     if([obj.cosName isEqualToString:@"firstobject"] || [obj.cosName isEqualToString:@"null"])
                    {
                        [arrayOfModel removeObject:obj];
                        [arrayOfModel addObject:modelObjects];
                        ModelObjects *nullObj = [[ModelObjects alloc]init];
                        nullObj.cosName = @"null";
                        [arrayOfModel addObject:nullObj];
                        break;
                    }
                }
                 break;
             }
         }
        else if([modelElements.cosName isEqualToString:@"null"])
        {
            break;
        }
    
    }
}
- (IBAction)downloadARMuseumContent
{
       [self manageMuseumContents];
}
- (void)connectWebServices:(NSString *)cosName
{
    XMLMuseumContentParser *museumContentParser = [[XMLMuseumContentParser alloc]init];
    XMLImageContentParser *imageContentParser = [[XMLImageContentParser alloc]init];
    ReferenceObjectID *referenceObjectID = [[ReferenceObjectID alloc]init];
        for(int i=0;i<=7;i++)
        {
            referenceObjectID = referenceObject[i];
            if([referenceObjectID.cName isEqualToString:@"null"])
            {
                break;
            }
            else if([referenceObjectID.cName isEqualToString:cosName])
            {
                NSString *urlString;
                if (request == 1)
                {
                    urlString = @"http://sierraleone.heritageinformatics.org/index.php/api/search_service/get_related_list/coid/";
                    urlString = [urlString stringByAppendingString:referenceObjectID.oid];
                    urlString = [urlString stringByAppendingString:@"/offset/0/size/1/format/xml"];
                    //break;
                }
                else
                {
                    urlString = referenceObjectID.cid;
                }
                if([referenceObjectID.cid isEqualToString:@"null"])
                {
                    MuseumContentElement *museumContent = [[MuseumContentElement alloc]init];
                    museumContent.cosName = referenceObjectID.cName;
                    museumContent.elementName = @"null";
                    museumContent.data = @"null";
                    [arrayOfContent addObject:museumContent];
                    //break;
                }
                else
                {
                //NSString *urlString = referenceObjectID.cid;
                NSURL *url = [NSURL URLWithString:urlString];
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
                [urlRequest setTimeoutInterval:30.0f];
                [urlRequest setHTTPMethod:@"GET"];
                NSOperationQueue *queue = [[NSOperationQueue alloc]init];
                
                [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                 {
                     if([data length] > 0 && error == nil)
                     {
                        if(request == 1)
                        {
                            arrayOfContent = [imageContentParser parseXMLFile:data];
                        }
                        else
                        {
                            arrayOfContent = [museumContentParser parseXMLFile:data];
                        }
                         MuseumContentElement *museumContent = [[MuseumContentElement alloc]init];
                         museumContent = NULL;
                         for(int i=0;i<=10;i++)
                         {
                             museumContent = arrayOfContent[i];
                             museumContent.cosName = referenceObjectID.cName;
                             NSLog(@"Parsed     %@",museumContent.data);
                             if([museumContent.elementName isEqualToString:@"null"])
                             {
                                 break;
                             }
                         }
                     }
                     else if(error != nil)
                     {
                         NSLog(@"Error happended = %@",error);
                     }
                 }
                 ];
                }
            }
        }
}

- (IBAction)loadUserPreferences
{
    LoadPreferencesViewController *loadPreferencesViewController = [[LoadPreferencesViewController alloc]initWithNibName:@"LoadPreferencesViewController" bundle:Nil];
    loadPreferencesViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [loadPreferencesViewController setArrayOfContents:arrayOfAllSelectedContent];
    [self presentViewController:loadPreferencesViewController animated:YES completion:NULL];
}

- (IBAction)saveGeometries:(id)sender
{
    MuseumObjects *object = [[MuseumObjects alloc]init];
    object.cosName = @"null";
    [arrayOfAllSelectedContent addObject:object];
    flag = 1;
    for(int i=0;i<=20;i++)
    {
        object = arrayOfAllContent[i];
        if([object.cosName isEqualToString:@"null"])
        {
            break;
        }
        object.object->setVisible(false);
    }
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
            savedObjects = arrayOfAllSelectedContent[i];
            if([savedObjects.cosName isEqualToString:@"null"])
            {
                break;
            }
            if([savedObjects.objType isEqualToString:@"media"])
            {
                imageBillboard = [NSEntityDescription insertNewObjectForEntityForName:@"ImageBillboard" inManagedObjectContext:newmanageObjectContext];
                imageBillboard.imageonbillboard = savedObjects.img;
            
                [preferredObjects addImageObject:imageBillboard];
            }
            else if([savedObjects.objType isEqualToString:@"object"]||[savedObjects.objType isEqualToString:@"description"])
            {
                textBillboard = [NSEntityDescription insertNewObjectForEntityForName:@"TextBillboard" inManagedObjectContext:newmanageObjectContext];
                textBillboard.textonbillboard = savedObjects.data;
                textBillboard.billboardtype = savedObjects.objType;
                [preferredObjects addTextObject:textBillboard];
            }
            else if([savedObjects.objType isEqualToString:@"museum"])
            {
                preferredObjects.museum = savedObjects.data;
                geoLocation = [NSEntityDescription insertNewObjectForEntityForName:@"GeoLocation" inManagedObjectContext:newmanageObjectContext];
                geoLocation.latitude = [locations[0] doubleValue];
                geoLocation.longitude = [locations[1] doubleValue];
                preferredObjects.location = geoLocation;
            }
        
        }
        
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
    //[self readData];
}
/*-(void)readData
{
    NSManagedObjectContext *datacontext = self.newmanageObjectContext;
    NSEntityDescription *contentEntity = [NSEntityDescription entityForName:@"PreferredObjects" inManagedObjectContext:datacontext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:contentEntity];
    NSArray *content = [datacontext  executeFetchRequest:fetchRequest error:nil];
    id selectedData;
    NSEnumerator *it = [content objectEnumerator];
    while((selectedData = [it nextObject]) != nil)
    {
        NSLog(@"%@",[selectedData valueForKey:@"preferencename"]);
    
    }
    
}*/

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel...");
        flag = 0;
        //dealloc:arrayOfAllSelectedContent;
        arrayOfAllSelectedContent = [[NSMutableArray alloc ]init];
    }
    else if([buttonTitle isEqualToString:@"OK"])
    {
        NSLog(@"OK....");
        NSString *input = textField.text;
        NSLog(@"%@",input);
        [self saveToCoreDataDB:textField.text];
        arrayOfAllSelectedContent = [[NSMutableArray alloc]init];
    }
}

- (IBAction)restartTracking:(id)sender
{
        flag = 0;
        request = 0;
        //dealloc:arrayOfAllSelectedContent;
        arrayOfAllSelectedContent = [[NSMutableArray alloc ]init];
        //arrayOfImage = [[NSMutableArray alloc]init];
        MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
        for(int i=0;i<=20;i++)
        {
            museumObjects = arrayOfImage[i];
            if([museumObjects.cosName isEqualToString:@"null"])
            {
                break;
            }
            else
            {
                museumObjects.object->setVisible(false);
            }
        }
}
- (IBAction)requestAssociatedContent:(id)sender
{
    arrayOfImage = [[NSMutableArray alloc]init];
    request = 0;
    MuseumContentElement *content = [[MuseumContentElement alloc]init];
    UIImage *image;
    NSURL *url;
    NSData *data;
    NSString *search, *replace;
    NSMutableString *pathToObject;
    NSRange substr;
    search = @" ";
    replace = @"%20";
    for(int i=0;i<10;i++)
    {
        content = arrayOfContent[i];
        MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
        if([content.elementName isEqualToString:@"media"])
        {
            pathToObject = [NSMutableString stringWithString:content.data];
            substr = [pathToObject rangeOfString:search];
            while(substr.location != NSNotFound)
            {
                [pathToObject replaceCharactersInRange:substr withString:replace];
                substr = [pathToObject rangeOfString:search];
            }
            NSLog(@"%@",pathToObject);
            url = [NSURL URLWithString:pathToObject];
            data = [NSData dataWithContentsOfURL:url];
            image = [[UIImage alloc]initWithData:data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Media", [image CGImage], true);
            museumObjects.cosName = content.cosName;
            museumObjects.objType = content.elementName;
            museumObjects.img = data;
            
            museumObjects.object->setScale(metaio::Vector3d(1.0,1.0,1.0));
            //billboardGroup->addBillboard(museumObjects.object);
            //imageBillboardGroup->addBillboard(museumObjects.object);
            //imageObjects.imageObject->setVisible(false);
            museumObjects.object->setVisible(false);
            [arrayOfImage addObject:museumObjects];
            NSLog(@"Done images");
            //museumObject.billboard = m_metaioSDK->createGeometryFromImage([content.data],true);
        }
        else if([content.elementName isEqualToString:@"null"])
        {
            museumObjects.cosName = @"null";
            [arrayOfImage addObject:museumObjects];
            break;
        }
    }
    MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
    museumObjects.cosName = @"null";
    [arrayOfImage addObject:museumObjects];
    MuseumObjects *object = [[MuseumObjects alloc]init];
    for(int i=0;i<=40;i++)
    {
        object = arrayOfAllContent[i];
        if([object.cosName isEqualToString:@"null"])
        {
            break;
        }
        object.object->setVisible(false);
    }
    flag = 2;
}
- (void)manageMuseumContents
{
    MuseumContentElement *content = [[MuseumContentElement alloc]init];
    content.cosName = @"null";
    [arrayOfContent addObject:content];
    MuseumObjects *obj = [[MuseumObjects alloc]init];
    NSLog(@"In the ManageMuseumContents module");
    locations = [[NSMutableArray alloc]init];
    UIImage *image;
    NSURL *url;
    NSData *data;
    NSString *search, *replace;
    NSMutableString *pathToObject;
    NSRange substr;
    search = @" ";
    replace = @"%20";
    
    /*billboardGroup = m_metaioSDK->createBillboardGroup(1.0f, 3.0f);
    billboardGroup->setBillboardExpandFactors(1, 2, 10 );
    m_metaioSDK->setRendererClippingPlaneLimits(10, 200000);*/

    for(int i=0;i<=40;i++)
    {
        content = arrayOfContent[i];
        MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
        if([content.cosName isEqualToString:@"null"])
        {
            break;
        }
        if([content.elementName isEqualToString:@"object"])
        {
            image = [self getBillboardImageForTitle:content.data];
            //image = [self getAnnotationImageForTitle:content.data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Object", [image CGImage],true);
            museumObjects.cosName = content.cosName;
            museumObjects.objType = content.elementName;
            museumObjects.data = content.data;
            //billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            NSLog(@"Done billboard");
        }
        else if([content.elementName isEqualToString:@"description"])
        {
            image = [self getBillboardImageForTitle:content.data];
            //image = [self getAnnotationImageForTitle:content.data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Description", [image CGImage],true);
            museumObjects.cosName = content.cosName;
            museumObjects.objType = content.elementName;
            museumObjects.data = content.data;
            //billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            NSLog(@"Done billboard");
        }
        else if([content.elementName isEqualToString:@"media"])
        {
            pathToObject = [NSMutableString stringWithString:content.data];
            substr = [pathToObject rangeOfString:search];
            while(substr.location != NSNotFound)
            {
                [pathToObject replaceCharactersInRange:substr withString:replace];
                substr = [pathToObject rangeOfString:search];
            }
            NSLog(@"%@",pathToObject);
            url = [NSURL URLWithString:pathToObject];
            data = [NSData dataWithContentsOfURL:url];
            image = [[UIImage alloc]initWithData:data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Media", [image CGImage], true);
            museumObjects.cosName = content.cosName;
            museumObjects.objType = content.elementName;
            museumObjects.img = data;
        
            museumObjects.object->setScale(metaio::Vector3d(1.0,1.0,1.0));
            //billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            NSLog(@"Done images");
        }
        else if([content.elementName isEqualToString:@"museum"])
        {
            image = [self getBillboardImageForTitle:content.data];
            museumObjects.object = m_metaioSDK->createGeometryFromCGImage("Museum", [image CGImage],true);
            museumObjects.cosName = content.cosName;
            museumObjects.objType = content.elementName;
            museumObjects.data = content.data;
            //billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
            NSLog(@"Done billboard");
            [self getLocation:museumObjects.data];
        }
        else if([content.elementName isEqualToString:@"null"])
        {
            NSString* imagepath = [[NSBundle mainBundle] pathForResource:@"MoreDetails" ofType:@"png" inDirectory:@"Assets1"];
            museumObjects.cosName = content.cosName;
            museumObjects.objType = @"moreDetails";
            museumObjects.object = m_metaioSDK->createGeometryFromImage([imagepath UTF8String],true);
            NSLog(@"Done more details billboard");
            //NSLog(@"%id",museumObjects.object);
            //billboardGroup->addBillboard(museumObjects.object);
            museumObjects.object->setVisible(false);
        }
        
        for(int i=0;i<=40;i++)
        {
            obj = arrayOfAllContent[i];
            if([obj.cosName isEqualToString:@"serviceobject"])
            {
                obj.cosName = museumObjects.cosName;
                obj.object = museumObjects.object;
                obj.objType = museumObjects.objType;
                obj.data = museumObjects.data;
                obj.img = museumObjects.img;
                MuseumObjects *nilObj = [[MuseumObjects alloc]init];
                nilObj.cosName = @"null";
                [arrayOfAllContent addObject:nilObj];
                break;
            }
            else if([obj.cosName isEqualToString:@"null"])
            {
                obj.cosName = museumObjects.cosName;
                obj.object = museumObjects.object;
                obj.objType = museumObjects.objType;
                obj.data = museumObjects.data;
                obj.img = museumObjects.img;
                MuseumObjects *nilObj = [[MuseumObjects alloc]init];
                nilObj.cosName = @"null";
                [arrayOfAllContent addObject:nilObj];
                break;
            }
        }
        
    }
    service = @"null";
}
-(void)getLocation:(NSString *)museum
{
    NSString *search, *replace;
    NSMutableString *pathToObject;
    NSRange substr;
    search = @" ";
    replace = @"%20";
    NSString *urlString = @"https://maps.googleapis.com/maps/api/place/textsearch/json?query=";
    urlString = [urlString stringByAppendingString:museum];
    urlString = [urlString stringByAppendingString:@"&key=AIzaSyC3GtYIqNylldA29Enfyg_YM5uSfjnHm94"];
    NSLog(@"GoogleMap url string : %@",urlString);
    pathToObject = [NSMutableString stringWithString:urlString];
    substr = [pathToObject rangeOfString:search];
    while(substr.location != NSNotFound)
    {
        [pathToObject replaceCharactersInRange:substr withString:replace];
        substr = [pathToObject rangeOfString:search];
    }
    NSLog(@"GoogleMap url string : %@",pathToObject);
    
    NSURL *url = [NSURL URLWithString:pathToObject];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil)
         {
             NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"HTML = %@",html);
             id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             if(jsonObject != nil && error == nil)
             {
                 NSLog(@"Successfully deserialized...");
                 if([jsonObject isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *deserializedDictionary = jsonObject;
                     NSLog(@"Deserialized JSON Dictionary = %@",deserializedDictionary);
                     NSDictionary *googleMapPlace = [[deserializedDictionary objectForKey:@"results"]objectAtIndex:0];
                     NSDictionary *geometry = [googleMapPlace objectForKey:@"geometry"];
                     NSDictionary *location = [geometry objectForKey:@"location"];
                     NSString *lat = [location objectForKey:@"lat"];
                     NSLog(@"lat : %@",lat);
                     NSString *lng = [location objectForKey:@"lng"];
                     NSLog(@"lng : %@",lng);
                     [locations addObject:lat];
                     [locations addObject:lng];
                 }
                 else if([jsonObject isKindOfClass:[NSArray class]])
                 {
                     NSArray *deserializedArray = (NSArray *)jsonObject;
                     NSLog(@"Deserialized JSON Array = %@",deserializedArray);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage*) getBillboardImageForTitle: (NSString*) title
{
    // first lets find out if we're drawing retina resolution or not
    float scaleFactor = [UIScreen mainScreen].scale;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scaleFactor = 2;        // draw in high-res for iPad
    
    // then lets draw
    UIImage* bgImage = nil;
    NSString* imagePath;
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
    [title drawInRect:CGRectMake(border, border, bgImage.size.width - 2 * border, bgImage.size.height - 2 * border ) withFont:[UIFont systemFontOfSize:9]];//*scaleFactor]];
    
    // retrieve the screenshot from the current context
    UIImage* blendetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendetImage;
}
- (UIImage*)getAnnotationImageForTitle:(NSString*)title
{
    UIImage* bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"Assets1/Billboards/POI_bg%s", [UIScreen mainScreen].scale >= 2 ? "@2x" : ""]];
    //UIImage* bgImage = [UIImage imageNamed:@"Assets1/Billboards/POI_bg"];
    assert(bgImage);
    
    UIGraphicsBeginImageContext(bgImage.size);
    CGContextRef currContext = UIGraphicsGetCurrentContext();
    
    // Mirror the context transformation to draw the images correctly (CG has different coordinates)
    CGContextSaveGState(currContext);
    CGContextScaleCTM(currContext, 1.0, -1.0);
    
    CGContextDrawImage(currContext, CGRectMake(0, 0, bgImage.size.width, -bgImage.size.height), bgImage.CGImage);
    
    CGContextRestoreGState(currContext);
    
    // Add title
    CGContextSetRGBFillColor(currContext, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetTextDrawingMode(currContext, kCGTextFill);
    CGContextSetShouldAntialias(currContext, true);
    
    const CGFloat fontSize = floor(bgImage.size.height * 0.16);
    const CGFloat border = floor(bgImage.size.height * 0.1);
    CGRect titleRect = CGRectMake(border, border, bgImage.size.width - 2*border, bgImage.size.height - 2*border);
    const CGSize titleActualSize = [title sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:titleRect.size lineBreakMode:NSLineBreakByTruncatingTail];
    
    // Vertically center text
    titleRect.origin.y += (titleRect.size.height - titleActualSize.height) / 4.0f;
    
    [title drawInRect:titleRect
             withFont:[UIFont systemFontOfSize:fontSize]
        lineBreakMode:NSLineBreakByTruncatingTail
            alignment:NSTextAlignmentCenter];
    
    // Create composed UIImage from the context
    UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Here's how to pick a geometry
    UITouch *touch = [touches anyObject];
    MuseumObjects *object = [[MuseumObjects alloc]init];
    //ModelObjects *modelObj = [[ModelObjects alloc]init];
    NSLog(@"start touching....................................");
    CGPoint loc = [touch locationInView:glView];
    
    // get the scale factor (will be 2 for retina screens)
    float scale = glView.contentScaleFactor;
    
    // ask sdk if the user picked an object
    // the 'true' flag tells sdk to actually use the vertices for a hit-test, instead of just the bounding box
    metaio::IGeometry* selectedModel = m_metaioSDK->getGeometryFromViewportCoordinates(loc.x * scale, loc.y * scale, true);
    /*if(model)
    {
        NSLog(@"........found");
        
    }*/
    
    for(int i=0;i<=40;i++)
     {
     //moreDetails = moreDetailsBoardArray[i];
         object = arrayOfAllContent[i];
     //if(model == moreDetails.moreDetailsObject)
         if(selectedModel == object.object)
         {
             NSLog(@"Selected....................................");
             NSLog(@"Selected %@",object.cosName);
             selectedCosName = object.cosName;
             if([object.objType isEqualToString:@"moreDetails"])
             {
                 request = 1;
                 [self connectWebServices:selectedCosName];
                 break;
             }
             [arrayOfAllSelectedContent addObject:object];
             break;
         }
         else
         {
             NSLog(@"not found");
         }
     }
    
    /*for(int i=0;i<=10;i++)
    {
        modelObj = arrayOfModel[i];
        if(selectedModel == modelObj.model)
        {
            NSLog(@"Selected model.....................");
            NSLog(@"Selected %@",modelObj.cosName);
            
        
        }
    
    
    }*/
    /*if ( model == m_metaioMan)
     {
     // we have touched the metaio man
     // let's start an animation
     model->startAnimation( "shock_down" , false);
     }*/
}
- (void)drawFrame
{
    [super drawFrame];
    
    // return if the metaio SDK has not been initialiyed yet
    
    if( !m_metaioSDK )
        return;
    
    NSLog(@"Found");
    
    // get all the detected poses/targets
    //std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();
    //NSString *cosName;
    //if we have detected one, attach our metaioman to this coordinate system ID
    MuseumObjects *museumObjects = [[MuseumObjects alloc]init];
    poses = m_metaioSDK->getTrackingValues();
   // m_metaioSDK->setCosOffset(poses[0].coordinateSystemID, objectPose);
    //MuseumObject *object = [[MuseumObject alloc]init];
    //ImageObjects *imageObject = [[ImageObjects alloc]init];
    if(poses.size())
    {
        trackedCosName = [NSString stringWithFormat:@"%s",poses[0].cosName.c_str()];
        NSLog(@"Found %@",trackedCosName);
        NSLog(@"%f",poses[0].translation.x);
        NSLog(@"%f",poses[0].translation.y);
        NSLog(@"%f",poses[0].translation.z);
        //NSLog(@"%f",poses[0].llaCoordinate.);
        //MuseumObject *object = [[MuseumObject alloc]init];
        //MuseumObjects *museumObject = [[MuseumObjects alloc]init];
        if(flag == 0)
        {
        for(int i=0;i<=100;i++)
        {
            //object = arrayOfBillboard[i];
            museumObjects = arrayOfAllContent[i];
            if([museumObjects.cosName isEqualToString:trackedCosName])
            {
                if([museumObjects.objType isEqualToString:@"object"] || [museumObjects.objType isEqualToString:@"description"])
                {
                    //billboardPose.translation = metaio::Vector3d(-250,100,0);
                    //m_metaioSDK->setCosOffset(poses[0].coordinateSystemID,billboardPose);
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    museumObjects.object->setVisible(true);
                    set = 1;
                }
                else if([museumObjects.objType isEqualToString:@"media"])
                {
                    //magePose.translation = metaio::Vector3d(-100,600,0);
                    //m_metaioSDK->setCosOffset(poses[0].coordinateSystemID,imagePose);
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    museumObjects.object->setVisible(true);
                }
                else if([museumObjects.objType isEqualToString:@"museum"])
                {
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    NSLog(@"set museum");
                    museumObjects.object->setVisible(true);
                }
                else if([museumObjects.objType isEqualToString:@"moreDetails"])
                {
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    NSLog(@"set moredetails");
                    museumObjects.object->setVisible(true);
                }
                if([museumObjects.cosName isEqualToString:@"cos3"])
                {
                    ModelObjects *modelObj = [[ModelObjects alloc]init];
                    for(int i=0;i<=10;i++)
                    {
                        modelObj = arrayOfModel[i];
                        if([modelObj.cosName isEqualToString:museumObjects.cosName])
                        {
                            modelObj.model->setCoordinateSystemID(poses[0].coordinateSystemID);
                            modelObj.model->setVisible(true);
                            break;
                        }
                        else if ([modelObj.cosName isEqualToString:@"firstobject"])
                        {
                            [self createModels:museumObjects.cosName ];
                            break;
                        }
                        else if ([modelObj.cosName isEqualToString:@"null"])
                        {
                            break;
                        }
                    }
                    
                }
            }
            else if([museumObjects.cosName isEqualToString:@"null"] && set == 1)
            {
                break;
            }
            else if([museumObjects.cosName isEqualToString:@"firstobject"])
            {
                [self connectWebServices:trackedCosName];
                museumObjects = arrayOfAllContent[0];
                museumObjects.cosName = @"serviceobject";
                break;
            }
            else if([museumObjects.cosName isEqualToString:@"null"] && set != 1)
            {
                [self connectWebServices:trackedCosName];
                service = @"connected";
                break;
            }
            else if([museumObjects.cosName isEqualToString:@"serviceobject"])
            {
                break;
            }
            else if([service isEqualToString:@"connected"])
            {
                break;
            }
    
        }
        }
        else if (flag==1)
        {
            billboardGroup->removeAllBillboards();
            for(int i =0;i <= 20;i++)
            {
                NSLog(@"%i",flag);
                museumObjects = arrayOfAllSelectedContent[i];
                NSLog(@"%@",museumObjects.cosName);
                if([trackedCosName isEqualToString:museumObjects.cosName])
                {
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    museumObjects.object->setVisible(true);
                }
                else
                {
                    break;
                }
            }
        }
        else if (flag == 2)
        {
            billboardGroup->removeAllBillboards();
            for(int i=0;i <10;i++)
            {
                NSLog(@"%i",flag);
                museumObjects = arrayOfImage[i];
                NSLog(@"%@",museumObjects.cosName);
                if([trackedCosName isEqualToString:museumObjects.cosName])
                {
                    museumObjects.object->setCoordinateSystemID(poses[0].coordinateSystemID);
                    billboardGroup->addBillboard(museumObjects.object);
                    museumObjects.object->setVisible(true);
                }
                else
                {
                    break;
                }
            }
        }
    }
    else
    {
        set = 0;
        flag = 0;
        billboardGroup->removeAllBillboards();
        //request = 0;
    }
    
}
@end
