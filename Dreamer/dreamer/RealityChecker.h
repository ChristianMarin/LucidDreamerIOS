//
//  RealityChecker.h
//  dreamer
//
//  Created by art on 9/6/13.
//  Copyright (c) 2013 Gaurdanis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RealityChecker : NSManagedObject{
    
    
    
}

@property (nonatomic) NSNumber *audio;
@property (nonatomic) NSNumber *interval;
@property (nonatomic) NSNumber *onOffStatus;
@property (nonatomic) NSNumber *vibrate;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;



@end
