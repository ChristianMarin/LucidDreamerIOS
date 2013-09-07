//
//  AppDelegate.h
//  dreamer
//
#import <UIKit/UIKit.h>
#import "CurtainViewController.h"

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) CurtainViewController *curtainViewController;

@end
