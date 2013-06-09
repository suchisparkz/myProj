//
//  FirstViewController.m
//  MoneyInOut
//
//  Created by Mac on 24/05/13.
//  Copyright (c) 2013 Mac. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Expense";
        self.tabBarItem.image = [UIImage imageNamed:@"Kee.png"];
        self.navigationController.navigationBar.topItem.title = @"Expenditure";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
