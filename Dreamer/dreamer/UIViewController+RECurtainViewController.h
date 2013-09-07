//
// UIViewController+RECurtainViewController.h


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum _RECurtainTransitionStyle {
    RECurtainTransitionHorizontal = 0,
    RECurtainTransitionVertical = 1
} RECurtainTransitionStyle;

@interface UIViewController (RECurtainViewController)

- (void)curtainRevealViewController:(UIViewController *)viewControllerToReveal transitionStyle:(RECurtainTransitionStyle)transitionStyle;

@end
