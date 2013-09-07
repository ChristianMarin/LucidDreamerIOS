//
//  FAQViewController.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"

@class FAQCustomCell;

@interface FAQViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    BOOL cell0_ison;
    BOOL cell1_ison;
    BOOL cell2_ison;
    BOOL cell3_ison;
    BOOL cell4_ison;
    BOOL cell5_ison;
    BOOL cell6_ison;
    BOOL cell7_ison;
    BOOL cell8_ison;
    BOOL cell9_ison;
    BOOL cell10_ison;
    BOOL cell11_ison;
    
    NSMutableArray *questionArray;
    NSMutableArray *cellHeight;
    
    
    
}

@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)back:(id)sender;

@end
