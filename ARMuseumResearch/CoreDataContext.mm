//
//  CoreDataContext.m
//  ARMuseumResearch
//
//  Created by Sasithorn Rattanarungrot on 23/02/2015.
//  Copyright (c) 2015 Sasithorn Rattanarungrot. All rights reserved.
//

#import "CoreDataContext.h"

@implementation CoreDataContext

@synthesize managedObjectContext;
@synthesize fetchedResultsController;
//@synthesize newManageObject;

-(NSManagedObject*)insertCosName:(NSString *)cosName preferenceName:(NSString *)userPreferenceName
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cosname" inManagedObjectContext:managedObjectContext];
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest]entity];
    NSManagedObject* newManageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Cosname" inManagedObjectContext:context];
    [newManageObject setValue:cosName forKey:@"cosname"];
    [newManageObject setValue:userPreferenceName forKey:@"preferencename"];
    [self saveContext];
    return newManageObject;
}
-(void)saveContext
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error = nil;
    if(![context save:&error])
    {
        abort();
        NSLog(@"Unsolved error %@ %@",error,[error userInfo]);
    }
    
}

@end
