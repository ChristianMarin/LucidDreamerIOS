//
//  SelectMusicViewController.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GlobalStuff.h"

@class SelectMusicCell;

@protocol SelectMusicViewControllerDelegate; // forward declaration

@interface SelectMusicViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, MPMediaPickerControllerDelegate>{
    
   
    UITableView *tableView;
    UINavigationBar *topNavBar;
    UINavigationItem *topItemBar;
    //id <SelectMusicViewControllerDelegate>	delegate;
    
}
@property (nonatomic, unsafe_unretained) id <SelectMusicViewControllerDelegate>	delegate;

@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;

//@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)back:(id)sender;

@end

@protocol SelectMusicViewControllerDelegate

// implemented in MainViewController.m
- (void) updatePlayerWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;
- (void) updatePlayerDefaultSong: (NSString *)name title:(NSString *)title;

@end

