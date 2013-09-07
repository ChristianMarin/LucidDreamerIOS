//
//  DACircularProgressView.h
//  DACircularProgress
//


#import <UIKit/UIKit.h>

@class MainViewController;
@protocol DACircularProgressViewDelegate <NSObject>
-(void)setAlarm:(BOOL)value;
-(BOOL)alarmStarted;
-(void)timerCompleted;
@end


@interface DACircularProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger roundedCorners UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(
@property(nonatomic) CGFloat thicknessRatio UI_APPEARANCE_SELECTOR;
@property(nonatomic) CGFloat progress;
@property(nonatomic) CGFloat minutes;
@property(nonatomic) CGFloat seconds;
@property(nonatomic) CGFloat savedProgress;
@property(nonatomic) CGPoint savedPoint;
@property(nonatomic) BOOL alarmPaused;
@property(nonatomic) BOOL viewAble;

@property(nonatomic) CGFloat degrees;
@property(nonatomic) CGFloat animationdegrees;
@property (nonatomic, unsafe_unretained) id <DACircularProgressViewDelegate> delegate;

@property(nonatomic) CGFloat indeterminateDuration UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger indeterminate UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(

@property (strong, nonatomic) IBOutlet UILabel *mintuesLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *minTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *secTextLabel;

@property (strong, nonatomic) IBOutlet UIImageView *ticker;
@property (strong, nonatomic) IBOutlet UIImageView *circleAnimation;

//@property (strong, nonatomic) IBOutlet UILabel *progressLabel;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

-(void)startAnimation;
-(void)stopAnimation;
-(void)setMinimum;
-(void)pause;
-(void)setDefault;
-(void)setDefaultSaved:(CGFloat)data;
-(void)beginAnimation;


@end



