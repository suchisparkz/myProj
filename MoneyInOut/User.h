//
//  User.h
//  MoneyInOut
//
//  Created by Mac on 24/05/13.
//  Copyright (c) 2013 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * emailid;

@end
