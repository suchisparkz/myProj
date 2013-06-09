//
//  AppDelegate.h
//  MoneyInOut
//
//  Created by Mac on 24/05/13.
//  Copyright (c) 2013 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UITabBarController * tabBarController;

@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistent;

@end
