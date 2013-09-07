//
//  MWFSlideNavigationViewController.h
//


#import <UIKit/UIKit.h>


typedef enum {
    
    MWFSlideDirectionNone,
    
    MWFSlideDirectionUp,
    
    MWFSlideDirectionLeft,
   
    MWFSlideDirectionDown,
    
    MWFSlideDirectionRight
} MWFSlideDirection;

@class MWFSlideNavigationViewController;

#pragma mark - 

@protocol MWFSlideNavigationViewControllerDelegate 
@optional

- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller 
                   willPerformSlideFor:(UIViewController *)targetController 
                    withSlideDirection:(MWFSlideDirection)slideDirection
                              distance:(CGFloat)distance
                           orientation:(UIInterfaceOrientation)orientation;


- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller
                       animateSlideFor:(UIViewController *)targetController
                    withSlideDirection:(MWFSlideDirection)slideDirection
                              distance:(CGFloat)distance
                           orientation:(UIInterfaceOrientation)orientation;
;

- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller 
                    didPerformSlideFor:(UIViewController *)targetController 
                    withSlideDirection:(MWFSlideDirection)slideDirection
                              distance:(CGFloat)distance
                           orientation:(UIInterfaceOrientation)orientation;


- (NSInteger) slideNavigationViewController:(MWFSlideNavigationViewController *)controller
                   distanceForSlideDirecton:(MWFSlideDirection)direction
                        portraitOrientation:(BOOL)portraitOrientation
;

@end

#pragma mark - 

@protocol MWFSlideNavigationViewControllerDataSource
@optional
/** @name Providing content */

/** Sent to receiver when panning is detected.
 *
 * @param controller The slide navigation view controller.
 * @param direction The slide direction.
 * @return The view controller to be revealed upon sliding.
 */
- (UIViewController *) slideNavigationViewController:(MWFSlideNavigationViewController *)controller
                      viewControllerForSlideDirecton:(MWFSlideDirection)direction
;

@end

#pragma mark - 
/** The `MWFSlideNavigationViewController` is a container view controller implementation
 * that manages a primary and secondary view controller.
 *
 * Primary view controller is basically the root view controller provided during the class 
 * initialization using [MWFSlideNavigationViewController initWithRootViewController:] method. 
 * The primary/root view fills the whole of `MWFSlideNavigationViewController` view area.
 *
 * Secondary view controller is the 'hidden' beneath the primary/root view.
 * It is revealed by sliding the primary/root view in one of the 4 directions supported (`MWFSlideDirectionUp`, `MWFSlideDirectionLeft`, `MWFSlideDirectionDown` or `MWFSlideDirectionRight`),
 * using [MWFSlideNavigationViewController slideForViewController:direction:portraitOrientationDistance:landscapeOrientationDistance:] method.
 * The same method is used to slide the primary/root view back, by specifying `MWFSlideDirectionNone` as the slide direction.
 *
 * This view controller notifies its delegate in response to the sliding event. The delegate is a custom object
 * provided by your application that conforms to the MWFSlideNavigationViewControllerDelegate protocol. You can use
 * the callback methods to perform additional setup or cleanup tasks.
 *
 * @warning *Important:* When not showing, secondary view controller is removed from slide navigation controller and not retained.
 * It's the responsibilty of application to retain it if needed.
 *
 */
@interface MWFSlideNavigationViewController : UIViewController <UIGestureRecognizerDelegate> {
    UIViewController * _secondaryViewController;
    MWFSlideDirection _panningDirection;
}
/** The receiver's delegate or `nil` if it doesn't have a delegate. */
@property (nonatomic, unsafe_unretained) id<MWFSlideNavigationViewControllerDelegate> delegate;
/** The receiver's dataSource or `nil` if it doesn't have a dataSource. */
@property (nonatomic, unsafe_unretained) id<MWFSlideNavigationViewControllerDataSource> dataSource;
/** The root view controller. */
@property (nonatomic, strong) UIViewController * rootViewController;
/** The current slide direction. */
@property (nonatomic, readonly) MWFSlideDirection currentSlideDirection;
/** The current portrait orientation slide distance. */
@property (nonatomic, readonly) NSInteger currentPortraitOrientationDistance;
/** The current landscape orientation slide distance. */
@property (nonatomic, readonly) NSInteger currentLandscapeOrientationDistance;
/** Enable panning */
@property (nonatomic) BOOL panEnabled;

/* @name Creating slide navigation view controller */

/** Initializes and returns a newly created slide navigation view controller.
 *
 * Even it's not mandatory, each slide navigation controller should have a root view controller as its primary view controller.
 *
 * @param rootViewController The primary view controller
 * @return The initialized slide navigation view controller or `nil` if there was problem initializing the object.
 */
- (id) initWithRootViewController:(UIViewController *)rootViewController;

/* @name Sliding view controller */

/** Perform slide animation that reveals/hides the specified `viewController`. If the direction is `MWFSlideDirectionNone`, the values provided for `viewController` and distances are ignored, it's advised to just specify nil for `viewController` and 0 for distances.
 *
 * @param viewController The secondary view controller or `nil` if direction is `MWFSlideDirectionNone`.
 * @param direction The slide direction: `MWFSlideDirectionUp`, `MWFSlideDirectionLeft`, `MWFSlideDirectionDown`, `MWFSlideDirectionRight` or `MWFSlideDirectionNone`.
 * @param portraitOrientationDistance The distance of slide when in portrait orientation.
 * @param landscapeOrientationDistance The distance of slide when in landscape orientation.
 */
- (void) slideForViewController:(UIViewController *)viewController 
                      direction:(MWFSlideDirection)direction 
    portraitOrientationDistance:(CGFloat)portraitOrientationDistance
   landscapeOrientationDistance:(CGFloat)landscapeOrientationDistance __attribute__((deprecated));

/** Perform slide animation with specified direction. 
 * The receiver will request view controller to be revealed from its `dataSource` and slide distance from its `delegate`.
 * 
 * @param direction The slide direction.
 */
- (void) slideWithDirection:(MWFSlideDirection)direction
;
@end

#pragma mark - 
/** The MWFSlideNavigationViewController Additions for UIViewController
 * 
 * The MWFSlideNavigationViewController adds convenience method to access the container slide navigation view controller if
 * the receiver is contained in one.
 */
@interface UIViewController (MWFSlideNavigationViewController)
/** @name Getting container slide navigation controller */

/** Get the current container slide navigation controller of the receiver. 
 * 
 * @return The container slide navigation view controller or `nil` if the receiver is not contained in one.
 */
- (MWFSlideNavigationViewController *) slideNavigationViewController;

@end
