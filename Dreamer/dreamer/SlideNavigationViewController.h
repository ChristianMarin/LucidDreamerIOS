//
//  SlideNavigationViewController.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GlobalStuff.h"
#import "AddJournalEntryViewController.h"
#import "StatisticsViewController.h"



@interface SlideNavigationViewController : UIViewController <AddEntryDelegate, StatsDelegate>
{
    MPMediaItemCollection	*mediaItemCollection;
    
    
@private
    NSManagedObjectContext *managedObjectContext;
    
}



@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UIButton * journalButton;
@property (strong, nonatomic) UIImageView *journalImage;
@property (strong, nonatomic) UILabel *journalLabel;

@property (nonatomic, strong) UIButton * selectMusicButton;
@property (strong, nonatomic) UIImageView *selectMusicImage;
@property (strong, nonatomic) UILabel *selectMusicLabel;

@property (nonatomic, strong) UIButton * faqButton;
@property (strong, nonatomic) UIImageView *faqImage;
@property (strong, nonatomic) UILabel *faqLabel;

@property (nonatomic, strong) UIButton * statButton;
@property (strong, nonatomic) UIImageView *statImage;
@property (strong, nonatomic) UILabel *statLabel;

@property (nonatomic, strong) UIButton *realityCheckerButton;
@property (strong, nonatomic) UIImageView *realityCheckerImage;
@property (strong, nonatomic) UILabel *realityCheckerLabel;


@property (nonatomic, retain)	MPMediaItemCollection	*mediaItemCollection;


@end





