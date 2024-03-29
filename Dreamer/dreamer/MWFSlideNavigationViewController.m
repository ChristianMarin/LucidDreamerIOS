//
//  MWFSlideNavigationViewController.m
//


#import "MWFSlideNavigationViewController.h"

#define TRANSITION_ANIMATION_DURATION 0.3

//------------------------------------------------------------------------------
#define VIEWTAG_PRIMARY_VIEW 888
#define VIEWTAG_SECONDARY_VIEW 889

@interface MWFSlideNavigationLayoutView : UIView
@property (nonatomic) MWFSlideDirection slideDirection;
@property (nonatomic) CGFloat portraitOrientationDistance;
@property (nonatomic) CGFloat landscapeOrientationDistance;
- (void) slide:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completionBlock;
@end

//------------------------------------------------------------------------------
@implementation MWFSlideNavigationLayoutView
@synthesize  slideDirection = _slideDirection;
@synthesize portraitOrientationDistance = _portraitOrientationDistance;
@synthesize landscapeOrientationDistance = _landscapeOrientationDistance;

- (UIInterfaceOrientation) _currentOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (UIView *) primarySubview {
    return [self viewWithTag:VIEWTAG_PRIMARY_VIEW];
}

- (UIView *) secondarySubview {
    return [self viewWithTag:VIEWTAG_SECONDARY_VIEW];
}

- (void) slide:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completionBlock {

    UIInterfaceOrientation currentOrientation = [self _currentOrientation];
    
    CGFloat v = 0;
    CGFloat h = 0;
    CGRect b = self.bounds;
    
    CGFloat childx = b.origin.x;
    CGFloat childy = b.origin.y;
    CGFloat childw = b.size.width;
    CGFloat childh = b.size.height;
    CGFloat distance = (currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown) ?
    _portraitOrientationDistance : _landscapeOrientationDistance;
    
    switch (_slideDirection) {
        case MWFSlideDirectionUp:
            v = -distance;
            childy = b.size.height-distance;
            childh = distance;
            break;
        case MWFSlideDirectionLeft:
            h = -distance;
            childx = b.size.width-distance;
            childw = distance;            
            break;
        case MWFSlideDirectionRight:
            h = distance;
            childw = distance;
            break;
        case MWFSlideDirectionDown:
            v = distance;
            childh = distance;            
            break;
        default:
            // do nothing
            break;
    }
    
    UIView * primarySubview = [self primarySubview];
    UIView * secondarySubview = [self secondarySubview];
    
    if (self.slideDirection != MWFSlideDirectionNone) {
        secondarySubview.frame = CGRectMake(childx, childy, childw, childh);
    }
    if (animated) {

        [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION 
                         animations:^{
                             primarySubview.frame = CGRectMake(b.origin.x+h, b.origin.y+v, b.size.width, b.size.height);
                             if (animations != NULL) animations();
                         } 
                         completion:^(BOOL finished) {
                             if (finished) { 
                                 if (completionBlock != NULL) completionBlock();
                             }
                         }];
        
    } else {
        
        primarySubview.frame = CGRectMake(b.origin.x+h, b.origin.y+v, b.size.width, b.size.height);
        if (completionBlock != NULL) completionBlock();
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self slide:NO animations:NULL completion:NULL];
    
}
@end

//------------------------------------------------------------------------------
@interface MWFSlideNavigationViewController ()
- (MWFSlideNavigationLayoutView *) _layoutView;
- (void) _addRootView;
- (void) _willSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation;
- (void) _animateSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation;
- (void) _didSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation;
- (UIViewController *) _viewControllerForSlideDirection:(MWFSlideDirection)direction;
- (NSInteger) _slideDistanceForDirection:(MWFSlideDirection)direction portraitOrientation:(BOOL)portraitOrientation;
- (void) _slideForViewController:(UIViewController *)viewController 
                       direction:(MWFSlideDirection)direction 
     portraitOrientationDistance:(CGFloat)pdistance 
    landscapeOrientationDistance:(CGFloat)ldistance
;
@end
//------------------------------------------------------------------------------
@implementation MWFSlideNavigationViewController
@synthesize rootViewController = _rootViewController;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize currentSlideDirection = _currentSlideDirection;
@synthesize currentPortraitOrientationDistance = _currentPortraitOrientationDistance;
@synthesize currentLandscapeOrientationDistance = _currentLandscapeOrientationDistance;
@synthesize panEnabled = _panEnabled;

#pragma mark - Inits

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {

        self.rootViewController = rootViewController;
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void) loadView {

    [super loadView];
    
    MWFSlideNavigationLayoutView * layoutView = [[MWFSlideNavigationLayoutView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = layoutView;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    // handle scenario where view was unloaded, need to add the root view back
    if (_rootViewController && [[self childViewControllers] containsObject:_rootViewController] && ![self.view viewWithTag:VIEWTAG_PRIMARY_VIEW]) {
        [self _addRootView];
    }

   // UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    //gr.delegate = self;
   // NSArray * gestureRecognizers = [NSArray arrayWithObject:gr];
   // [self.view setGestureRecognizers:gestureRecognizers];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[self slideForViewController:nil direction:MWFSlideDirectionNone portraitOrientationDistance:0 landscapeOrientationDistance:0];
    [self slideWithDirection:MWFSlideDirectionNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [_rootViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark - MWFSlideNavigationViewController Private Methods
- (MWFSlideNavigationLayoutView *) _layoutView {
    return (MWFSlideNavigationLayoutView *) self.view;
}
- (void) _addRootView {
    [self.view addSubview:_rootViewController.view];
}
- (void) _willSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation {
    if (_delegate && 
        [(id)_delegate respondsToSelector:@selector(slideNavigationViewController:willPerformSlideFor:withSlideDirection:distance:orientation:)]) {
        [(id)_delegate slideNavigationViewController:self willPerformSlideFor:targetCtl withSlideDirection:direction distance:distance orientation:orientation];
    }
}
- (void) _animateSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation
{
    if (_delegate && 
        [(id)_delegate respondsToSelector:@selector(slideNavigationViewController:animateSlideFor:withSlideDirection:distance:orientation:)]) {
        [(id)_delegate slideNavigationViewController:self animateSlideFor:targetCtl withSlideDirection:direction distance:distance orientation:orientation];
    }    
}
- (void) _didSlideFor:(UIViewController *)targetCtl direction:(MWFSlideDirection)direction distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation {
    if (_delegate &&
        [(id)_delegate respondsToSelector:@selector(slideNavigationViewController:didPerformSlideFor:withSlideDirection:distance:orientation:)]) {
        [(id)_delegate slideNavigationViewController:self didPerformSlideFor:targetCtl withSlideDirection:direction distance:distance orientation:orientation];
    }
}
- (UIViewController *) _viewControllerForSlideDirection:(MWFSlideDirection)direction
{
    UIViewController * ctl = nil;
    if (_dataSource &&
        [(id)_dataSource respondsToSelector:@selector(slideNavigationViewController:viewControllerForSlideDirecton:)])
    {
        ctl = [_dataSource slideNavigationViewController:self viewControllerForSlideDirecton:direction];
    }
    return ctl;
}
- (NSInteger) _slideDistanceForDirection:(MWFSlideDirection)direction portraitOrientation:(BOOL)portraitOrientation
{
    NSInteger distance = 0;
    if (_delegate &&
        [(id)_delegate respondsToSelector:@selector(slideNavigationViewController:distanceForSlideDirecton:portraitOrientation:)])
    {
        distance = [_delegate slideNavigationViewController:self distanceForSlideDirecton:direction portraitOrientation:portraitOrientation];
    }
    return distance;
}
- (void) _insertSecondaryViewController:(UIViewController *)targetController
{
    _secondaryViewController = targetController;
    [self addChildViewController:targetController];
    [targetController viewWillAppear:NO];
    targetController.view.tag = VIEWTAG_SECONDARY_VIEW;
    [self.view insertSubview:targetController.view atIndex:0];
    [targetController didMoveToParentViewController:self];
}
- (void) _removeSecondaryViewController
{
    [_secondaryViewController willMoveToParentViewController:nil];
    [_secondaryViewController.view removeFromSuperview];
    [_secondaryViewController removeFromParentViewController];
    _secondaryViewController = nil;    
}
- (void) _slideForViewController:(UIViewController *)viewController 
                       direction:(MWFSlideDirection)direction 
     portraitOrientationDistance:(CGFloat)pdistance 
    landscapeOrientationDistance:(CGFloat)ldistance {
    
    // already slided
    if (_secondaryViewController != nil && direction != MWFSlideDirectionNone) return;
    
    UIViewController * targetController = nil;
    CGFloat portraitDistance = 0;
    CGFloat landscapeDistance = 0;
    
    if (direction != MWFSlideDirectionNone) {
        targetController = viewController;
        portraitDistance = pdistance;
        landscapeDistance = ldistance;
    }
    
    _currentSlideDirection = direction;
    _currentPortraitOrientationDistance = portraitDistance;
    _currentLandscapeOrientationDistance = landscapeDistance;
    
    MWFSlideNavigationLayoutView * layoutView = [self _layoutView];
    layoutView.slideDirection = self.currentSlideDirection;
    layoutView.portraitOrientationDistance = self.currentPortraitOrientationDistance;
    layoutView.landscapeOrientationDistance = self.currentLandscapeOrientationDistance;
    
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat currentOrientationDistance = (currentInterfaceOrientation == UIInterfaceOrientationPortrait || currentInterfaceOrientation  == UIInterfaceOrientationPortraitUpsideDown) ? self.currentPortraitOrientationDistance : self.currentLandscapeOrientationDistance;
    
    if (targetController) {
        
        [self _insertSecondaryViewController:targetController];
        
        [self _willSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
        [layoutView slide:YES 
               animations:^{
                   [self _animateSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
               }
               completion:^{
                   [targetController viewDidAppear:YES];
                   [self _didSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
               }
         ];
        
    } else {
        
        [self _willSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
        
        [layoutView slide:YES
               animations:^{
                   [self _animateSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
               }
               completion:^{
                   [self _removeSecondaryViewController];
                   [self _didSlideFor:targetController direction:self.currentSlideDirection distance:currentOrientationDistance orientation:currentInterfaceOrientation];
               }
         ];
    }
}

#pragma mark - MWFSlideNavigationViewController Public Methods
- (void) setRootViewController:(UIViewController *)rootViewController {
    
    if (!rootViewController) return;
    
    UIViewController * oldRootViewController = _rootViewController;
    _rootViewController = rootViewController;
    UIViewController * newRootViewController = rootViewController;
    

    [self addChildViewController:newRootViewController];
    
    newRootViewController.view.tag = VIEWTAG_PRIMARY_VIEW;
    if (!oldRootViewController) {
        [self _addRootView];
        [newRootViewController didMoveToParentViewController:self];
    } else {
        [self transitionFromViewController:oldRootViewController 
                          toViewController:newRootViewController 
                                  duration:TRANSITION_ANIMATION_DURATION 
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    
                                } 
                                completion:^(BOOL completion) {
                                    [newRootViewController didMoveToParentViewController:self];
                                }
         ];
    }
}

- (void) slideForViewController:(UIViewController *)viewController 
                      direction:(MWFSlideDirection)direction 
    portraitOrientationDistance:(CGFloat)portraitOrientationDistance 
   landscapeOrientationDistance:(CGFloat)landscapeOrientationDistance
{
    [self _slideForViewController:viewController 
                        direction:direction 
      portraitOrientationDistance:portraitOrientationDistance 
     landscapeOrientationDistance:landscapeOrientationDistance]; 
}

- (void) slideWithDirection:(MWFSlideDirection)direction
{
    // already slided
    if (_secondaryViewController != nil && direction != MWFSlideDirectionNone) return;
    
    UIViewController * targetController = nil;
    CGFloat portraitDistance = 0;
    CGFloat landscapeDistance = 0;
    
    if (direction != MWFSlideDirectionNone) {
        targetController = [self _viewControllerForSlideDirection:direction];
        portraitDistance = [self _slideDistanceForDirection:direction portraitOrientation:YES];
        landscapeDistance = [self _slideDistanceForDirection:direction portraitOrientation:NO];
    }
    
    if (targetController || direction == MWFSlideDirectionNone)
    {
        [self _slideForViewController:targetController 
                            direction:direction 
          portraitOrientationDistance:portraitDistance 
         landscapeOrientationDistance:landscapeDistance];
    }
}


#pragma mark - Panning
- (MWFSlideDirection) _panningDirectionForTranslation:(CGPoint)p
{
    MWFSlideDirection direction;
    if (fabsf(p.y) > fabsf(p.x))
    {
        if (p.y < 0)
        {
            direction = MWFSlideDirectionNone;
        }
        else
        {
            direction = MWFSlideDirectionNone;
        }
    }
    else
    {
        if (p.x < 0)
        {
            direction = MWFSlideDirectionLeft;
        }
        else
        {
            direction = MWFSlideDirectionNone;
        }
    }
    return direction;
}

- (void) panned:(UIPanGestureRecognizer *)gr
{
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
        {
            _panningDirection = MWFSlideDirectionNone;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_panningDirection == MWFSlideDirectionNone)
            {
                CGPoint p = [gr translationInView:self.view];
                _panningDirection = [self _panningDirectionForTranslation:p];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self slideWithDirection:_panningDirection];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _panEnabled && (self.currentSlideDirection==MWFSlideDirectionNone);
}
@end

//------------------------------------------------------------------------------

@implementation UIViewController (MWFSlideNavigationViewController)

- (MWFSlideNavigationViewController *) slideNavigationViewController {

    MWFSlideNavigationViewController * slideNavigationViewController = nil;
    
    UIViewController * attempt = self.parentViewController;
    while (true) {
        
        if (!attempt) break;
        if ([attempt isKindOfClass:[MWFSlideNavigationViewController class]]) {
            slideNavigationViewController = (MWFSlideNavigationViewController *) attempt;
            break;
        } else {
            attempt = attempt.parentViewController;
        }
    }
    
    return slideNavigationViewController;
}

@end