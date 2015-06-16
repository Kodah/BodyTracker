//
//  ProgressCollection.h
//  BodyTrack
//
//  Created by Tom Sugarex on 16/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProgressPoint;

@interface ProgressCollection : NSManagedObject

@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *progressPoints;
@end

@interface ProgressCollection (CoreDataGeneratedAccessors)

- (void)addProgressPointsObject:(ProgressPoint *)value;
- (void)removeProgressPointsObject:(ProgressPoint *)value;
- (void)addProgressPoints:(NSSet *)values;
- (void)removeProgressPoints:(NSSet *)values;

@end
