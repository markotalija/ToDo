//
//  Task+CoreDataProperties.h
//  ToDo
//
//  Created by Cubes School 6 on 5/16/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *group;
@property (nullable, nonatomic, retain) NSString *heading;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *latitude;

@end

NS_ASSUME_NONNULL_END
