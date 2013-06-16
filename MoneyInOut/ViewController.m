//
//  ViewController.m
//  MoneyInOut
//
//  Created by Mac on 24/05/13.
//  Copyright (c) 2013 Mac. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@class AppDelegate;

@interface ViewController ()
{
    AppDelegate *app;
    
    NSManagedObjectContext *context;
    
    UILabel *moneyIn;
    UILabel *moneyOut;
    UILabel *totalExpenseAmount;
    UILabel *balancetotal;
    UILabel *balanceAmount;
    UILabel *tapMsg;
    UILabel *totalIncomeAmount;
    
    UIButton *right;
    UIButton *addButton;
    UIButton *chooseType;
    UIButton *left;
        
    UIActionSheet *select;
    
    NSArray *results;
    NSArray *expenseResult;
    
    NSInteger z;
    
    NSDateFormatter *dateFormatter;
    
    NSString *currentState;
    NSString *currentDate;
    NSInteger currentDay1;
    NSInteger currentDay2;
    NSInteger currentMonth;
    NSInteger currentYear;

    
    
}

@end

@implementation ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Account";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundimage.png"]];
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = [app managedObjectContext];
    
    addButton = [[UIButton alloc]initWithFrame:CGRectMake(280, 10, 39, 39)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAccount) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addButton];
    
    left = [[UIButton alloc]initWithFrame:CGRectMake(45, 17, 14, 17)];
    [left setBackgroundImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(minusDates) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:left];
    
    
    right = [[UIButton alloc]initWithFrame:CGRectMake(230, 17, 14, 17)];
    [right setBackgroundImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(addDates) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:right];
    
    z=0;
    
       
    [self checkId];
       
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}



-(void)checkId
{
    NSError *error;
    error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    request.entity = entity;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"id"]];
    request.returnsDistinctResults = NO;
    request.resultType = NSDictionaryResultType;
        
    NSArray *idResults = [context executeFetchRequest:request error:&error];
    NSLog(@"Distinct Result %@",idResults);
    NSLog(@"Distinct Result count %d",[idResults count]);

    
    if ([idResults count]==0)
    {
    
        User *userId = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
        userId.id  = [NSNumber numberWithInt:1];
    
        [[NSUserDefaults standardUserDefaults]setObject:userId.id forKey:@"ID"];
    
        if(![context save:&error])
        {
            NSLog(@"Error");
        }
        
        [self actionSheet:select clickedButtonAtIndex:0];
    }
    else
    {
        [self actionSheet:select clickedButtonAtIndex:0];
    }
}

-(void)showLabels
{
    NSLog(@"Checked");
    
    moneyIn = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 150, 30)];
    moneyIn.text = @"Money In";
    moneyIn.backgroundColor = [UIColor clearColor];
    moneyIn.textColor = [UIColor whiteColor];
    [self.view addSubview:moneyIn];
    
    balanceAmount = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 150, 30)];
    balanceAmount.backgroundColor = [UIColor clearColor];
    balanceAmount.textColor = [UIColor whiteColor];
    balanceAmount.text = @"Money in Hand";
    [self.view addSubview:balanceAmount];
    
}


-(void)typeOfSelection :(NSString *)dayText
{
    NSLog(@"Break7");
    
    
    chooseType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseType.frame = CGRectMake(70, 10, 150, 30);
    [chooseType setTitle:dayText forState:UIControlStateNormal];
    [chooseType addTarget:self action:@selector(actionSheetSelect) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chooseType];
    currentDate = dayText;

}

/************ Action Sheet ************************/
//Selection Action Sheet
-(void)actionSheetSelect
{
    NSLog(@"Break8");
    
    select = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Daily",@"Weekly Income",@"Monthly Income",@"Yearly Income",nil];
	select.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [select showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    NSLog(@"Cancel title %@",currentDate);
    //[self typeOfSelection:currentDate];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSLog(@"Button Index %d",buttonIndex);
       
    NSDate *curentDate =[NSDate date];
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *str= [dateFormatter stringFromDate:curentDate];
    NSLog(@"Current Date1 %@",str);
    

    NSCalendar* calendarzz =[NSCalendar currentCalendar];
    NSDateComponents* compoNents =[calendarzz components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:curentDate];// Get necessary date components
    NSInteger accountDay = [compoNents day];
    NSLog(@"Todayxx %d",accountDay);
    NSInteger accountMonth = [compoNents month];
    NSLog(@"Monthxx %d",accountMonth);
    NSInteger accountYear = [compoNents year];
    NSLog(@"Yearxx %d",accountYear);
    
    
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [myCalendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:curentDate];
    [currentComps setWeekday:2]; // 1: sunday
    NSDate *firstDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    myDateFormatter.dateFormat = @"dd";
    NSString *firstStr = [myDateFormatter stringFromDate:firstDayOfTheWeek];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    monthFormatter.dateFormat = @"MMMM";
    NSString *monthStr = [monthFormatter stringFromDate:firstDayOfTheWeek];
    NSLog(@"Month Val %@",monthStr);

    
    NSLog(@"first - %d ", [firstStr integerValue]);
    NSInteger accountday1 = [firstStr integerValue];
    NSInteger accountday2 = [firstStr integerValue] + 6;
    
    
    if (buttonIndex == 0)
    {
        [self typeOfSelection:str];
        [self getTotalMonth:accountDay :accountMonth :accountMonth :accountYear :z :z :@"Today"];
        NSLog(@"Clicked1");
        
    }
    else if (buttonIndex == 1)
    {
               
        NSLog(@"Clicked2");
        [self weekAddCalculate:accountday1 :accountday2 :accountMonth :accountYear :currentDate];
        
    }
    else if (buttonIndex == 2)
    {
        NSString *monthYear = [NSString stringWithFormat:@"%@, %d",monthStr,accountYear];
        [self typeOfSelection:monthYear];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",accountMonth] forKey:@"Monthly"];
        [self getTotalMonth:accountDay :accountMonth :accountMonth :accountYear :z :z :@"Month"];
        NSLog(@"Clicked3");
        
    }
    else if (buttonIndex == 3)
    {
        [self typeOfSelection:[NSString stringWithFormat:@"%d",accountYear]];

        [self getTotalMonth:accountDay :accountMonth :accountMonth :accountYear :z :z :@"Year"];
        NSLog(@"Clicked4");
        
    }
}

-(void)weekAddCalculate:(NSInteger)number1 :(NSInteger)number2 :(NSInteger)month :(NSInteger)year :(NSString *)stringDate
{
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString: stringDate];
    NSLog(@"String date: %@", stringDate);

    // number of day in month
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSUInteger numberOfDaysInMonth = rng.length;
    NSLog(@"Range %d",numberOfDaysInMonth);
    
    NSLog(@"Number 2 %d",number2);


     NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    NSInteger c,b;
    
    NSLog(@"Month Index %@",[months objectAtIndex:month-1]);

    
    if (numberOfDaysInMonth == 31)
    {
        if (number2 > 31)
        {
            NSInteger a = number2 - 31;
            b = month +1;
            if (month == 12)
            {
                c = year +1;
                NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,a,[months objectAtIndex:0],c];
                [self typeOfSelection:weekStr];

            }
            else
            {
                c = year;
                NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,a,[months objectAtIndex:month],c];
                [self typeOfSelection:weekStr];

            }
           
            NSLog(@"B Integer %d",b);
            [self getTotalMonth:number1 :month :b :c :number1 :a :@"Week"];
        }
        else
        {
            NSLog(@"Entered Year %d",year);
            [self getTotalMonth:number1 :month :month :year :number1 :number2 :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,number2,[months objectAtIndex:month-1],year];
            [self typeOfSelection:weekStr];
        }
    }
    else if(numberOfDaysInMonth == 30)
    {
        if (number2 > 30)
        {
            NSInteger a = number2 - 30;
            NSInteger b = month +1;
            [self getTotalMonth:number1 :month :b :year :number1 :a :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,a,[months objectAtIndex:month],year];
            [self typeOfSelection:weekStr];

        }
        else
        {
            [self getTotalMonth:number1 :month :month :year :number1 :number2 :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,number2,[months objectAtIndex:month-1],year];
            [self typeOfSelection:weekStr];
        }
        
    }
    else if(numberOfDaysInMonth == 29)
    {
        if (number2 > 29)
        {
            NSInteger a = number2 - 29;
            NSInteger b = month +1;
            [self getTotalMonth:number1 :month :b :year :number1 :a :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,a,[months objectAtIndex:month],year];
            [self typeOfSelection:weekStr];

        }
        else
        {
            [self getTotalMonth:number1 :month :month :year :number1 :number2 :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,number2,[months objectAtIndex:month-1],year];
            [self typeOfSelection:weekStr];
        }
    }
    else if(numberOfDaysInMonth == 28)
    {
        if (number2 > 28)
        {
            NSInteger a = number2 - 28;
            NSInteger b = month +1;
            [self getTotalMonth:number1 :month :b :year :number1 :a :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,a,[months objectAtIndex:month],year];
            [self typeOfSelection:weekStr];

        }
        else
        {
            [self getTotalMonth:number1 :month :month :year :number1 :number2 :@"Week"];
            NSString *weekStr =[NSString stringWithFormat:@"%d - %d, %@ %d",number1,number2,[months objectAtIndex:month-1],year];
            [self typeOfSelection:weekStr];
        }
    }
}



- (void)getTotalMonth: (NSInteger )dateTotal :(NSInteger )month1 :(NSInteger)month2 :(NSInteger )yearTotal :(NSInteger)monday :(NSInteger)sunday :(NSString *)getDate
{
    
    [moneyIn removeFromSuperview];
    [moneyOut removeFromSuperview];
    [balancetotal removeFromSuperview];
    [balanceAmount removeFromSuperview];
    [totalExpenseAmount removeFromSuperview];
    [totalIncomeAmount removeFromSuperview];
    [tapMsg removeFromSuperview];
    
    NSLog(@"Break507");
    
    
    NSError *error = nil;
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:@"Income" inManagedObjectContext:context]];
    NSLog(@"Break508");
    
    NSFetchRequest *expenseReq = [[NSFetchRequest alloc] init];
    [expenseReq setEntity:[NSEntityDescription entityForName:@"Expense" inManagedObjectContext:context]];
    
    
    
    if ([getDate isEqualToString:@"Today"])
    {
        NSLog(@"Break14");
        
        currentState = @"Today";
        
        NSLog(@"Today");
        NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"(id == %@ && day == %@ && month == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",dateTotal],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [req setPredicate:sumPredicate];
        
        results = [context executeFetchRequest:req error:&error];
        
        NSPredicate *expensePredicate = [NSPredicate predicateWithFormat:@"(id == %@ && day == %@ && month == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",dateTotal],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [expenseReq setPredicate:expensePredicate];
        
        expenseResult = [context executeFetchRequest:expenseReq error:&error];
        
        NSLog(@"Array Count1 %d %d",[results count],[expenseResult count]);
        
    }
    else if([getDate isEqualToString:@"Month"])
    {
        NSLog(@"Monthly");
        
        currentState = @"Month";
        
        NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"(id == %@ && month == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [req setPredicate:sumPredicate];
        
        results = [context executeFetchRequest:req error:&error];
        
        NSPredicate *expensePredicate = [NSPredicate predicateWithFormat:@"(id == %@ && month == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [expenseReq setPredicate:expensePredicate];
        
        expenseResult = [context executeFetchRequest:expenseReq error:&error];
        
        NSLog(@"Array Count2 %d %d",[results count],[expenseResult count]);
        
        
    }
    else if([getDate isEqualToString:@"Year"])
    {
        NSLog(@"Break16");
        
        currentState = @"Year";
        
        NSLog(@"Yearly");
        NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"(id == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [req setPredicate:sumPredicate];
        
        results = [context executeFetchRequest:req error:&error];
        
        
        NSPredicate *expensePredicate = [NSPredicate predicateWithFormat:@"(id == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [expenseReq setPredicate:expensePredicate];
        
        expenseResult = [context executeFetchRequest:expenseReq error:&error];
        
        NSLog(@"Array Count3 %d %d",[results count],[expenseResult count]);
        
        
    }
    else if([getDate isEqualToString:@"Week"])
    {
        
        currentState = @"Week";

        NSLog(@"Break17");
        
        NSLog(@"Weekly");
        NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"(id == %@ && (day >= %@ && day<= %@) && (month >= %@ && month <= %@) && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",monday],[NSString stringWithFormat:@"%d",sunday],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",month2],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [req setPredicate:sumPredicate];
        
        results = [context executeFetchRequest:req error:&error];
        
        NSPredicate *expensePredicate = [NSPredicate predicateWithFormat:@"(id == %@ && (day >= %@ && day<= %@) && month == %@ && year == %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"],[NSString stringWithFormat:@"%d",monday],[NSString stringWithFormat:@"%d",sunday],[NSString stringWithFormat:@"%d",month1],[NSString stringWithFormat:@"%d",yearTotal]];
        
        [expenseReq setPredicate:expensePredicate];
        
        expenseResult = [context executeFetchRequest:expenseReq error:&error];
        
        NSLog(@"Array Count4 %d %d",[results count],[expenseResult count]);
        
    }
    
    if ([results count]==0)
    {
        NSLog(@"Break18");
        
        tapMsg = [[UILabel alloc]initWithFrame:CGRectMake(80, 169, 200, 30)];
        tapMsg.text = @"Click (+) To Add Accounts";
        tapMsg.backgroundColor = [UIColor clearColor];
        tapMsg.textColor = [UIColor grayColor];
        [self.view addSubview:tapMsg];
        
    }
    else if(([results count]!=0) && ([expenseResult count]==0))
    {
        NSLog(@"Break19");
        
//        tapMsg.text = @"";
//        [self showLabels];
//        
//        NSArray *fetchedObjects = [context executeFetchRequest:req error:&error];
//        
//        NSDecimalNumber *total = [fetchedObjects valueForKeyPath:@"@sum.amount"];
//        
//        totalAmountIn  = [total stringValue];
//        
//        balanceTotalAmount = [total stringValue];
//        
//        [self totalAmountIncome:totalAmountIn:balanceTotalAmount];
//        
//        addExpense = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        addExpense.frame = CGRectMake(100, 250, 150, 30);
//        [addExpense setTitle:@"Add Expense" forState:UIControlStateNormal];
//        [addExpense addTarget:self action:@selector(addExpenditure) forControlEvents:UIControlEventTouchDown];
  //      [self.view addSubview:addExpense];
        
    }
    else
    {
        NSLog(@"Break20");
        
//        tapMsg.text = @"";
//        [self showLabels];
//        
//        NSArray *fetchedObjects = [context executeFetchRequest:req error:&error];
//        
//        NSDecimalNumber *total = [fetchedObjects valueForKeyPath:@"@sum.amount"];
//        
//        totalAmountIn  = [total stringValue];
//        
//        NSLog(@"Break21");
//        
//        moneyOut = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 150, 30)];
//        moneyOut.text = @"Money Out";
//        moneyOut.backgroundColor = [UIColor clearColor];
//        moneyOut.textColor = [UIColor whiteColor];
//        [self.view addSubview:moneyOut];
//        
//        
//        NSArray *fetchExpense = [context executeFetchRequest:expenseReq error:&error];
//        
//        NSDecimalNumber *totalExpense = [fetchExpense valueForKeyPath:@"@sum.amount"];
//        
//        NSLog(@"Break22");
//        
//        totalExpenseAmount = [[UILabel alloc]initWithFrame:CGRectMake(80, 120, 150, 30)];
//        totalExpenseAmount.backgroundColor = [UIColor clearColor];
//        totalExpenseAmount.textAlignment = NSTextAlignmentRight;
//        totalExpenseAmount.text = [totalExpense stringValue];
//        [self.view addSubview:totalExpenseAmount];
//        
//        
//        NSDecimalNumber *bal = [total decimalNumberBySubtracting:totalExpense];
//        balanceTotalAmount = [bal stringValue];
//        [self totalAmountIncome:totalAmountIn:balanceTotalAmount];
//        
//        NSLog(@"Break23");
//        
//        addExpense = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        addExpense.frame = CGRectMake(100, 250, 150, 30);
//        [addExpense setTitle:@"Check your Expense" forState:UIControlStateNormal];
//        [addExpense addTarget:self action:@selector(addExpenditure) forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:addExpense];
        
        
    }
    
}

/************ Add Dates ************************/
-(void)addDates
{
       NSLog(@"Current StateYEAR %@",currentState);
    
    NSLog(@"Comiited");
    
     NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    if([currentState isEqualToString: @"Today"])
    {
        [chooseType removeFromSuperview];

        NSDate *datezz = [[NSDate alloc] init];
        datezz = [dateFormatter dateFromString: currentDate];
        NSLog(@"String dateCal: %@", currentDate);
        NSDate *tomorrow = [NSDate dateWithTimeInterval:(60*60*24*1) sinceDate:datezz];
        
        dateFormatter = [[NSDateFormatter alloc] init];
    
        // Set the required date format
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        // Get the string date
        NSString* strzz = [dateFormatter stringFromDate:tomorrow];
        NSLog(@"Tomorrow %@",strzz);
        
        [self typeOfSelection:strzz];
        
        NSDate *dates = [[NSDate alloc] init];
        dates = [dateFormatter dateFromString: strzz];
        
        NSCalendar* calendarzz =[NSCalendar currentCalendar];
        NSDateComponents* compoNents =[calendarzz components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dates];// Get necessary date components
        NSInteger accountDay = [compoNents day];
        NSLog(@"Todayxx %d",accountDay);
        NSInteger accountMonth = [compoNents month];
        NSLog(@"Monthxx %d",accountMonth);
        NSInteger accountYear = [compoNents year];
        NSLog(@"Yearxx %d",accountYear);
                
        [self getTotalMonth:accountDay :accountMonth :z :accountYear :z :z :@"Today"];
    }
    else if([currentState isEqualToString:@"Month"])
    {
        
       
        
        NSArray *monthAndYear = [currentDate componentsSeparatedByString:@", "];
        NSLog(@"Array %@",monthAndYear);
        NSLog(@"Array1 %@",[monthAndYear objectAtIndex:0]);
        NSLog(@"Array2 %@",[monthAndYear objectAtIndex:1]);
        NSInteger yearly = [[monthAndYear objectAtIndex:1]intValue];
        
        NSUInteger indexOfTheObject = [months indexOfObject:[monthAndYear objectAtIndex:0]];
        NSLog(@"Index %d",indexOfTheObject);
        
        
        if (indexOfTheObject == 11)
        {
            NSLog(@"Month Object %@",[months objectAtIndex:0]);
            NSString *mmonthyy = [NSString stringWithFormat:@"%@, %d",[months objectAtIndex:0],yearly+1];
            [self typeOfSelection:mmonthyy];
            [self getTotalMonth:z :z :1 :yearly :z :z :@"Month"];
            
        }
        else
        {
            NSLog(@"Month Object %@",[months objectAtIndex:indexOfTheObject+1]);
             NSString *mmonthyy = [NSString stringWithFormat:@"%@, %d",[months objectAtIndex:indexOfTheObject+1],yearly];
            [self typeOfSelection:mmonthyy];
            [self getTotalMonth:z :z :(indexOfTheObject +1) :yearly :z :z :@"Month"];

        }
        
    }
    else if([currentState isEqualToString:@"Year"])
    {
        
        NSInteger d8 = [currentDate intValue]+1;
        
        NSLog(@"Current Yearllll %d",d8);
        
        [self typeOfSelection:[NSString stringWithFormat:@"%d",d8]];

        
        [self getTotalMonth:z :z :z :d8 :z :z :@"Year"];
        
    }
    else if([currentState isEqualToString:@"Week"])
    {
        
        NSLog(@"Current Week %@",currentDate);
        
        NSArray *week1 = [currentDate componentsSeparatedByString:@" - "];
        NSArray *week2 = [[week1 objectAtIndex:1] componentsSeparatedByString:@", "];
        NSArray *week3 = [[week2 objectAtIndex:1] componentsSeparatedByString:@" "];

        NSLog(@"Current mnthyear %d %@ %@ %@",[[week1 objectAtIndex:0]intValue],[week2 objectAtIndex:0],[week3 objectAtIndex:0],[week3 objectAtIndex:1]);
        NSInteger d0 = [[week2 objectAtIndex:0]intValue]+6;
        NSInteger d1 = [[week2 objectAtIndex:0]intValue]+1;
        NSInteger d2 = d1 + 6;
        NSInteger d3 = [months indexOfObject:[week3 objectAtIndex:0]];
        NSLog(@"Month Integer Index %d",d3);
        NSInteger d4 = [[week3 objectAtIndex:1]intValue];
    
        if (d0>30)
        {
            if(d3 ==11)
            {
                NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:11],[[week1 objectAtIndex:0]intValue],d4];
                NSLog(@"WeekDay String333 %@",weekDayString);
                
                [self weekAddCalculate:d1 :d2 :12 :d4 :weekDayString];
            }
            else
            {
                NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:d3+1],[[week1 objectAtIndex:0]intValue],d4];
                NSLog(@"WeekDay String111 %@",weekDayString);
                
                [self weekAddCalculate:d1 :d2 :d3+1 :d4 :weekDayString];
            }
        }
        else
        {
            NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:d3],[[week1 objectAtIndex:0]intValue],d4];
            NSLog(@"WeekDay String222 %@",weekDayString);
            
            [self weekAddCalculate:d1 :d2 :d3+1 :d4 :weekDayString];

        }
    }
}

-(void)minusDates
{
    NSLog(@"Current State %@",currentState);
    
    NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    if([currentState isEqualToString: @"Today"])
    {

        NSLog(@"YesterDay");
        NSDate *datezz = [[NSDate alloc] init];
        datezz = [dateFormatter dateFromString: currentDate];
        NSLog(@"String dateCal: %@", currentDate);
        NSDate *yesterday = [NSDate dateWithTimeInterval: -(60.0f*60.0f*24.0f) sinceDate:datezz];
        

        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        // Set the required date format
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        // Get the string date
        NSString* strzz = [dateFormatter stringFromDate:yesterday];
        NSLog(@"Yesterday %@",strzz);
        
        [self typeOfSelection:strzz];
        
        NSDate *dates = [[NSDate alloc] init];
        dates = [dateFormatter dateFromString: strzz];
        
        NSCalendar* calendarzz =[NSCalendar currentCalendar];
        NSDateComponents* compoNents =[calendarzz components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dates];// Get necessary date components
        NSInteger accountDay = [compoNents day];
        NSLog(@"Todayxx %d",accountDay);
        NSInteger accountMonth = [compoNents month];
        NSLog(@"Monthxx %d",accountMonth);
        NSInteger accountYear = [compoNents year];
        NSLog(@"Yearxx %d",accountYear);
        
        [self getTotalMonth:accountDay :accountMonth :z :accountYear :z :z :@"Today"];
    }
    else if([currentState isEqualToString:@"Month"])
    {
        
        NSLog(@"last Month");
        
        NSLog(@"Current Date Previous %@",currentDate);
        
        NSArray *monthAndYear = [currentDate componentsSeparatedByString:@", "];
        NSLog(@"Array %@",monthAndYear);
        NSLog(@"Array11 %@",[monthAndYear objectAtIndex:0]);
        NSLog(@"Array22 %@",[monthAndYear objectAtIndex:1]);
        NSInteger yearly = [[monthAndYear objectAtIndex:1]intValue];
        
        NSInteger indexOfTheObject = [months indexOfObject:[monthAndYear objectAtIndex:0]];
        NSLog(@"Indexzz %d",indexOfTheObject);
        
        if (indexOfTheObject == 0)
        {
            NSLog(@"Month Object111 %@",[months objectAtIndex:11]);
            NSString *mmonthyy = [NSString stringWithFormat:@"%@, %d",[months objectAtIndex:11],yearly-1];
            [self typeOfSelection:mmonthyy];
            [self getTotalMonth:z :z :1 :yearly :z :z :@"Month"];
            
        }
        else
        {
            NSLog(@"Check out");
            
            NSLog(@"Month Object222 %@",[months objectAtIndex:indexOfTheObject-1]);
            NSString *mmonthyy = [NSString stringWithFormat:@"%@, %d",[months objectAtIndex:indexOfTheObject-1],yearly];
            [self typeOfSelection:mmonthyy];
            [self getTotalMonth:z :z :(indexOfTheObject +1) :yearly :z :z :@"Month"];
            
        }
        
    }
    else if([currentState isEqualToString:@"Year"])
    {
        NSLog(@"Last year");
        NSInteger d8 = [currentDate intValue]-1;
        
        [self typeOfSelection:[NSString stringWithFormat:@"%d",d8]];
        [self getTotalMonth:z :z :z :d8 :z :z :@"Year"];
        
    }
    else if([currentState isEqualToString:@"Week"])
    {
        
        
        
        NSLog(@"Last Week");

       
        
        NSLog(@"Yester Week %@",currentDate);
        
        NSArray *week1 = [currentDate componentsSeparatedByString:@" - "];
        NSArray *week2 = [[week1 objectAtIndex:1] componentsSeparatedByString:@", "];
        NSArray *week3 = [[week2 objectAtIndex:1] componentsSeparatedByString:@" "];
    
        // number of day in month
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setMonth:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
        NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:[cal dateFromComponents:comps]];
        NSInteger rng = range.length;
        
        NSLog(@"Ranges Month %d",rng);
        
        
        NSInteger d0 = [[week1 objectAtIndex:0]intValue]-7;
        NSLog(@"D0 %d",d0);
        NSInteger d1 = [[week2 objectAtIndex:0]intValue]+1;
        NSLog(@"D1 %d",d1);
        NSInteger d2 = d1 + 6;
        NSLog(@"D2 %d",d2);
        NSInteger d3 = [months indexOfObject:[week3 objectAtIndex:0]];
        NSLog(@"Month Integer Index %d",d3);
        NSInteger d4 = [[week3 objectAtIndex:1]intValue];
        NSLog(@"D4 %d",d4);
        
         NSLog(@"Yester mnthyear %d %@ %@ %@",[[week1 objectAtIndex:0]intValue],[week2 objectAtIndex:0],[week3 objectAtIndex:0],[week3 objectAtIndex:1]);
        
        if (d0<0)
        {
            if(d3 ==11)
            {
                NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:11],[[week1 objectAtIndex:0]intValue],d4];
                NSLog(@"WeekDay String333 %@",weekDayString);
                
                [self weekAddCalculate:d1 :d2 :12 :d4 :weekDayString];
            }
            else
            {
                NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:d3+1],[[week1 objectAtIndex:0]intValue],d4];
                NSLog(@"WeekDay String111 %@",weekDayString);
                
                [self weekAddCalculate:d1 :d2 :d3+1 :d4 :weekDayString];
            }
        }
        else
        {
            NSString *weekDayString = [NSString stringWithFormat:@"%@ %d, %d",[months objectAtIndex:d3],[[week1 objectAtIndex:0]intValue],d4];
            NSLog(@"WeekDay String222 %@",weekDayString);
            
            [self weekAddCalculate:d1 :d2 :d3+1 :d4 :weekDayString];
            
        }
    }
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
