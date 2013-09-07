//
//  NSObject+DelayedBlock.h
//  MWFSlideNavigationViewControllerDemo
//


#import <Foundation/Foundation.h>

@interface NSObject (DelayedBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
