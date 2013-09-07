//
//  CurtainViewController.h
//  LucidDreamer
//




#import <UIKit/UIKit.h>
#import "UIViewController+RECurtainViewController.h"
#import "Reachability.h"

@class MainViewController;

@interface CurtainViewController : UIViewController{
    
    BOOL dataSynced;
    Reachability *internetReachable;
    UIImageView *ring;
    
    
    
@private
    NSManagedObjectContext *managedObjectContext;
    
    
}
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UIImageView *ring;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
