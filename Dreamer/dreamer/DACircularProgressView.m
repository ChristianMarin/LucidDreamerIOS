//
//  DACircularProgressView.m
//  DACircularProgress
//



#import "MainViewController.h"

#import <QuartzCore/QuartzCore.h>

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

#define PI 3.141592654



@interface DACircularProgressLayer : CALayer

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) NSInteger roundedCorners;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat progress;
@property (strong, nonatomic) UIImageView *ticker;

@end

@implementation DACircularProgressLayer

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic progress;




+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.height / 2.0f, rect.size.width / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat radians = (progress  * 2.0f * M_PI) - M_PI_2;
    
    
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, 3.0f * M_PI_2, -M_PI_2, NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if (progress > 0.0f)
    {
        
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, 3.0f * M_PI_2, radians, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
        
        
    }
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.0f - self.thicknessRatio);
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGRect rect2 = CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius * 2.0f, innerRadius * 2.0f);
    
    CGContextAddEllipseInRect(context, rect2);
    
    CGContextFillPath(context);
    
}

 
  

@end


#import "DACircularProgressView.h"

@interface DACircularProgressView ()
@property (strong, nonatomic) NSTimer *minTimer;
@property (strong, nonatomic) NSTimer *secTimer;
@property (strong, nonatomic) NSTimer *animationTimer;
@end

@implementation DACircularProgressView
@synthesize mintuesLabel;
@synthesize secondsLabel;
@synthesize minTimer;
@synthesize secTimer;
@synthesize minutes;
@synthesize seconds;
@synthesize savedProgress;
@synthesize delegate;
@synthesize ticker;
@synthesize degrees;
@synthesize savedPoint;
@synthesize minTextLabel;
@synthesize secTextLabel;
@synthesize alarmPaused;
@synthesize circleAnimation;
@synthesize animationdegrees;
@synthesize viewAble;



+ (void) initialize
{
    if (self != [DACircularProgressView class])
        return;
    
    
    
    id appearance = [self appearance];
    [appearance setTrackTintColor:[[UIColor grayColor] colorWithAlphaComponent:1.0f]];
    [appearance setProgressTintColor:[UIColor colorWithRed:59.0f/255.0f green:163.0f/255.0f blue:219.0f/255.0f alpha:1.0f]];
    [appearance setBackgroundColor:[UIColor clearColor]];
    
    [appearance setThicknessRatio:0.25f];
    [appearance setRoundedCorners:NO];
    
    
    
    
    
}


-(void)beginAnimation{
    
    self.circleAnimation.layer.anchorPoint = CGPointMake(self.layer.anchorPoint.x , self.layer.anchorPoint.y );
    self.secTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
    self.circleAnimation.transform = CGAffineTransformMakeRotation(0);
}
-(void)animateCircle{
    
    if(self.animationdegrees <= self.degrees){
        self.animationdegrees = self.animationdegrees + .01;
        self.circleAnimation.transform = CGAffineTransformMakeRotation(self.animationdegrees);
        
    }
    else{
        self.animationdegrees = 0;
        self.circleAnimation.transform = CGAffineTransformMakeRotation(0);
    }
}

+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![delegate alarmStarted]) {
        NSUInteger touchCount = 0;
        
        // Enumerates through all touch objects
        for (UITouch *touch in touches) {
            // Send to the dispatch method, which will make sure the appropriate subview is acted upon
            CGRect rect = self.bounds;
            CGPoint centerPoint = CGPointMake(rect.size.height / 2.0f, rect.size.width / 2.0f);
            CGPoint topCenter = CGPointMake(centerPoint.x, 0.0f);
            CGPoint point = [touch locationInView:self];
            
            CGFloat radian1 = [self getRotatingAngle:topCenter secondPoint:centerPoint];
            CGFloat radian2 = [self getRotatingAngle:point secondPoint:centerPoint] ;
            if(radian2 < 0.0f && radian2 < -1.570796f)
                radian2 = radian2 + (2 * PI);
            
            CGFloat radian = radian2 - radian1;
            
            self.progress = radian * .159154943020453;
            self.minutes = (int)(self.progress * 100 * 1.8);
            
            if(self.minutes <= 1)
                [self setMinimum];
            if(self.progress >= .99)
                [self setMaximum];
            
            self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
            self.secondsLabel.text = @"00";
            touchCount++;
            
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![delegate alarmStarted]) {
        
        
        UITouch *touch = [touches anyObject];
        
        CGRect rect = self.bounds;
        CGPoint centerPoint = CGPointMake(rect.size.height / 2.0f, rect.size.width / 2.0f);
        CGPoint topCenter = CGPointMake(centerPoint.x, 0.0f);
        CGPoint point = [touch locationInView:self];
        
        
        
        CGFloat radian1 = [self getRotatingAngle:topCenter secondPoint:centerPoint];
        CGFloat radian2 = [self getRotatingAngle:point secondPoint:centerPoint] ;
        if(radian2 < 0.0f && radian2 < -1.570796f)
            radian2 = radian2 + (2 * PI);
        
        CGFloat radian = radian2 - radian1;
        
        self.progress = radian * .159154943020453;
        
        self.minutes = (int)(self.progress * 100 * 1.8);
        
        if(self.progress <= 0.018)
            [self setMinimum];
        if(self.progress >= .99)
            [self setMaximum];
        
        self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
        self.secondsLabel.text = @"00";
    }
}
-(void)setMaximum
{
    if (self.progress >= .999) {
        self.progress = 1;
        self.minutes = 180;
    }
}
-(void)setMinimum
{
    
    if (self.progress <= 0.018) {
        self.minutes = 1;
        self.progress = 1/1.8f * 0.01f;
        self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
    }
}

-(float)getRotatingAngle:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint
{
    float dx = firstPoint.x - secondPoint.x;
    float dy = firstPoint.y - secondPoint.y;
    float radian = atan2(dy, dx);
    return radian;
}


- (DACircularProgressLayer *)circularProgressLayer
{
    return (DACircularProgressLayer *)self.layer;
}


- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
}

#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    // self.minutes = (int)(self.progress * 100 * 1.8);
    
    
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = fabsf(self.progress - pinnedProgress); // Same duration as UIProgressView animation
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
    }
    else
    {
        [self.circularProgressLayer setNeedsDisplay];
    }
    self.circularProgressLayer.progress = pinnedProgress;
    
    
    self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
}

-(void)handleTimerTick;
{
    self.seconds--;
    self.secondsLabel.text = [NSString stringWithFormat:@"%000.f", self.seconds];
    
    
    
    self.degrees = self.degrees - 0.10471975516;
    [self rotateTicker];
    
    if(self.seconds <= 0){
        if(self.minutes <= 0 && [secTimer isValid]){
            [self stopTimers];
            [self resetTicker];
            [self.delegate timerCompleted];
        }
        self.secondsLabel.text = @"00";
        self.seconds = 60.0f;
        [self resetTicker];
        self.minutes = self.minutes - 1;
    }
    
    
}

-(void)pause{
    
    
    alarmPaused = !alarmPaused;
    
    if (alarmPaused) {
        
        //CGFloat tempMin = (int)(self.progress * 100 * 1.8);
        // CGFloat seconds = self.seconds;
        
        
        [minTimer invalidate];
        [secTimer invalidate];
        minTimer = nil;
        secTimer = nil;
        self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
        self.secondsLabel.text = [NSString stringWithFormat:@"%000.f", self.seconds];
        
        
        
        
        
    }
    else{
        
        self.ticker.transform = CGAffineTransformMakeRotation(self.degrees);
        self.minTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
        self.secTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
        
        
        
        
    }
}

-(void)resetTicker
{
    self.ticker.transform = CGAffineTransformMakeRotation(0);
    self.degrees = 0.0;
    
}

-(void)rotateTicker{
   /*
    if(!CGPointEqualToPoint(self.ticker.layer.anchorPoint, CGPointMake(self.layer.anchorPoint.x , self.layer.anchorPoint.y ))){
         self.ticker.layer.anchorPoint = CGPointMake(self.layer.anchorPoint.x , self.layer.anchorPoint.y );
    }
    */
    if(self.viewAble == YES){
   self.ticker.layer.anchorPoint = self.savedPoint;
    self.ticker.transform = CGAffineTransformMakeRotation(self.degrees);
    }
    else{
        self.ticker.layer.anchorPoint = self.savedPoint;
        self.ticker.transform = CGAffineTransformMakeRotation(0);

    }
    
}
- (void)progressChange
{
    
    CGFloat progress = self.progress - .00000092592593;
        
    [self setProgress:progress ];
    
    
}


-(void)stopTimers
{
    [self.minTimer invalidate];
    self.minTimer = nil;
    [self.secTimer invalidate];
    self.secTimer = nil;
    self.seconds = 00;
    self.minutes = 0.0f;
    self.progress = 0.0f;
    self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
    self.secondsLabel.text = [NSString stringWithFormat:@"%000.f", self.seconds];
    
    [self setProgress:self.progress animated:YES];
    if(!(seconds == 0 && minutes == 0))
        [self.delegate setAlarm:NO];
    
    
}

- (void)startAnimation
{
    
    self.minutes = (int)(self.progress * 100 * 1.8);
    self.progress = minutes/1.8f * 0.01f;
    // self.savedProgress = self.progress;
    
    [self setMinimum];
    
    
    self.minTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    self.seconds = 60.0f;
    self.secTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
    
    
    self.minutes = self.minutes - 1;
    
    self.secondsLabel.text = @"00";
    
    [self resetTicker];
    
    self.ticker.layer.anchorPoint = CGPointMake(self.layer.anchorPoint.x , self.layer.anchorPoint.y );
    self.savedPoint = CGPointMake(self.layer.anchorPoint.x , self.layer.anchorPoint.y );
}

- (void)stopAnimation
{
    
    [self.minTimer invalidate];
    self.minTimer = nil;
    [self.secTimer invalidate];
    self.secTimer = nil;
    self.progress = self.savedProgress;
    self.minutes = (int)(self.savedProgress * 100 * 1.8);
    [self setProgress:self.savedProgress animated:YES];
    self.mintuesLabel.text = [NSString stringWithFormat:@"%000.f", self.minutes];
    self.secondsLabel.text = @"00";
    
    [self resetTicker];
    
    
    
    
}



#pragma mark - UIAppearance methods

- (UIColor *)trackTintColor
{
    return self.circularProgressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularProgressLayer.trackTintColor = trackTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)roundedCorners
{
    return self.roundedCorners;
}

- (void)setRoundedCorners:(NSInteger)roundedCorners
{
    self.circularProgressLayer.roundedCorners = roundedCorners;
    [self.circularProgressLayer setNeedsDisplay];
}

- (CGFloat)thicknessRatio
{
    return self.circularProgressLayer.thicknessRatio;
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    self.circularProgressLayer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)indeterminate
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"indeterminateAnimation"];
    return (spinAnimation == nil ? 0 : 1);
}

- (void)setIndeterminate:(NSInteger)indeterminate
{
    if (indeterminate && !self.indeterminate)
    {
        CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spinAnimation.byValue = [NSNumber numberWithFloat:2.0f*M_PI];
        spinAnimation.duration = self.indeterminateDuration;
        spinAnimation.repeatCount = HUGE_VALF;
        [self.layer addAnimation:spinAnimation forKey:@"indeterminateAnimation"];
    }
    else
    {
        [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    }
}
/*
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
 {
 return YES;
 }
 */
-(void)setDefault{
    self.minutes = 45;
    self.progress = minutes/1.8f * 0.01f;
    [self setProgress:self.progress animated:YES];
}

-(void)setDefaultSaved:(CGFloat)data{
    
    self.minutes = data;
    self.progress = minutes/1.8f * 0.01f;
    [self setProgress:self.progress animated:YES];
}
@end

