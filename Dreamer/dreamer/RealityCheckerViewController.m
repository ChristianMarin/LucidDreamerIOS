//
//  RealityCheckerViewController.m
//  dreamer
//
//  Created by art on 9/3/13.
//  Copyright (c) 2013 Gaurdanis. All rights reserved.
//

#import "RealityCheckerViewController.h"
#import "RealityCheckerCell.h"
#import "RealityChecker.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RealityCheckerViewController ()

@end

@implementation RealityCheckerViewController
@synthesize tableView;
@synthesize topItemBar;
@synthesize topNavBar;
@synthesize notificationFreq;
@synthesize slider;
@synthesize timerArray;
@synthesize bottomLabel;
@synthesize managedObjectContext;
@synthesize timerInterval;
@synthesize switcher;
@synthesize popupView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateArray];
   
    self.view.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
     self.tableView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setTitle];
    self.notificationFreq.textColor = [GlobalStuff mainColor];
   // [self.slider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    //self.timerArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@YES,@YES, nil]];
    
    self.slider.maximumValue = 1.2;
    self.slider.minimumValue = .10;
    float value = ceilf(slider.value * 10);
    
    self.timerInterval = value * 15.0;
    self.bottomLabel.text = [NSString stringWithFormat:@"Reality Checker will notify you once every %00.f minutes", value * 15];
    
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:59.0f/255.0f green:163.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.slider.maximumTrackTintColor = [UIColor grayColor];
    self.switcher.onTintColor = [UIColor colorWithRed:59.0f/255.0f green:163.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.switcher.tintColor = [UIColor grayColor];
    
    /*
    self.popupView.layer.cornerRadius = 12;
    self.popupView.layer.shadowOpacity = 0.7;
    self.popupView.layer.shadowOffset = CGSizeMake(6, 6);
    self.popupView.layer.shouldRasterize = YES;
    self.popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    */
}

- (void)setTitle
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:21.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = @"Reality Checker";
    label.textAlignment = UITextAlignmentCenter;
    self.topItemBar.titleView = label;
    [label sizeToFit];
}

-(void)populateArray{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"RealityChecker" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
  
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *mutableFetchResults = [results mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
    
    
    
	[self setTimerArray:mutableFetchResults];
    [self.tableView reloadData];
    
}

-(IBAction)back:(id)sender
{
    
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)add:(id)sender
{
     RealityChecker *realityChecker = [NSEntityDescription insertNewObjectForEntityForName:@"RealityChecker" inManagedObjectContext:self.managedObjectContext];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit ) fromDate:[NSDate date]];
    //create a date with these components
    [components setHour:9];
    [components setMinute:0]; //reset the other components
    [components setSecond:0]; //reset the other components
     NSDate *startDate = [calendar dateFromComponents:components];
    realityChecker.startTime = startDate;
    [components setHour:20];
    NSDate *endDate = [calendar dateFromComponents:components];
    realityChecker.endTime = endDate;
    NSLog(@"Start: %@",realityChecker.startTime);
    NSLog(@"End: %@",realityChecker.endTime);
    realityChecker.dateCreated = [NSDate date];
    realityChecker.onOffStatus = [NSNumber numberWithInt:1];
    realityChecker.vibrate = [NSNumber numberWithInt:0];
    
    [self populateArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [timerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RealityCheckerCellIdentifier = @"RealityCheckerCellIdentifier";
    
    RealityCheckerCell *cell = (RealityCheckerCell *)[self.tableView dequeueReusableCellWithIdentifier:RealityCheckerCellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[RealityCheckerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RealityCheckerCellIdentifier ];
       cell.backgroundImageView.image =  [UIImage imageNamed:@"journal_item_bg.png"];
        cell.delegate = self;
    }
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RealityCheckerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.realityChecker = [timerArray objectAtIndex:indexPath.row];
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(IBAction)slider:(id)sender{
    float value = ceilf(slider.value * 10.0);
    
        slider.value = value/10;
    self.bottomLabel.text = [NSString stringWithFormat:@"Reality Checker will notify you once every %00.f minutes", value * 15.0];
    self.timerInterval = value * 15.0;
}

-(void)openPopup:(BOOL *)open{
    
    
    ASDepthModalOptions options;
    
    
    
    
    options = ASDepthModalOptionAnimationGrow | ASDepthModalOptionBlur | ASDepthModalOptionTapOutsideToClose;
    
    [ASDepthModalViewController presentView:self.popupView
                            backgroundColor:[UIColor blackColor]
                                    options:options
                          completionHandler:^{
                              NSLog(@"Modal view closed.");
                          }];

    
}

- (IBAction)showModalViewAction:(id)sender
{
    UIColor *color = nil;
    
    ASDepthModalOptions options;
        

    
        
    options = ASDepthModalOptionAnimationGrow | ASDepthModalOptionBlur | ASDepthModalOptionTapOutsideToClose;
    
    [ASDepthModalViewController presentView:self.popupView
                            backgroundColor:color
                                    options:options
                          completionHandler:^{
                              NSLog(@"Modal view closed.");
                          }];
}

- (IBAction)closePopupAction:(id)sender
{
    [ASDepthModalViewController dismiss];
}



@end
