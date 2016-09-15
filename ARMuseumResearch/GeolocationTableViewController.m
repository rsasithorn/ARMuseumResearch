//
//  GeolocationTableViewController.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 18/02/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import "GeolocationTableViewController.h"

@interface GeolocationTableViewController ()

@end

@implementation GeolocationTableViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize manageObjectModel= _manageObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        self.title = @"Geolocations";
        //self.tabBarItem.title = @"Geolocation";
    }
    return self;
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
-(NSFetchedResultsController *)fetchedResultsController
{
    if(fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PreferredObjects" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"datecreate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"MuseumNameList"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
    if(![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@ %@",error, [error userInfo]);
        abort();
    }
    return fetchedResultsController;
}
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSPersistentStoreCoordinator *psc = [self persistentStoreCoordinator];
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:psc];
    [self readData];
}
-(void)readData
{
    NSManagedObjectContext *datacontext = self.managedObjectContext;
    NSEntityDescription *contentEntity = [NSEntityDescription entityForName:@"PreferredObjects" inManagedObjectContext:datacontext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:contentEntity];
    NSArray *content = [datacontext  executeFetchRequest:fetchRequest error:nil];
    id selectedData;
    NSEnumerator *it = [content objectEnumerator];
    while((selectedData = [it nextObject]) != nil)
    {
        NSLog(@"%@",[selectedData valueForKey:@"museum"]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [[fetchedResultsController sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"museum"] description];
    //cell.detailTextLabel.text = [[managedObject valueForKey:@"datecreate"] description];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (IBAction)closeImageView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *selectedContents = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObject *geolocation = [selectedContents valueForKey:@"location"];
    NSNumber *lat = [geolocation valueForKey:@"latitude"];
    NSLog(@"lat : %@",lat);
    NSNumber *lon = [geolocation valueForKey:@"longitude"];
    NSLog(@"lon : %@",lon);
    
    NSString *urlString = @"https://maps.googleapis.com/maps/api/staticmap?center=";
    urlString = [urlString stringByAppendingString:[lat stringValue]];
    urlString = [urlString stringByAppendingString:@","];
    urlString = [urlString stringByAppendingString:[lon stringValue]];
    urlString = [urlString stringByAppendingString:@"&zoom=13&size=600x600&maptype=roadmap&markers=color:red%7Clabel:S%7C"];
    urlString = [urlString stringByAppendingString:[lat stringValue]];
    urlString = [urlString stringByAppendingString:@","];
    urlString = [urlString stringByAppendingString:[lon stringValue]];
    urlString = [urlString stringByAppendingString:@"&key=AIzaSyDpBmBxxtpSrDyGBKOPR1glbefdgjH_Q7E"];
    NSLog(@"GoogleMap url string : %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil)
         {
            UIImage *image = [[UIImage alloc]initWithData:data];
             GoogleMapViewController *googleMapViewController = [[GoogleMapViewController alloc]initWithNibName:@"GoogleMapViewController" bundle:NULL];
            googleMapViewController.mapImage = image;
            googleMapViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:googleMapViewController animated:YES completion:NULL];
         }
         else if(error != nil)
         {
             NSLog(@"Error happended = %@",error);
         }
     }
     ];

}
 
 /*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }  */
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[self.fetchedResultsController managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self saveContext];
    }
}
-(void)saveContext
{
    NSError *error = nil;
    if(![[self.fetchedResultsController managedObjectContext]save:&error])
    {
        NSLog(@"Unresolved error %@ %@",error, [error userInfo]);
        abort();
    }
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
