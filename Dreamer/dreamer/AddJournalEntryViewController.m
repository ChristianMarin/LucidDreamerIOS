//
//  AddJournalEntryViewController.m
//  LucidDreamer
//

#import <QuartzCore/QuartzCore.h>
#import "AddJournalEntryViewController.h"
#import "JournalEntry.h"
#import "MainAlertView.h"
#import "PMCalendar.h"

@interface AddJournalEntryViewController ()

@property (nonatomic, strong) PMCalendarController *calender;

@end

@implementation AddJournalEntryViewController

@synthesize entry, dateLabel, lucidLabel, lucidCircle, titleTextField, topNavBar, bodyTextView, edit, managedObjectContext, scrollView, doneButton, keyboardOpen, lucidQuestion, topItemBar, defaultTitle, calender, calenderOpen, tempDate, mainScreen, dateButton;

- (void)viewDidLoad
{
    
    self.dateLabel.textColor = [GlobalStuff mainColor];
    self.titleTextField.textColor = [GlobalStuff mainColor];
    self.lucidLabel.textColor = [GlobalStuff mainColor];
    self.bodyTextView.textColor = [GlobalStuff mainColor];
    self.lucidQuestion.textColor = [GlobalStuff mainColor];
    
    
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [titleTextField setValue:[GlobalStuff mainColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    if(!edit){
    [self newEntryDefaultTitle];
        [titleTextField setPlaceholder:[NSString stringWithFormat:@"Journal Entry %i",self.defaultTitle]];
    JournalEntry *journalEntry = [NSEntityDescription insertNewObjectForEntityForName:@"JournalEntry" inManagedObjectContext:self.managedObjectContext];
        self.entry = journalEntry;
    [entry setDate:[NSDate date]];
        self.tempDate = entry.date;
    entry.lucid = [NSNumber numberWithInt:1];
    dateLabel.text = [dateFormatter stringFromDate:[entry date]];
    }
    else{
    dateLabel.text = [dateFormatter stringFromDate:[entry date]];
        self.tempDate = entry.date;
    bodyTextView.text = entry.notes;
    titleTextField.text = entry.title;
        savedLucidEdit = entry.lucid;
        if(entry.lucid == [NSNumber numberWithInt:1]){
            lucidLabel.text = @"Yes";
            [lucidCircle setImage:[UIImage imageNamed:@"journal_lucid_true_blue"] forState:UIControlStateNormal];
        }
        else{
            lucidLabel.text = @"No";
            [lucidCircle setImage:[UIImage imageNamed:@"journal_lucid_false"] forState:UIControlStateNormal];
        }

    }
    
    
    self.view.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [self setTitle];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    self.delegate2 = nil;
}

- (void)setTitle
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:21.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = @"Entry";
    label.textAlignment = UITextAlignmentCenter;
    self.topItemBar.titleView = label;
    [label sizeToFit];
}

-(void)newEntryDefaultTitle{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    self.defaultTitle = [results count] + 1;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
            
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Don't Save"])
        {
            if(!edit){
                [self.managedObjectContext deleteObject:entry];
            }
            entry.lucid = savedLucidEdit;
            self.edit = NO;
            
          // [self.delegate reloadTable];
            
            if(self.mainScreen == YES){
                [self.delegate2 addJournalEntryViewController:self didAddEntry:YES];
                self.mainScreen = NO;
            }
            else{
                [self dismissModalViewControllerAnimated:YES];
            }

        }
        else if([title isEqualToString:@"Save"])
        {
            
            [self saveData];
           
    }
    
}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    keyboardOpen = !keyboardOpen;
    [self.scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    
    self.bodyTextView.frame = CGRectMake(self.bodyTextView.frame.origin.x, self.bodyTextView.frame.origin.y, 300, 195);
    [self.doneButton setImage:[UIImage imageNamed:@"check_mark_edit_Entry.png"] forState:UIControlStateNormal];
    [self.dateButton setEnabled:NO];
}

-(IBAction)removeKeyboard:(id)sender{
    
    [sender resignFirstResponder];
    [self.dateButton setEnabled:YES];
}

-(IBAction)save:(id)sender
{
    if(calenderOpen){
        [calender dismissCalendarAnimated:YES];
        
    }
    else{
        if (keyboardOpen == NO) {
            
            [self saveData];
        }
        else{
            self.bodyTextView.frame = CGRectMake(self.bodyTextView.frame.origin.x, self.bodyTextView.frame.origin.y, 300, 335);
            [self.bodyTextView resignFirstResponder];
            keyboardOpen = !keyboardOpen;
            [self.doneButton setImage:[UIImage imageNamed:@"add_entry"] forState:UIControlStateNormal];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    
    }
}
-(void)saveData{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *saveDate = [dateFormatter dateFromString:dateLabel.text];
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSHourCalendarUnit
                                                         | NSSecondCalendarUnit
                                                         | NSMinuteCalendarUnit | NSTimeZoneCalendarUnit )
                                               fromDate:[NSDate date]];
    NSDateComponents *components2 = [calendar components:(NSMonthCalendarUnit
                                                         | NSYearCalendarUnit
                                                         | NSDayCalendarUnit )
                                               fromDate:saveDate];
    
    
   // NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:[components2 month]];
    [components setDay:[components2 day]]; //reset the other components
    [components setYear:[components2 year]]; //reset the other components
    NSDate *endDate = [calendar dateFromComponents:components];
    
    [entry setDate:endDate];
    
    if([bodyTextView.text isEqualToString:@"Tonight, I..."])
        entry.notes = @"Tonight, I had a dream...";
    else
        entry.notes = bodyTextView.text;
    if ([titleTextField.text isEqualToString:@""]) {
        entry.title = [NSString stringWithFormat:@"Journal Entry %i", self.defaultTitle];
    }
    else{
        entry.title = titleTextField.text;
    }
    
     
    
    self.edit = NO;
   // [self.delegate reloadTable];
    NSError *error = nil;
    if (![entry.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    if(self.mainScreen == YES){
    [self.delegate2 addJournalEntryViewController:self didAddEntry:YES];
       self.mainScreen = NO;
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


-(IBAction)cancel:(id)sender
{
    
    
    
   
        MainAlertView *questionBack = [[MainAlertView alloc] initWithTitle:nil
                                                            message:@"Do you want to save?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Don't Save"
                                                  otherButtonTitles:@"Save", nil];
        [questionBack show];
    
    
    
   }

-(IBAction)lucidButton:(id)sender
{
    if(entry.lucid == [NSNumber numberWithInt:0]){
        entry.lucid = [NSNumber numberWithInt:1];
        lucidLabel.text = @"Yes";
        [sender setImage:[UIImage imageNamed:@"journal_lucid_true_blue"] forState:UIControlStateNormal];
    }
    else{
        entry.lucid = [NSNumber numberWithInt:0];
         lucidLabel.text = @"No";
        [sender setImage:[UIImage imageNamed:@"journal_lucid_false"] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCalendar:(id)sender
{
    
    self.calender = [[PMCalendarController alloc] init];
    self.calender.period = [PMPeriod oneDayPeriodWithDate:tempDate];
    calender.delegate = self;
    self.calenderOpen = YES;
    [self.doneButton setImage:[UIImage imageNamed:@"check_mark_edit_Entry.png"] forState:UIControlStateNormal];
    calender.mondayFirstDayOfWeek = YES;
    [calender presentCalendarFromView:sender
             permittedArrowDirections:PMCalendarArrowDirectionUnknown
                             animated:YES];
    /*    [pmCC presentCalendarFromRect:[sender frame]
     inView:[sender superview]
     permittedArrowDirections:PMCalendarArrowDirectionAny
     animated:YES];*/
    [self calendarController:calender didChangePeriod:calender.period];
    
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
  
    
    tempDate = newPeriod.startDate;
    
    
    
}

- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController{
    self.calenderOpen = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
   
   
    dateLabel.text = [dateFormatter stringFromDate:tempDate];
    [self.doneButton setImage:[UIImage imageNamed:@"add_entry"] forState:UIControlStateNormal];
    
}

@end
