//
//  StatisticsViewController.m
//  LucidDreamer
//


#import "StatisticsViewController.h"
#import "StatsCell.h"
#import "JournalEntry.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController
@synthesize topItemBar;
@synthesize topNavBar;
@synthesize tableView;
@synthesize journalArray;
@synthesize managedObjectContext;
@synthesize lucidDreams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lucidDreams = 0;
    [self sort];
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setTitle];
    
    self.view.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
}


- (void)setTitle
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = @"Statistics";
    label.textAlignment = UITextAlignmentCenter;
    self.topItemBar.titleView = label;
    [label sizeToFit];
}

-(IBAction)back:(id)sender
{
    
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)sort {
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
        
    self.journalArray = results;
    if([journalArray count] != 0){
    for (int i = 0; i < [self.journalArray count]; i++) {
      JournalEntry *item = (JournalEntry *)[journalArray objectAtIndex:i];
        if ([item.lucid  isEqualToNumber: [NSNumber numberWithInt:1]]) {
            self.lucidDreams = self.lucidDreams + 1;
        }
    }
    }
    
    
    
    
	}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *JournalCellIdentifier = @"JournalCellIdentifier";
    
    StatsCell *cell = (StatsCell *)[self.tableView dequeueReusableCellWithIdentifier:JournalCellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[StatsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JournalCellIdentifier ];
       cell.imageView.image = [UIImage imageNamed:@"Stats.png"];
        
    }
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(StatsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
          // self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
    cell.titleLabel.text = [NSString stringWithFormat:@"%000.f Lucid Dreams", self.lucidDreams];
    cell.imageView.image = [UIImage imageNamed:@"Stats.png"];
    cell.cellHeight = 125;
    cell.calendar.image = [UIImage imageNamed:@"stats_calendar.png"];
        if([journalArray count] != 0){
    JournalEntry *item = (JournalEntry *)[journalArray objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.dateLabel.text = [dateFormatter stringFromDate:[item date]];
     cell.subTitleLabel.text = [NSString stringWithFormat:@"%000.f%% of your dreams are lucid", self.lucidDreams/[journalArray count] * 100];
    [cell.openDate  addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            
           cell.dateLabel.text = @"None";
             cell.subTitleLabel.text = [NSString stringWithFormat:@"%i%% of your dreams are lucid", 0];
        }
    }
    else
        cell.cellHeight = 0;
    
}

-(void)open:(id)sender{
    JournalEntry *item = (JournalEntry *)[journalArray objectAtIndex:0];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:item.title 
                                                      message:item.notes
                                                     delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
    [message show];


}


-(CGFloat)tableView:(UITableView *)tableVieww heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     StatsCell *currentCell = (StatsCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    
    if (currentCell.cellHeight == 0) {
        return 44;
    }
    
    return currentCell.cellHeight;
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
