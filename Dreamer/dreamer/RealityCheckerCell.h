//
//  RealityCheckerCell.h
//  dreamer
//
//  Created by art on 9/4/13.
//  Copyright (c) 2013 Gaurdanis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealityChecker.h"
#import "GlobalStuff.h"

@protocol RealityCheckerCellDelegate;




@interface RealityCheckerCell : UITableViewCell{
    
    RealityChecker *realityChecker;
    UIImageView *backgroundImageView;
    UIButton *onOffButton;
    UIButton *vibrateButton;
    UIButton *selectMusicButton;
    UIButton *leftDateButton;
    UIButton *rightDateButton;
    UILabel *divider;
    UIDatePicker *datepicker;
    UIPopoverController *popOverForDatePicker;

    
}
@property (nonatomic, retain) UILabel *divider;
@property (nonatomic, retain) RealityChecker *realityChecker;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIButton *onOffButton;
@property (nonatomic, retain) UIButton *vibrateButton;
@property (nonatomic, retain) UIButton *selectMusicButton;
@property (nonatomic, retain) UIButton *leftDateButton;
@property (nonatomic, retain) UIButton *rightDateButton;

@property(nonatomic, assign) id <RealityCheckerCellDelegate> delegate;

@end

@protocol RealityCheckerCellDelegate <NSObject>
// recipe == nil on cancel

-(void)openPopup:(BOOL *)open;
@end
