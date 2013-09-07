//
//  MainViewController.h
//  LucidDreamer
//


@class MainAlertView;

#import "DACircularProgressView.h"
#import <CoreData/CoreData.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MWFSlideNavigationViewController.h"
#import "SelectMusicViewController.h"
#import "SlideNavigationViewController.h"
#import "SoundManager.h"
#import "MMPDeepSleepPreventer.h"
#import "DreamJournalViewController.h"
#import "AddJournalEntryViewController.h"
#import "GlobalStuff.h"
#import "RealityCheckerViewController.h"

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate, DACircularProgressViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate, MWFSlideNavigationViewControllerDelegate, MWFSlideNavigationViewControllerDataSource, SelectMusicViewControllerDelegate, UIAlertViewDelegate,AddEntryDelegate>{
    
    SoundManager                *soundManager;
    MPMediaItemCollection		*userMediaItemCollection;
    MPMusicPlayerController		*musicPlayer;
    AVAudioPlayer				*appSoundPlayer;
    NSString					*soundFileString;
    BOOL defaultSong;
    BOOL defaultPlaying;
    
    
}
@property (nonatomic, retain)	NSString				*soundFileString;
@property (nonatomic, retain)	AVAudioPlayer			*appSoundPlayer;
@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, retain)	MPMediaItemCollection	*userMediaItemCollection;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *centerImage;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UIButton *selectMusicButton;

@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;


@property (strong, nonatomic) IBOutlet DACircularProgressView *largeProgressView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property(nonatomic) BOOL alarmStarted;
@property(nonatomic) BOOL alarmFinished;
@property(nonatomic) BOOL navOpen;
@property(nonatomic) BOOL defaultSong;
@property(nonatomic) BOOL defaultPlaying;

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *volumeButton;

@property (strong, nonatomic) AVAudioPlayer *sound;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) MMPDeepSleepPreventer *preventer;

- (IBAction)startTimer:(id)sender;
-(IBAction)changeVolumeSlider:(id)sender;
- (IBAction)playSound:(id)sender;
-(IBAction)showMediaFilesPressed:(id)sender;
-(IBAction)openNav:(id)sender;
-(IBAction)pause:(id)sender;
-(IBAction)journal:(id)sender;
-(IBAction)checker:(id)sender;
//-(void)setAlarmStarted:(BOOL)value;

@end
