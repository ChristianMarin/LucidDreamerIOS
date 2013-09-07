//
//  MainViewController.m
//  LucidDreamer
//


#import "DACircularProgressView.h"
#import "MainViewController.h"
#import "FAQViewController.h"
#import "DreamJournalViewController.h"
#import "SlideNavigationViewController.h"
#import "SelectMusicViewController.h"
#import "MainAlertView.h"
#import "RealityCheckerViewController.h"

#import "NSObject+DelayedBlock.h"

@interface MainViewController ()
@property (strong, nonatomic) NSTimer *songTimer;
@property (strong, nonatomic) NSTimer *scheduledTime;
@end

@implementation MainViewController
@synthesize startButton;
@synthesize largeProgressView;
@synthesize alarmStarted;
@synthesize sound;
@synthesize volumeSlider;
@synthesize volumeButton;
@synthesize navOpen;
@synthesize topNavBar;
@synthesize managedObjectContext;
@synthesize playButton;
@synthesize pauseButton;
@synthesize centerImage;
@synthesize titleLabel;
@synthesize musicPlayer;
@synthesize userMediaItemCollection;
@synthesize appSoundPlayer;
@synthesize soundFileString;
@synthesize defaultSong;
@synthesize defaultPlaying;
@synthesize preventer;
@synthesize alarmFinished;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *patternImage = [UIImage imageNamed:@"main_background_tiled.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.alarmStarted = NO;
    largeProgressView.delegate = self;
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    [largeProgressView setMinimum];
    
    self.titleLabel.textColor = [GlobalStuff mainColor];

    [self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
   
    
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [volumeSlider setMaximumTrackTintColor:[UIColor grayColor]];
    
    
    self.slideNavigationViewController.delegate = self;
    self.slideNavigationViewController.dataSource = self;
    
    if ([self.topNavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"top_bg.png"];
        [self.topNavBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [self.topNavBar setTitleTextAttributes:@{
                                           UITextAttributeTextColor: [GlobalStuff mainColor],
                                     UITextAttributeTextShadowColor: [UIColor clearColor],
                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                                UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:21.0f]
     }];

    [self.startButton setTitleColor:[GlobalStuff mainColor] forState:UIControlStateNormal];
    
    [self.playButton setEnabled:NO];
    [self.pauseButton setEnabled:NO];
    
    
    
    
    [[SoundManager sharedManager] prepareToPlay];
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
   
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:@"defaultTime"];
    //NSLog(@"%@", [defaults objectForKey:@"defaultSong"]);
    
   
    if(!number){
        [largeProgressView setDefault];
        [defaults setObject:@"bin" forKey:@"defaultSong"];
        [defaults setObject:@"NO" forKey:@"songSavedTyped"];
        self.defaultSong = YES;
        self.soundFileString = @"bin";
        [defaults synchronize];
    }
    else{
        int min = [number intValue];
        
        [largeProgressView setDefaultSaved:min];
        self.largeProgressView.mintuesLabel.text = [NSString stringWithFormat:@"%000.i", min];
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        NSString *type = [defaults objectForKey:@"songSavedTyped"];
       
        if ([type isEqualToString:@"NO"]) {
            [defaults2 setObject:@"NO" forKey:@"songSavedTyped"];
            
            self.defaultSong = YES;
            self.soundFileString = [defaults2 objectForKey:@"defaultSong"];
            self.titleLabel.text = [defaults2 objectForKey:@"defaultSong"];
            if ([self.soundFileString isEqualToString:@"bin"])
                self.titleLabel.text = @"Default";
            else{
                self.titleLabel.text = @"Default (Louder)";
            }
        }
        else{
            [defaults2 setObject:@"YES" forKey:@"songSavedTyped"];
            self.defaultSong = NO;
            
            MPMediaPropertyPredicate * predicate = [MPMediaPropertyPredicate predicateWithValue:[defaults2 objectForKey:@"mediaSong"] forProperty:MPMediaItemPropertyPersistentID];
            
            
            MPMediaQuery *query = [[MPMediaQuery alloc] init];
            [query addFilterPredicate:predicate];
            
            
            
            // self.userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[[query items] objectAtIndex:0]];
            [musicPlayer setQueueWithQuery:query];
            
            self.titleLabel.text = [defaults2 objectForKey:@"mediaTitle"];
        }
        [defaults2 synchronize];

    }
    
    
    
    
    
    
       [[SoundManager sharedManager] prepareToPlay];
    
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
                             sizeof(sessionCategory),&sessionCategory);
    
    self.preventer = [[MMPDeepSleepPreventer alloc] init];
    
    self.volumeSlider.minimumTrackTintColor = [UIColor colorWithRed:59.0f/255.0f green:163.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    
    }


-(IBAction)pause:(id)sender
{
    if (!largeProgressView.alarmPaused) {
        [self.playButton setEnabled:YES];
        [self.pauseButton setEnabled:NO];
        self.centerImage.image = [UIImage imageNamed:@"main_control_paused_blue.png"];
    }
    else{
        [self.playButton setEnabled:NO];
        [self.pauseButton setEnabled:YES];
        self.centerImage.image = [UIImage imageNamed:@"main_control_playing_blue.png"];
    }
    [largeProgressView pause];

}

-(void)viewWillAppear:(BOOL)animated{
    
    if (navOpen) {
    [self _slide:MWFSlideDirectionLeft];
        self.largeProgressView.viewAble = NO;
    }
    else{
        self.largeProgressView.viewAble = YES;
    }
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    
    self.largeProgressView.ticker.layer.anchorPoint = self.largeProgressView.layer.anchorPoint;
    
    
    //self.largeProgressView.ticker.transform = CGAffineTransformMakeRotation(0);
     
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    self.largeProgressView.viewAble = NO;
}

- (void)playAudio {
    //Play the audio and set the button to represent the audio is playing
    [[SoundManager sharedManager] playSound:soundFileString looping:NO fadeIn:NO];
    
}

- (void)pauseAudio {
    //Pause the audio and set the button to represent the audio is paused
    [[SoundManager sharedManager] stopAllSounds];
    
}

- (void)togglePlayPause {
    //Toggle if the music is playing or paused
    if (!self.defaultPlaying) {
        [self playAudio];
        self.defaultPlaying = !self.defaultPlaying;
        
    } else if (self.defaultPlaying) {
        [self pauseAudio];
        self.defaultPlaying = !self.defaultPlaying;
    }
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self playAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self pauseAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self togglePlayPause];
        }
    }
}


- (IBAction) showMediaFilesPressed : (id) sender
{
    SelectMusicViewController *addController = [[SelectMusicViewController alloc] initWithNibName:@"SelectMusicViewController" bundle:nil];
    addController.delegate = self;
    
    if(!defaultSong){
        MPMusicPlaybackState playbackState = [musicPlayer playbackState];
        if (playbackState == MPMusicPlaybackStatePlaying) {
            [musicPlayer stop];
        }
    }
    else{
        
        if(defaultPlaying){
            defaultPlaying = !defaultPlaying;
            [[SoundManager sharedManager] stopAllSounds];
            
        }
        
        
    }

    [self presentModalViewController:addController animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MainAlertView *toLow = [[MainAlertView alloc] initWithTitle:@"Woah! That's low!"
                                                        message:@"We recommed you set the delay to longer than it takes you to fall asleep. Would you like to change your delay?"
                                                       delegate:self
                                              cancelButtonTitle:@"Continue"
                                              otherButtonTitles:@"Change", nil];
    
    if(alertView.tag == 1)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *item = [defaults objectForKey:@"firstTime"];
        if([title isEqualToString:@"Continue"] )
        {
            if (!item && largeProgressView.minutes <= 20) {
                [toLow setTag:2];
                [toLow show];
            }
            else{
        [self startMainTimer];
            }
            
            
        }
       else if([title isEqualToString:@"Change"]){
           if(largeProgressView.minutes <= 20)
           {
               
               [toLow setTag:2];
               [toLow show];
               
           }
        }
        [defaults setObject:@"YES" forKey:@"firstTime"];
        
        }
    if (alertView.tag == 2) {
        
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    {
        
        [self startMainTimer];
    }
    else if([title isEqualToString:@"Change"])
    {
        
    }
    }
}

-(void)startMainTimer{
    if(!defaultSong){
        MPMusicPlaybackState playbackState = [musicPlayer playbackState];
         if (playbackState == MPMusicPlaybackStatePlaying) {
            [musicPlayer stop];
             
        }
    }
    else{
        
        if(defaultPlaying){
            defaultPlaying = !defaultPlaying;
            [[SoundManager sharedManager] stopAllSounds];
           
        }
    
        
    }
    
    if (!alarmStarted) {
        largeProgressView.savedProgress = largeProgressView.minutes/1.8f * 0.01f;
        [preventer startPreventSleep];
        [largeProgressView startAnimation];
        if(largeProgressView.minutes >= 1 && largeProgressView.seconds > 0){
            [self.pauseButton setEnabled:YES];
            [self.playButton setEnabled:NO];
            self.centerImage.image = [UIImage imageNamed:@"main_control_playing_blue.png"];
        }else{
            [self.pauseButton setEnabled:NO];
            [self.playButton setEnabled:NO];
        }
        
        self.alarmStarted = YES;
        [startButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.selectMusicButton setEnabled:NO];
        [self.volumeButton setEnabled:NO];
        [self.volumeSlider setEnabled:NO];
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(defaultSong){
            
            [defaults setObject:soundFileString forKey:@"defaultSong"];
            [defaults setObject:@"NO" forKey:@"songSavedTyped"];
        }else{
            MPMediaItem *anItem = (MPMediaItem *)[self.userMediaItemCollection.items objectAtIndex: 0];
            NSNumber* persistentID = [anItem valueForProperty:MPMediaItemPropertyPersistentID];
            [defaults setObject:persistentID forKey:@"mediaSong"];
            [defaults setObject:@"YES" forKey:@"songSavedTyped"];
            [defaults setObject:[anItem valueForProperty:MPMediaItemPropertyTitle] forKey:@"mediaTitle"];
        }
        
        [defaults synchronize];
    }
    else {
        
        
        
        if (defaultSong && defaultPlaying) {
            [[SoundManager sharedManager] stopAllSounds];
            self.defaultPlaying = NO;
             [self journal];
            
        }
        else{
            
            MPMusicPlaybackState playbackState = [musicPlayer playbackState];
            if (playbackState == MPMusicPlaybackStatePlaying) {
                [musicPlayer stop];
                [self journal];
            }
        }
        
        if (alarmFinished == YES) {
            [self addEntry];
            alarmFinished = NO;
        }
        
        [self.songTimer invalidate];
        [largeProgressView stopAnimation];
        self.alarmStarted = NO;
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.playButton setEnabled:NO];
        [self.pauseButton setEnabled:NO];
        self.centerImage.image = [UIImage imageNamed:@"main_control_disabled.png"];
        [self.selectMusicButton setEnabled:YES];
        [self.volumeButton setEnabled:YES];
        [self.volumeSlider setEnabled:YES];
       
        
        [preventer stopPreventSleep];
        
        
        
    }
    

    
}
-(void)journal{
    AddJournalEntryViewController *addController = [[AddJournalEntryViewController alloc] initWithNibName:@"AddJournalEntryViewController" bundle:nil];
    //addController.addEntry = YES;
    addController.managedObjectContext = self.managedObjectContext;
    addController.delegate2 = (id)self;
   // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    addController.mainScreen = YES;
    //[self _slide:MWFSlideDirectionLeft];
    [self presentViewController:addController animated:YES completion:nil];
    
    

}

-(IBAction)checker:(id)sender{
    [self reality];
}

-(void)reality{
    
    RealityCheckerViewController *realityController = [[RealityCheckerViewController alloc] initWithNibName:@"RealityCheckerViewController" bundle:nil];
    
    realityController.managedObjectContext = self.managedObjectContext;

    [self presentModalViewController:realityController animated:YES];
    
    
}

- (void)addJournalEntryViewController:(AddJournalEntryViewController *)addJournalEntryViewController didAddEntry:(BOOL *)status{
         
        // Show the recipe in a new view controller
        
        
    
    // Dismiss the modal add recipe view controller
    [self dismissViewControllerAnimated:YES completion:^{
        [self showJournal:NO];
    }];
        
}

- (void)showJournal:(BOOL)animated {
    NSLog(@"CALLED");
   
    // Create a detail view controller, set the recipe, then push it.
    DreamJournalViewController *detailViewController = [[DreamJournalViewController alloc] initWithNibName:@"DreamJournalViewController" bundle:nil];    
    detailViewController.managedObjectContext = self.managedObjectContext;
    [self presentViewController:detailViewController animated:YES completion:nil];
   
}

-(void)addEntry{
    
    
    AddJournalEntryViewController *addController = [[AddJournalEntryViewController alloc] initWithNibName:@"AddJournalEntryViewController" bundle:nil];
    addController.managedObjectContext = self.managedObjectContext;
    addController.delegate2 = (id)self;
    addController.mainScreen = YES;
    [self presentViewController:addController animated:YES completion:nil];
    
}
   


- (IBAction)startTimer:(id)sender
{
    
    if (alarmStarted) {
        //stop
        [self startMainTimer];
    }
    
    else{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       
      NSNumber      *minutes = [NSNumber numberWithInt:largeProgressView.minutes];
        
        
    [defaults setObject:minutes forKey:@"defaultTime"];
    [defaults synchronize];

    NSString *item = [defaults objectForKey:@"firstTime"];
    if (!item) {
        
        MainAlertView *firstTime = [[MainAlertView alloc] initWithTitle:@"Just so you know"
                                                            message:@"1. The default tone is only 10 seconds long. It is 100% designed to be that way. \n\n2. Lucid Dreamer will NOT play the music until the countdown timer has finished. \n\nIE. If you set the delay to 45 minutes, you will have to wait until the 45 minutes are up before the music will play."
                                                           delegate:self
                                                      cancelButtonTitle:@"Continue"
                                                      otherButtonTitles:@"Change", nil];
        [firstTime setTag:1];
        [firstTime show];

    }
    
    else{
       
        if (largeProgressView.minutes <= 20.0 ) {
            MainAlertView *toLow = [[MainAlertView alloc] initWithTitle:@"Woah! That's low!"
                                                                message:@"We recommed you set the delay to longer than it takes you to fall asleep. Would you like to change your delay?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Continue"
                                                      otherButtonTitles:@"Change", nil];
            [toLow setTag:2];
            [toLow show];
        }
        else{
            
    
        [defaults setObject:@"YES" forKey:@"firstTime"];
        [defaults synchronize];
            [self startMainTimer];
        }
    }
}
    
    
}


-(IBAction)changeVolumeSlider:(id)sender
{
   
       //self.appSoundPlayer.volume = volumeSlider.value;
    
    if (defaultSong) {
        [[SoundManager sharedManager] setSoundVolume:volumeSlider.value];
    }
    else{
         self.musicPlayer.volume = volumeSlider.value;
    }

    
}

-(IBAction)playSound:(id)sender
{
    
    [self playCurrentSound];
    
}
-(void)playCurrentSound{
    
    if(!defaultSong){
        MPMusicPlaybackState playbackState = [musicPlayer playbackState];
        if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
            //[musicPlayer setCurrentPlaybackTime:0];
            [musicPlayer play];
        } else if (playbackState == MPMusicPlaybackStatePlaying) {
            [musicPlayer stop];
        }
    }
    else{
        
        if(!defaultPlaying){
            defaultPlaying = !defaultPlaying;
            [[SoundManager sharedManager] playSound:soundFileString looping:NO fadeIn:NO];
            
        }
        else{
            defaultPlaying = !defaultPlaying;
            [[SoundManager sharedManager] stopAllSounds];
        }
        
    }
}

-(void)setAlarm:(BOOL)value
{
    self.alarmStarted = value;
    if(!value)
        [startButton setTitle:@"Start" forState:UIControlStateNormal];    
}
-(BOOL)alarmStarted{
    return alarmStarted;
}

-(void)timerCompleted
{
   
   
    if (defaultSong) {
        float duration = [[SoundManager sharedManager] currentMusicLength];
        
        self.songTimer = [NSTimer scheduledTimerWithTimeInterval:duration + 3
                                                          target:self
                                                        selector:@selector(lucidState)
                                                        userInfo:nil
                                                         repeats:YES];
        
        
        [[SoundManager sharedManager] playSound:soundFileString looping:NO];
        self.defaultPlaying = YES;
    }
    else{
        MPMediaItem *anItem = (MPMediaItem *)[self.userMediaItemCollection.items objectAtIndex: 0];
        NSTimeInterval timeInterval = [ [anItem valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
        
        
        self.songTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval + 3
                                                          target:self
                                                        selector:@selector(lucidState)
                                                        userInfo:nil
                                                         repeats:YES];
        
    [musicPlayer play];
    }
    alarmFinished = YES;
}
-(void)lucidState
{
    
    if (defaultSong) {
        [[SoundManager sharedManager] playSound:soundFileString looping:NO];
    }
    else{
        [musicPlayer play];
    }

}

-(IBAction)openNav:(id)sender
{
   
    
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
     gr.delegate= self;
    navOpen = !navOpen;
    if(navOpen){
    [self _slide:MWFSlideDirectionLeft];
    [self.view addGestureRecognizer:gr];    
        if(!defaultSong){
            MPMusicPlaybackState playbackState = [musicPlayer playbackState];
            if (playbackState == MPMusicPlaybackStatePlaying) {
                [musicPlayer stop];
            }
        }
        else{
            
            if(defaultPlaying){
                defaultPlaying = !defaultPlaying;
                [[SoundManager sharedManager] stopAllSounds];
                
            }
            
            
        }
        self.largeProgressView.viewAble = NO;
        [self.view addGestureRecognizer:gr];
        
    }
    else{
        [self.slideNavigationViewController slideWithDirection:MWFSlideDirectionNone];
        [self.view removeGestureRecognizer:gr];
        self.largeProgressView.viewAble = YES;
    }
   
   
}

- (void) _slide:(MWFSlideDirection)direction {
    
    [self.slideNavigationViewController slideWithDirection:direction];
    self.slideNavigationViewController.delegate = self;
}

- (void) close:(id)sender {
    if (navOpen) 
    navOpen = !navOpen;
    
    
    self.largeProgressView.viewAble = YES;
    [self _slide:MWFSlideDirectionNone];
}

#pragma mark - MWFSlideNavigationViewControllerDelegate
#define VIEWTAG_OVERLAY 1100

- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller willPerformSlideFor:(UIViewController *)targetController withSlideDirection:(MWFSlideDirection)slideDirection distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation {
    
    if (slideDirection == MWFSlideDirectionNone) {
        
        UIView * overlay = [self.navigationController.view viewWithTag:VIEWTAG_OVERLAY];
        [overlay removeFromSuperview];
        
    } else {
        
        UIView * overlay = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        overlay.tag = VIEWTAG_OVERLAY;
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [overlay addGestureRecognizer:gr];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:overlay];
        
    }
}

- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller animateSlideFor:(UIViewController *)targetController withSlideDirection:(MWFSlideDirection)slideDirection distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation
{
    UIView * overlay = [self.navigationController.view viewWithTag:VIEWTAG_OVERLAY];
    if (slideDirection == MWFSlideDirectionNone)
    {
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
}

- (NSInteger) slideNavigationViewController:(MWFSlideNavigationViewController *)controller distanceForSlideDirecton:(MWFSlideDirection)direction portraitOrientation:(BOOL)portraitOrientation
{
    if (portraitOrientation)
    {
        if(navOpen)
        return 250;
        
    }
    
        return 100;
    
}

#pragma mark - MWFSlideNavigationViewControllerDataSource
- (UIViewController *) slideNavigationViewController:(MWFSlideNavigationViewController *)controller viewControllerForSlideDirecton:(MWFSlideDirection)direction
{
    
    UINavigationController * navCtl;
    if(direction ==  MWFSlideDirectionLeft){
    SlideNavigationViewController * secCtl = [[SlideNavigationViewController alloc] init];
    navCtl = [[UINavigationController alloc] initWithRootViewController:secCtl];
    secCtl.managedObjectContext = self.managedObjectContext;
    
    }
    
    return navCtl;
}

- (void) updatePlayerWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection{
    self.userMediaItemCollection = nil;
    self.userMediaItemCollection = mediaItemCollection;
    [musicPlayer setQueueWithItemCollection: userMediaItemCollection];
    
    MPMediaItem *anItem = (MPMediaItem *)[mediaItemCollection.items objectAtIndex: 0];
    
    titleLabel.text = [anItem valueForProperty:MPMediaItemPropertyTitle];
	
    defaultSong = NO;
    
}

- (void) updatePlayerDefaultSong: (NSString *)name title:(NSString *)title
{
   // defaultSong = !defaultSong;
    self.soundFileString = name;
    
    titleLabel.text = title;
    defaultSong = YES;
     
    
}


@end
