//
//  CoreDataContext.h
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 23/02/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataContext : NSObject <NSFetchedResultsControllerDelegate>
{
    //NSManagedObject *newManageObject;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, strong) NSManagedObject *newManageObject;
-(NSManagedObject *)insertCosName:(NSString *)cosName preferenceName:(NSString *)name;
-(void)saveContext;
@end
