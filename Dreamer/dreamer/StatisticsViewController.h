//
//  StatisticsViewController.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"
#import "AddJournalEntryViewController.h"

@class StatsCell;
@class JournalEntry;

@protocol StatsDelegate;

@interface StatisticsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UINavigationBar *topNavBar;
    UINavigationItem *topItemBar;
    UITableView *tableView;
    NSArray *journalArray;
    
    
    @private
        NSManagedObjectContext *managedObjectContext;
    
}
@property(nonatomic, assign) id <StatsDelegate> delegate;

@property (nonatomic, retain) NSArray *journalArray;

@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;

//@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CGFloat lucidDreams;

-(IBAction)back:(id)sender;

@end

@protocol StatsDelegate <NSObject>
// recipe == nil on cancel
- (void)statisticsViewController:(StatisticsViewController *)statisticsViewController dismiss:(BOOL *)status;
@end

