//
//  MainAlertView.m
//  LucidDreamer
//


#import "MainAlertView.h"

@implementation MainAlertView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int buttonCount = 0;
    UIButton *button1;
    UIButton *button2;
    
    // first, iterate over all subviews to find the two buttons;
    // those buttons are actually UIAlertButtons, but this is a subclass of UIButton
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ++buttonCount;
            if (buttonCount == 1) {
                button1 = (UIButton *)view;
            } else if (buttonCount == 2) {
                button2 = (UIButton *)view;
            }
        }
    }
    
    // make sure that button1 is as wide as both buttons initially are together
    button1.frame = CGRectMake(button1.frame.origin.x, button1.frame.origin.y, self.bounds.size.width/2 - 16, button1.frame.size.height);
    
    // make sure that button2 is moved to the next line,
    // as wide as button1, and set to the same x-position as button1
    button2.frame = CGRectMake(self.bounds.size.width/2 + 5, button1.frame.origin.y, button1.frame.size.width, button2.frame.size.height);
    
    // now increase the height of the (alert) view to make it look nice
    // (I know that magic numbers are not nice...)
    //self.bounds = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMaxY(button2.frame) + 15);
}



@end
