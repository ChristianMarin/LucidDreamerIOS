//
//  FAQViewController.m
//  LucidDreamer
//


#import "FAQViewController.h"
#import "FAQCustomCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
static NSInteger numberOfRow = 9;
@interface FAQViewController ()

@end

@implementation FAQViewController


@synthesize topNavBar, tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    questionArray = [[NSMutableArray alloc]initWithObjects:@"What is Lucid Dreaming?",
                     @"How do I use this app?",
                     @"There's no sound!?",
                     @"What is a Binaural Beat?",
                     @"How do I add a new Journal Entry?",
                     @"How do I edit a Journal Entry?",
                     @"What is REM sleep?",
                     @"When does REM sleep happen?",
                     @"Why does the default beat only last about 10 seconds?",
                     @"What time should I set the countdown be set to?",
                     @"What should the volume be set to?",
                     @"What else can I do to help lucid dream?", nil];
    
    
    
    
    
    
    //[self.navigationBar setTintColor:[UIColor redColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    //[self.topNavBar setTitle:@"FAQ"];
    
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setTitle];
    
    self.view.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
}

-(void)viewDidUnload
{
    questionArray = Nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setTitle
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:21.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = @"Help";
    label.textAlignment = UITextAlignmentCenter;
    self.topItemBar.titleView = label;
    [label sizeToFit];
}


- (IBAction)back:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *FAQCellIdentifier = @"FAQCellIdentifier";
    
    FAQCustomCell *cell = (FAQCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:FAQCellIdentifier];
    if (cell == nil)
    {
        cell = [[FAQCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FAQCellIdentifier ];
        //cell.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.titleLabel.numberOfLines = 0;
        
    }
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

- (void)configureCell:(FAQCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = [questionArray objectAtIndex:indexPath.row];
    if (!([text isEqualToString:@"What is Lucid Dreaming?" ] || [text isEqualToString: @"How do I use this app?"] || [text isEqualToString: @"What is a Binaural Beat?"] || [text isEqualToString:@"What is REM sleep?" ] || [text isEqualToString:@"When does REM sleep happen?" ] || [text isEqualToString:@"Why does the default beat only last about 10 seconds?" ] || [text isEqualToString:@"What time should I set the countdown be set to?" ] || [text isEqualToString:@"What should the volume be set to?"] || [text isEqualToString:@"What else can I do to help lucid dream?"] || [text isEqualToString:@"There's no sound!?"] || [text isEqualToString:@"How do I edit a Journal Entry?"] || [text isEqualToString:@"How do I add a new Journal Entry?"]))
    {
        cell.extendableCell = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
        cell.extendableCell = NO;
    cell.question = text;
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQCustomCell *currentCell = (FAQCustomCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if ([currentCell.titleLabel.text isEqualToString:@"What is Lucid Dreaming?"])
    {
        if (cell0_ison == NO)
        {
            NSString *book = @"A dream qualifies as ‘lucid’ when the user makes the realization that he or she is dreaming and is able to both sustain and control the dream. Lucid dreamers can do just about anything; the possibilities are only limited by the imagination.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell0_ison = !cell0_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString: @"How do I use this app?"])
    {
        if (cell1_ison == NO)
        {
            NSString *book = @"Step 1. Set the delay to longer than it takes you to fall asleep.\n \nStep 2. Select your music (or use the recommended default).\n \nStep 3. Adjust the volume so that it is loud enough to hear, but quiet enough where it won’t disturb your sleep.\n \nStep 4. Click Start and let your imagination take you on the ride of your life.";
            
            
            [questionArray insertObject:book atIndex:indexPath.row+1];
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        cell1_ison = !cell1_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString: @"What is a Binaural Beat?"])
    {
        if (cell2_ison == NO)
        {
            NSString *book = @"“Binaural beats, or binaural tones, are auditory processing artifacts, or apparent sounds, the perception of which arises in the brain for specific physical stimuli” (Wikipedia). – Binaural Beats are basically stereo sounds that, when mixed together, trigger a reaction in your brain that helps you enter a state of mental relaxation, and ultimately, lucidity.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        cell2_ison = !cell2_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"What is REM sleep?" ])
    {
        if (cell3_ison == NO)
        {
            NSString *book = @"REM sleep stands for Rapid Eye Movement sleep state which is characterized by the rapid movement of the eyes. This is the stage of sleep where dreaming occurs.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        cell3_ison = !cell3_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"When does REM sleep happen?" ])
    {
        if (cell4_ison == NO)
        {
            NSString *book = @"REM usually occurs 4-5 times (roughly 90-120 minutes in total) per night, but the actual amount and frequency is dependent on the individual. Typically it more often occurs later in the sleep cycle.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        cell4_ison = !cell4_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"Why does the default beat only last about 10 seconds?" ])
    {
        if (cell5_ison == NO)
        {
            NSString *book = @"During personal experimentation, the use of the software was found to be far more effective with a shorter tone with a several second break in between. Personally, the short tone more than tripled my own rate of lucidity without any other lucid dreaming aids. But if you don’t want to use this short tone, feel free to download your own and play them through Lucid Dreamer!";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
        cell5_ison = !cell5_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"What time should I set the countdown be set to?" ])
    {
        if (cell6_ison == NO)
        {
            NSString *book = @"You want to set it for longer than it takes you to fall asleep.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell6_ison = !cell6_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"What should the volume be set to?"])
    {
        if (cell7_ison == NO)
        {
            NSString *book = @"You want the volume to be loud enough where you’ll be able to hear it, but quiet enough so that it won’t disturb your sleep. If it’s too loud or too soft, it may not work. You have to experiment with what works for you.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell7_ison = !cell7_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"What else can I do to help lucid dream?"])
    {
        if (cell8_ison == NO)
        {
            NSString *book = @"Generally this software will work without having to do anything else, but if it does, you can try combining it with techniques like habitual reality checking or meditation.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell8_ison = !cell8_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"There's no sound!?"])
    {
        if (cell9_ison == NO)
        {
            NSString *book = @"The music will not start playing until AFTER the countdown timer has finished (IE. If you set it to 45 minutes, you will not hear anything until after the 45 minutes has passed). You want the music to play after you have fallen asleep because you do not want it to prevent you from sleeping.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell9_ison = !cell9_ison;
    }
    if ([currentCell.titleLabel.text isEqualToString:@"How do I edit a Journal Entry?"])
    {
        if (cell10_ison == NO)
        {
            NSString *book = @"Open the Journal from the top-right navigation menu. Find your entry in the Journal, and then click on it and hold for 2 seconds. A window will then pop-up and ask if you would like to edit or delete the entry.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell10_ison = !cell10_ison;
    }
    
    if ([currentCell.titleLabel.text isEqualToString:@"How do I add a new Journal Entry?"])
    {
        if (cell11_ison == NO)
        {
            NSString *book = @"Open the Journal from the top-right navigation menu. Once in the Journal, click the top-right “New Entry” button. Enter the new Entry details, and click the top-right button to save.";
            [questionArray insertObject:book atIndex:indexPath.row+1];
            
            numberOfRow++;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else
        {
            
            [questionArray removeObjectAtIndex:indexPath.row+1];
            numberOfRow--;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        cell11_ison = !cell11_ison;
    }
    
    
    [self.tableView reloadData];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize constraintSize = CGSizeMake(238.0f, MAXFLOAT);
    
    
    
    NSString *text = [questionArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
    /*
     if (!([text isEqualToString:@"What is Lucid Dreaming?" ] || [text isEqualToString: @"How do I use this app?"] || [text isEqualToString: @"What is a Binaural Beat?"] || [text isEqualToString:@"What is REM sleep?" ] || [text isEqualToString:@"When does REM sleep happen?" ] || [text isEqualToString:@"Why does the default beat only last about 10 seconds?" ] || [text isEqualToString:@"What time should I set the countdown be set to?" ] || [text isEqualToString:@"What should the volume be set to?"] || [text isEqualToString:@"What else can I do to help lucid dream?"]))
     {
     font = [UIFont fontWithName:@"Helvetica" size:17.0];
     }
     else{
     font = [UIFont fontWithName:@"Helvetica" size:17.0];
     }
     */
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height < 50) {
        labelSize.height = 50.0;
    }
    else
        labelSize.height = labelSize.height + 10;
    
    return labelSize.height;
    
    
    
}




@end
