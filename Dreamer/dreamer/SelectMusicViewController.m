//
//  SelectMusicViewController.m
//  LucidDreamer
//


#import "SelectMusicViewController.h"
#import "SelectMusicCell.h"

@interface SelectMusicViewController ()

@end

@implementation SelectMusicViewController
@synthesize topItemBar;
@synthesize topNavBar;
@synthesize tableView;





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
    label.font = [UIFont fontWithName:@"Helvetica" size:21.0];
    label.textColor = [GlobalStuff mainColor];
    label.text = @"Select Music";
    label.textAlignment = UITextAlignmentCenter;
    self.topItemBar.titleView = label;
    [label sizeToFit];
}

-(IBAction)back:(id)sender
{

    
    [self dismissModalViewControllerAnimated:YES];
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
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *JournalCellIdentifier = @"JournalCellIdentifier";
    
    SelectMusicCell *cell = (SelectMusicCell *)[self.tableView dequeueReusableCellWithIdentifier:JournalCellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[SelectMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JournalCellIdentifier ];
        cell.backgroundImageView.image =  [UIImage imageNamed:@"journal_entry_group_item_bg.png"];
        cell.imageView.image = [UIImage imageNamed:@"Music.png"];
        
    }
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(SelectMusicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        cell.titleLabel.text = @"Default";
    }
    if(indexPath.row == 1){
        cell.titleLabel.text = @"Default (Louder)";
    }
    if(indexPath.row == 2){
        cell.titleLabel.text = @"Custom Music";
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
       
        [self.delegate updatePlayerDefaultSong:@"bin" title:@"Default"];
        [self dismissModalViewControllerAnimated: YES];
    }
    if(indexPath.row == 1){
        [self.delegate updatePlayerDefaultSong:@"bin_loud" title:@"Default (Louder)"];
        [self dismissModalViewControllerAnimated: YES];
    }
    if(indexPath.row == 2){
        MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= NO;
		picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
		
		// The media item picker uses the default UI style, so it needs a default-style
		//		status bar to match it visually
		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
		
		[self presentModalViewController: picker animated: YES];
    }
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}


// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	// Dismiss the media item picker.
	[self dismissModalViewControllerAnimated: YES];
    
	[self.delegate updatePlayerWithMediaCollection: mediaItemCollection];
	// Apply the chosen songs to the music player's queue.
    
    
	//[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
	
	
}

@end
