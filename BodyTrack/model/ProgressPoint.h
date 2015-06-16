//
//  ProgressPoint.h
//  BodyTrack
//
//  Created by Tom Sugarex on 16/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProgressPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * bodyFat;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * measurement;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSManagedObject *progressCollection;

@end
