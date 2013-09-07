//
//  AddJournalEntryViewController.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"
#import "PMCalendar.h"


@class MainAlertView;
@class JournalEntry;

@protocol AddEntryDelegate;




@interface AddJournalEntryViewController : UIViewController <UITextViewDelegate, PMCalendarControllerDelegate>
{
    
    JournalEntry *entry;
    UILabel *lucidQuestion;
    UILabel *dateLabel;
    UILabel *lucidLabel;
    UIButton *doneButton;
    UIButton *lucidCircle;
    UITextField *titleTextField;
    UINavigationBar *topNavBar;
    UINavigationItem *topItemBar;
    UITextView *bodyTextView;
    BOOL edit;
    BOOL keyboardOpen;
    BOOL calenderOpen;
    BOOL mainScreen;
    NSManagedObjectContext *managedObjectContext;
    NSNumber *savedLucidEdit;
    NSDate *tempDate;
    UIButton *dateButton;
    
}
//@property (nonatomic, unsafe_unretained) id <AddJournalEntryViewControllerDelegate> delegate;
@property(nonatomic, assign) id <AddEntryDelegate> delegate2;
@property (nonatomic) BOOL edit;
@property (nonatomic) BOOL mainScreen;
@property (nonatomic) BOOL keyboardOpen;
@property (nonatomic) BOOL calenderOpen;
@property (nonatomic, retain) NSDate *tempDate;

@property (nonatomic, retain) JournalEntry *entry;
@property (nonatomic, assign) NSInteger defaultTitle;
@property (strong, nonatomic) IBOutlet UILabel *lucidQuestion;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lucidLabel;
@property (strong, nonatomic) IBOutlet UIButton *lucidCircle;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)lucidButton:(id)sender;
-(IBAction)removeKeyboard:(id)sender;
- (IBAction)showCalendar:(id)sender;



@end

@protocol AddEntryDelegate <NSObject>
// recipe == nil on cancel
- (void)addJournalEntryViewController:(AddJournalEntryViewController *)addJournalEntryViewController didAddEntry:(BOOL *)status;
@end
