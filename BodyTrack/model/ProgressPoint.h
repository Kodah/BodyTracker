//
//  ProgressPoint.h
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProgressCollection;

@interface ProgressPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * bodyFat;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * measurement;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) ProgressCollection *progressCollection;

@end
