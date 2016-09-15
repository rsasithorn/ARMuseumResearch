//
//  GeolocationTableViewController.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 18/02/2016.
//  Copyright © 2016 Sasithorn Rattanarungrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GoogleMapViewController.h"

@interface GeolocationTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectModel *manageObjectModel;
@property (nonatomic ,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)saveContext;
@end
