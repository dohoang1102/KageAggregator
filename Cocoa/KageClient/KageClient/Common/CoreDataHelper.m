//
//  CoreDataHelper.m
//  KageClient
//
//  Created by Arthur Evstifeev on 02.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

static NSString* scheme = @"KageData";

+ (NSManagedObjectModel *)managedObjectModel {
    static NSManagedObjectModel *managedObjectModel;
    
    @synchronized(self)
    {
        if (!managedObjectModel) {
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:scheme withExtension:@"momd"];
            managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
        }
        
        return managedObjectModel;
    }
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    static NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    @synchronized(self)
    {
        if (!persistentStoreCoordinator) {
            NSURL* applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", scheme]];            
            NSError *error = nil;
            persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
            if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        
        return persistentStoreCoordinator;
    }
}

+ (NSManagedObjectContext *)managedObjectContext {
    static NSManagedObjectContext *managedObjectContext;
    
    @synchronized(self)
    {
        if (!managedObjectContext) {
            NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
            if (coordinator != nil)
            {
                managedObjectContext = [[NSManagedObjectContext alloc] init];
                [managedObjectContext setPersistentStoreCoordinator:coordinator];
            }
        }
        
        return managedObjectContext;
    }
}


@end
