//
//  Income.h
//  MoneyInOut
//
//  Created by Mac on 24/05/13.
//  Copyright (c) 2013 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Income : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * category;

@end
