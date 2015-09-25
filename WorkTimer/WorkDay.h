//
//  WorkDay.h
//  WorkTimer
//
//  Created by Sagar Patkar on 9/19/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WorkDay :NSManagedObject

@property (nonatomic, strong) NSString *workDate;
@property (nonatomic, strong) NSString *inTime;
@property (nonatomic, strong) NSString *outTime;
@property (nonatomic, strong) NSString *hoursSpent;

@end
