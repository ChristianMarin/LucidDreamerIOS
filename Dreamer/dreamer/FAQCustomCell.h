//
//  FAQCustomCell.h
//  LucidDreamer
//


#import <UIKit/UIKit.h>
#import "GlobalStuff.h"



@interface FAQCustomCell : UITableViewCell
{
    NSString *question;
    BOOL extendableCell;
    UIImageView *imageView;
    UIImageView *backgroundImageView;
    UILabel *titleLabel;
    
    
    
}

@property (nonatomic, retain) NSString *question;
@property (nonatomic) BOOL extendableCell;


@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UILabel *titleLabel;

@end
