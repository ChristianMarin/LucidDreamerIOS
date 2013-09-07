//
//  StatsCell.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"

@interface StatsCell : UITableViewCell{
  
    UIImageView *imageView;
    UIImageView *calendar;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UILabel *dateLabel;
    UIButton *openDate;
   
    
}
@property (nonatomic, retain) UIButton *openDate;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *calendar;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property(nonatomic) CGFloat cellHeight;

@end
