//
//  DreamJournalViewController.h
//  LucidDreamer
//


@class JournalEntry;
@class JournalCell;

#import <UIKit/UIKit.h>
#import "AddJournalEntryViewController.h"
#import "GlobalStuff.h"


//AddJournalEntryViewControllerDelegate

@interface DreamJournalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *journalArray;
    NSMutableArray *extendedCellArray;
    NSArray *storedEntrysArray;
    NSMutableArray *sortedMonthArray;
    NSDate *currentDate;
    NSInteger selectedIndex;
    NSArray *monthsArray;
    BOOL addEntry;
    
    
    @private
        NSManagedObjectContext *managedObjectContext;

}
@property (nonatomic) BOOL addEntry;
@property (strong, nonatomic) AddJournalEntryViewController *addViewController;
@property (nonatomic, retain) NSMutableArray *journalArray;
@property (nonatomic, retain) NSMutableArray *sortedMonthArray;
@property (nonatomic, retain) NSDate *currentDate;



@property (nonatomic) NSArray *storedEntrysArray;
@property (nonatomic) NSArray *monthsArray;

@property (strong, nonatomic) IBOutlet UINavigationBar *botNavBar;
@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *bottomNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction)back:(id)sender;
- (IBAction)addJournalEntry:(id)sender;

-(IBAction)leftSort:(id)sender;
-(IBAction)rightSort:(id)sender;


@end
