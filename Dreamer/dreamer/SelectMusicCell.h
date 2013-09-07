//
//  HelpCell.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"

@interface SelectMusicCell : UITableViewCell
{
   
    UIImageView *imageView;
    UIImageView *backgroundImageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    
    
}


@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;

@end
