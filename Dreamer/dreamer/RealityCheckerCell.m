//
//  RealityCheckerCell.m
//  dreamer
//
//  Created by art on 9/4/13.
//  Copyright (c) 2013 Gaurdanis. All rights reserved.
//

#import "RealityCheckerCell.h"

@implementation RealityCheckerCell
@synthesize backgroundImageView;
@synthesize onOffButton;
@synthesize realityChecker;
@synthesize vibrateButton;
@synthesize selectMusicButton;
@synthesize rightDateButton;
@synthesize leftDateButton;
@synthesize divider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:backgroundImageView];
        
        self.onOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.onOffButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.onOffButton addTarget:self action:@selector(onOff:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:onOffButton];
        
        self.vibrateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.vibrateButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.vibrateButton addTarget:self action:@selector(vibrate:) forControlEvents:UIControlEventTouchUpInside];
        //[self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:vibrateButton];
        
        self.rightDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.vibrateButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.rightDateButton addTarget:self action:@selector(rightDate:) forControlEvents:UIControlEventTouchUpInside];
        self.rightDateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        self.rightDateButton.titleLabel.textColor = [GlobalStuff mainColor];
        //[self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:rightDateButton];

        self.leftDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.vibrateButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.leftDateButton addTarget:self action:@selector(leftDate:) forControlEvents:UIControlEventTouchUpInside];
        self.leftDateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        self.leftDateButton.titleLabel.textColor = [GlobalStuff mainColor];
        //[self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:leftDateButton];
        
        self.divider = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.divider setFont:[UIFont boldSystemFontOfSize:18.0]];
        [self.divider setTextColor:[GlobalStuff mainColor]];
        [self.divider setHighlightedTextColor:[UIColor clearColor]];
        [self.divider setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.divider];
        
        /*
        self.selectMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectMusicButton addTarget:self action:@selector(selectMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectMusicButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:selectMusicButton];
         */

        
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
	
    [backgroundImageView setFrame:[self _backgroundImageViewFrame]];
    [onOffButton setFrame:[self _onOffButtonFrame]];
    [vibrateButton setFrame:[self _vibrateButtonFrame]];
    [leftDateButton setFrame:[self _leftDateButtonFrame]];
    [rightDateButton setFrame:[self _rightDateButtonFrame]];
    [divider setFrame:[self _dividerLabelFrame]];
    
   
    
    if(realityChecker.onOffStatus == [NSNumber numberWithInt:1]){
        [self.onOffButton setImage:[UIImage imageNamed:@"checker_list_item_on.png"] forState:UIControlStateNormal];
    }
    else{
        [self.onOffButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
    }
    
    if(realityChecker.vibrate == [NSNumber numberWithInt:1]){
        [self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_vibrate_on.png"] forState:UIControlStateNormal];
    }
    else{
        [self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_vibrate_off.png"] forState:UIControlStateNormal];
    }
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.divider.text = @"-";
    
    NSDateFormatter *formatter = [NSDateFormatter new] ;
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeString = [formatter stringFromDate:realityChecker.startTime];
    NSString *timeString2 = [formatter stringFromDate:realityChecker.endTime];
    [self.leftDateButton setTitle:timeString forState:UIControlStateNormal];
    [self.rightDateButton setTitle:timeString2 forState:UIControlStateNormal];
    
}

- (CGRect)_backgroundImageViewFrame {
    
    return CGRectMake(0, 0, self.contentView.bounds.size.width, 60);
    
}

- (CGRect)_onOffButtonFrame {
    
    return CGRectMake(self.contentView.bounds.size.width - 50 - 10, self.contentView.bounds.size.height/2 - 42/2, 50, 42);
    
}

- (CGRect)_vibrateButtonFrame {
    
    return CGRectMake(self.contentView.bounds.size.width - 50 - 10 - 35 - 10, self.contentView.bounds.size.height/2 - 35/2, 35, 35);
    
}

- (CGRect)_leftDateButtonFrame {
    
    return CGRectMake(10, self.contentView.bounds.size.height/2 - 35/2, 75, 35);
    
}

- (CGRect)_rightDateButtonFrame {
    
    return CGRectMake(95, self.contentView.bounds.size.height/2 - 35/2, 75, 35);
    
}

- (CGRect)_dividerLabelFrame {
    
    return CGRectMake(86, self.contentView.bounds.size.height/2 - 5/2, 10, 5);
    
}



-(IBAction)onOff:(id)sender{
    
    if(realityChecker.onOffStatus == [NSNumber numberWithInt:1]){
        [self.onOffButton setImage:[UIImage imageNamed:@"checker_list_item_off.png"] forState:UIControlStateNormal];
        realityChecker.onOffStatus = [NSNumber numberWithInt:0];
    }
    else{
        [self.onOffButton setImage:[UIImage imageNamed:@"checker_list_item_on.png"] forState:UIControlStateNormal];
        realityChecker.onOffStatus = [NSNumber numberWithInt:1];
    }
    
}

-(IBAction)vibrate:(id)sender{
    if(realityChecker.vibrate == [NSNumber numberWithInt:1]){
        [self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_vibrate_off.png"] forState:UIControlStateNormal];
        realityChecker.vibrate = [NSNumber numberWithInt:0];
    }
    else{
        [self.vibrateButton setImage:[UIImage imageNamed:@"checker_list_item_vibrate_on.png"] forState:UIControlStateNormal];
        realityChecker.vibrate = [NSNumber numberWithInt:1];
    }
    
}

-(IBAction)rightDate:(id)sender{
    NSLog(@"Right");
    [self.delegate openPopup:YES];
    
}

-(IBAction)leftDate:(UIButton *)sender{
    
     [self.delegate openPopup:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
