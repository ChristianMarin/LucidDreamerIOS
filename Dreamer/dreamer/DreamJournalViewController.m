
//
//  DreamJournalViewController.m
//  LucidDreamer
//


#import "DreamJournalViewController.h"
#import "JournalEntry.h"
#import "JournalCell.h"

@interface MenuItem : UIMenuItem
@property (nonatomic) NSIndexPath* indexPath;
@end

@implementation MenuItem
@end


@interface DreamJournalViewController ()

@end

@implementation DreamJournalViewController
@synthesize managedObjectContext;
@synthesize topNavBar;
@synthesize bottomNavBar;
@synthesize tableView;
@synthesize journalArray;
@synthesize storedEntrysArray;
@synthesize sortedMonthArray;
@synthesize currentDate;
@synthesize monthsArray;
@synthesize addEntry;
@synthesize addViewController;
@synthesize topItemBar;



-(void)viewWillAppear:(BOOL)animated
{
        
    [self reloadTable];
}

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
   
    extendedCellArray = [[NSMutableArray alloc] init];
    [self reloadTable];
    //[self setTitle: topNavBar title:@"Journal"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.monthsArray = [df shortMonthSymbols];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:currentDate];
    
    [self setTitle: bottomNavBar title:[NSString stringWithFormat:@"%@ %d", [monthsArray objectAtIndex:[components month] - 1], [components year]]];
    
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([self.botNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.botNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.topNavBar setTitleTextAttributes:@{
                  UITextAttributeTextColor: [GlobalStuff mainColor],
            UITextAttributeTextShadowColor: [UIColor clearColor],
           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                       UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:21.0f]
     }];
    
    self.view.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    
    
    
     NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIButton *change_view = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    change_view.frame = CGRectMake(0,0,44,44);
    [change_view setTitle:@"List" forState:UIControlStateNormal];
    [change_view addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView: change_view];
    [barItems addObject:button];
     
    UIButton *change_view2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    change_view.frame = CGRectMake(0,0,44,44);
    [change_view setTitle:@"List" forState:UIControlStateNormal];
    [change_view addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView: change_view2];
    
    [barItems addObject:button2];
    
     self.topItemBar.rightBarButtonItems = barItems;
     
       
}


-(void)reloadTable
{
    
    self.currentDate = [NSDate date];
    [self sortByMonth:[NSDate date]];
    [self.tableView reloadData];
}

-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)setTitle:(UINavigationItem *)navItem title:(NSString *)string
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:21.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = string;
    label.textAlignment = UITextAlignmentCenter;
    navItem.titleView = label;
    [label sizeToFit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
   
    self.journalArray = nil;
    self.storedEntrysArray = nil;
    
    [extendedCellArray setArray:nil];
}

-(IBAction)addJournalEntry:(id)sender
{
    
    AddJournalEntryViewController *addController = [[AddJournalEntryViewController alloc] initWithNibName:@"AddJournalEntryViewController" bundle:nil];
    
    addController.managedObjectContext = self.managedObjectContext;
   // addController.delegate = self;
    [self reloadTable];
    [self presentModalViewController:addController animated:YES];
    
    
}

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize labelSize = [[journalArray objectAtIndex:index] sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return  [journalArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *JournalCellIdentifier = @"JournalCellIdentifier";
    
    JournalCell *cell = (JournalCell *)[self.tableView dequeueReusableCellWithIdentifier:JournalCellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[JournalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JournalCellIdentifier ];
        //cell.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        cell.longPressRecognizer = longPressRecognizer;
        cell.dateLabel.textAlignment = UITextAlignmentCenter;
        
    }
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(JournalCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    JournalEntry *item = (JournalEntry *)[journalArray objectAtIndex:indexPath.row];
         
   
    if(indexPath.row == 0){
        cell.entry = item;
            cell.extendableCell = NO;
     
        
    }
        else
            
        {
            
            if([[extendedCellArray objectAtIndex:indexPath.row] isEqualToNumber: [NSNumber numberWithInt:-1]])
            {
                cell.extendableCell = YES;
               // NSNumber *temp = [extendedCellArray objectAtIndex:indexPath.row - 1];
                JournalEntry *item2 = (JournalEntry *)[journalArray objectAtIndex:indexPath.row - 1];
                cell.entry = item2;
                cell.bodyLabel.text = item2.notes;
                cell.entry = item;
                cell.bodyLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            else{
                cell.entry = item;
                cell.extendableCell = NO;
                 
            }
        }
    if([extendedCellArray objectAtIndex:indexPath.row] == Nil)
        cell.frame = CGRectMake(0, 0, 0, 0);

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
   
    JournalEntry *currentEntry = (JournalEntry *)[journalArray objectAtIndex:indexPath.row];
  
   
    
  

    if ([extendedCellArray objectAtIndex:indexPath.row] > 0 && ![[extendedCellArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
        
    
    
    if (![[extendedCellArray objectAtIndex:indexPath.row + 1] isEqualToNumber:[NSNumber numberWithInt:-1]] || [[extendedCellArray objectAtIndex:indexPath.row + 1] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        //[self.tableView beginUpdates];
        [journalArray insertObject:currentEntry atIndex:indexPath.row + 1];
        [extendedCellArray insertObject:[NSNumber numberWithInt:-1] atIndex:indexPath.row + 1];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        //[self.tableView endUpdates];
    }
    
    else {
        //[self.tableView beginUpdates];
        [extendedCellArray removeObjectAtIndex:indexPath.row + 1];
        [journalArray removeObjectAtIndex:indexPath.row + 1];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
       // [self.tableView endUpdates];
    }
    
        
   
    }
    
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // JournalCell *currentCell = (JournalCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    JournalEntry *currentEntry = [journalArray objectAtIndex:indexPath.row];
    //JournalEntry *item2 = (JournalEntry *)[storedEntrysArray objectAtIndex:indexPath.row - 1];
    
    if (![[extendedCellArray objectAtIndex:indexPath.row] isEqualToNumber: [NSNumber numberWithInt:-1]] ) {
        CGFloat cellHeight;
        CGSize constraintSize = CGSizeMake(98.0f, MAXFLOAT);
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
        CGSize labelSize = [currentEntry.title sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
       
        if (labelSize.height < 60.0) {
            cellHeight = 60.0;
        }
        else{
            cellHeight = labelSize.height;
        }
        
        return cellHeight ;
    }
    
    if ([[extendedCellArray objectAtIndex:indexPath.row] isEqualToNumber: [NSNumber numberWithInt:-1]] ) {
        
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
        CGSize labelSize = [currentEntry.notes sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 20;
        }
        
   return 0.0;
    
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
    
    /*
     For the long press, the only state of interest is Began.
     When the long press is detected, find the index path of the row (if there is one) at press location.
     If there is a row at the location, create a suitable menu controller and display it.
     */
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:[longPressRecognizer locationInView:self.tableView]];
        
        if (pressedIndexPath && (pressedIndexPath.row != NSNotFound) && (pressedIndexPath.section != NSNotFound) && ![[extendedCellArray objectAtIndex:pressedIndexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
            
            [self becomeFirstResponder];
            MenuItem *editItem = [[MenuItem alloc] initWithTitle:@"Edit" action:@selector(editButton:)];
            editItem.indexPath = pressedIndexPath;
            
            MenuItem *deleteItem = [[MenuItem alloc] initWithTitle: @"Delete" action:@selector(deleteButton:)];
            deleteItem.indexPath = pressedIndexPath;
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            menuController.menuItems = [NSArray arrayWithObjects:deleteItem, editItem, nil];
            [menuController setTargetRect:[self.tableView rectForRowAtIndexPath:pressedIndexPath] inView:self.tableView];
            [menuController setMenuVisible:YES animated:YES];
           
        }
    }
}

-(void)editButton:(UIMenuController*)menuController {
    
    AddJournalEntryViewController *addController = [[AddJournalEntryViewController alloc] initWithNibName:@"AddJournalEntryViewController" bundle:nil];
    MenuItem *editItem = [[UIMenuController sharedMenuController] menuItems][0];
	addController.managedObjectContext = managedObjectContext;
	addController.entry = [journalArray objectAtIndex:editItem.indexPath.row];
    
    addController.edit = YES;
    
    [self presentModalViewController:addController animated:YES];
    
    [self reloadTable];
    
}

-(void)deleteButton:(UIMenuController*)menuController {
    
    MenuItem *deleteItem = [[UIMenuController sharedMenuController] menuItems][1];
   
    [self.managedObjectContext deleteObject:[journalArray objectAtIndex:deleteItem.indexPath.row]];
    NSIndexPath *tempIndex = [NSIndexPath indexPathForRow:deleteItem.indexPath.row inSection:0];
    NSIndexPath *tempIndex2 = [NSIndexPath indexPathForRow:deleteItem.indexPath.row + 1 inSection:0];
    
    if([[extendedCellArray objectAtIndex:deleteItem.indexPath.row + 1] isEqualToNumber:[NSNumber numberWithInt:-1]]){
    [extendedCellArray removeObjectAtIndex:deleteItem.indexPath.row + 1];
    [extendedCellArray removeObjectAtIndex:deleteItem.indexPath.row];    
    [journalArray removeObjectAtIndex:deleteItem.indexPath.row + 1];
    [journalArray removeObjectAtIndex:deleteItem.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:tempIndex,tempIndex2,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        [journalArray removeObjectAtIndex:deleteItem.indexPath.row];
        [extendedCellArray removeObjectAtIndex:deleteItem.indexPath.row]; 
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:tempIndex] withRowAnimation:UITableViewRowAnimationNone];
        [self reloadTable];
    }
    
       
}

-(void)sortByMonth:(NSDate *)date {
  
        
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:date];
    //create a date with these components
    NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:1];
    [components setDay:0]; //reset the other components
    [components setYear:0]; //reset the other components
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date < %@)) || (date = nil)",startDate,endDate];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
       
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *mutableFetchResults = [results mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
    
    
    
	[self setJournalArray:mutableFetchResults];
    
   
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [journalArray count] ; i++) {
        [fillArray addObject:[NSNumber numberWithInt:i]];
    }
    [fillArray addObject:[NSNumber numberWithInt:0]];
    [extendedCellArray setArray:fillArray];
    [self.tableView reloadData];
    
    
    if([journalArray count] == 0){
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"journal_no_entries.png"]];
    [self.tableView setBackgroundView:bg];
    }
    else{
        [self.tableView setBackgroundView:Nil];
    }
}


-(IBAction)leftSort:(id)sender{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:currentDate];
    //create a date with these components
    NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:-1];
    [components setDay:0]; //reset the other components
    [components setYear:0]; //reset the other components
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    self.currentDate = endDate;
    [self sortByMonth:endDate];
     NSDateComponents *components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:endDate];
    
    [self setTitle: bottomNavBar title:[NSString stringWithFormat:@"%@ %d", [monthsArray objectAtIndex:[components2 month] - 1], [components2 year]]];
    
    
}

-(IBAction)rightSort:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:currentDate];
    //create a date with these components
    NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:1];
    [components setDay:0]; //reset the other components
    [components setYear:0]; //reset the other components
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    self.currentDate = endDate;
    [self sortByMonth:endDate];
    
     NSDateComponents *components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:endDate];
    
     [self setTitle: bottomNavBar title:[NSString stringWithFormat:@"%@ %d", [monthsArray objectAtIndex:[components2 month] - 1], [components2 year]]];
    
}

- (IBAction)back:(id)sender {
	
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
