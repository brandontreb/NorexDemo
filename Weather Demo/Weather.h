//
//  Weather.h
//  Weather Demo
//
//  Created by Brandon Trebitowski on 1/21/15.
//  Copyright (c) 2015 Pixegon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSNumber * dt;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * icon;

@end
