//
//  RealityCheckerViewController.h
//  dreamer
//
//  Created by art on 9/3/13.
//  Copyright (c) 2013 Gaurdanis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalStuff.h"
#import "RealityCheckerCell.h"

@class RealityCheckerCell;
@class RealityChecker;



@interface RealityCheckerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, RealityCheckerCellDelegate>{
    
     
    UITableView *tableview;
    UINavigationBar *topNavBar;
    UINavigationItem *topItemBar;
    UILabel *notificationFreq;
    NSMutableArray *timerArray;
    UILabel *bottomLabel;
    UISwitch *switcher;
}
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (nonatomic) CGFloat timerInterval;
@property (nonatomic, retain) NSMutableArray *timerArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *topItemBar;
@property (nonatomic, retain) IBOutlet UILabel *notificationFreq;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UISwitch *switcher;
@property (nonatomic, retain) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(IBAction)back:(id)sender;
-(IBAction)slider:(id)sender;
- (IBAction)closePopupAction:(id)sender;
@end
