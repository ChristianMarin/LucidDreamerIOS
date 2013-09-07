//
//  SlideNavigationViewController.m
//  LucidDreamer
//


#import "SlideNavigationViewController.h"
#import "MWFSlideNavigationViewController.h"
#import "FAQViewController.h"
#import "DreamJournalViewController.h"
#import "SelectMusicViewController.h"
#import "StatisticsViewController.h"

@interface SlideNavigationViewController ()

@end



@implementation SlideNavigationViewController
@synthesize managedObjectContext;
@synthesize mediaItemCollection;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle
- (void) loadView {
    [super loadView];
    
    
    
    self.journalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.journalButton setImage:[UIImage imageNamed:@"sidepanel_item_bg.png"] forState:UIControlStateNormal];
    self.journalButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.journalButton addTarget:self action:@selector(openJournal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.journalButton];
    
    self.journalImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Journal.png"]];
    [self.view addSubview:self.journalImage];
    
    self.journalLabel = [[UILabel alloc] init];
    [self.journalLabel setText:@"Dream Journal"];
    self.journalLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    self.journalLabel.backgroundColor = [UIColor clearColor];
    self.journalLabel.textColor = [GlobalStuff mainColor];
    [self.view addSubview:self.journalLabel];
    
    
    self.selectMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectMusicButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.selectMusicButton addTarget:self action:@selector(selectMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectMusicButton setImage:[UIImage imageNamed:@"sidepanel_item_bg.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.selectMusicButton];
    
    self.selectMusicImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Music.png"]];
    [self.view addSubview:self.selectMusicImage];
    
    self.selectMusicLabel = [[UILabel alloc] init];
    [self.selectMusicLabel setText:@"Select Music"];
    self.selectMusicLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    self.selectMusicLabel.backgroundColor = [UIColor clearColor];
    self.selectMusicLabel.textColor = [GlobalStuff mainColor];
    [self.view addSubview:self.selectMusicLabel];
    
    
    self.statButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.statButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.statButton addTarget:self action:@selector(openStat:) forControlEvents:UIControlEventTouchUpInside];
    [self.statButton setImage:[UIImage imageNamed:@"sidepanel_item_bg.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.statButton];
    
    
    self.statImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stats.png"]];
    [self.view addSubview:self.statImage];
    
    self.statLabel = [[UILabel alloc] init];
    [self.statLabel setText:@"Statistics"];
    self.statLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    self.statLabel.backgroundColor = [UIColor clearColor];
    self.statLabel.textColor = [GlobalStuff mainColor];
    [self.view addSubview:self.statLabel];

    
    
    
    self.faqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faqButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.faqButton addTarget:self action:@selector(openFAQ:) forControlEvents:UIControlEventTouchUpInside];
    [self.faqButton setImage:[UIImage imageNamed:@"sidepanel_item_bg.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.faqButton];
    
    
    self.faqImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help.png"]];
    [self.view addSubview:self.faqImage];
    
    self.faqLabel = [[UILabel alloc] init];
    [self.faqLabel setText:@"Help"];
    self.faqLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    self.faqLabel.backgroundColor = [UIColor clearColor];
    self.faqLabel.textColor = [GlobalStuff mainColor];
    [self.view addSubview:self.faqLabel];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Navigation";
    self.view.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                           UITextAttributeTextColor: [GlobalStuff mainColor],
                                     UITextAttributeTextShadowColor: [UIColor clearColor],
                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                                UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:21.0f]
     }];
    
    
    
    
    CGSize s = self.view.bounds.size;
    
    self.journalButton.frame = CGRectMake(0, 0, s.width, 60);
    self.journalImage.frame = CGRectMake(10, 30 - 35/2, 35, 35);
    self.journalLabel.frame = CGRectMake(55, 30 - 20/2, s.width - 55, 20);
    
    
    self.selectMusicButton.frame = CGRectMake(0, 60, s.width, 60);
    self.selectMusicImage.frame = CGRectMake(10, 90 - 35/2, 35, 35);
    self.selectMusicLabel.frame = CGRectMake(55, 90 - 20/2, s.width - 55, 20);
    
    self.statButton.frame = CGRectMake(0, 120, s.width, 60);
    self.statImage.frame = CGRectMake(10, 150  - 35/2, 35, 35);
    self.statLabel.frame = CGRectMake(55, 150 - 20/2, s.width - 55, 20);
    
   self.faqButton.frame = CGRectMake(0, 180, s.width, 60);
    self.faqImage.frame = CGRectMake(10, 210  - 35/2, 35, 35);
    self.faqLabel.frame = CGRectMake(55, 210 - 20/2, s.width - 55, 20);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.journalButton = nil;
    self.selectMusicButton = nil;
    self.faqButton = nil;
}



#pragma mark Actions
- (void) openJournal:(id)sender {
    
    [self showJournal:YES];
    
    
}

-(void) openFAQ:(id)sender{
    FAQViewController *viewController = [[FAQViewController alloc] initWithNibName:@"FAQViewController" bundle:nil];

    [self presentModalViewController:viewController animated:YES];
}

-(void) selectMusic:(id)sender{
    
    SelectMusicViewController *addController = [[SelectMusicViewController alloc] initWithNibName:@"SelectMusicViewController" bundle:nil];
    addController.delegate = (id)self.slideNavigationViewController.rootViewController;
    
    [self presentModalViewController:addController animated:YES];
    
}
-(void)openStat:(id)sender {
    
    StatisticsViewController *controller = [[StatisticsViewController alloc] initWithNibName:@"StatisticsViewController" bundle:nil];
    controller.delegate = self;
    controller.managedObjectContext = self.managedObjectContext;
    [self presentModalViewController:controller animated:YES];
    
}


- (void)showJournal:(BOOL)animated {
    
    // Create a detail view controller, set the recipe, then push it.
    DreamJournalViewController *journalViewController = [[DreamJournalViewController alloc] initWithNibName:@"DreamJournalViewController" bundle:nil];
    journalViewController.managedObjectContext = self.managedObjectContext;
    [self presentModalViewController:journalViewController animated:YES];
}



- (void)statisticsViewController:(StatisticsViewController *)statisticsViewController dismiss:(BOOL *)status
{
    
    
}




@end
