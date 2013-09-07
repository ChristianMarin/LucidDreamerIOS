//
//  StatsCell.m
//  LucidDreamer
//


#import "StatsCell.h"

@implementation StatsCell
@synthesize imageView;
@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize dateLabel;
@synthesize calendar;
@synthesize openDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        openDate = [[UIButton alloc] initWithFrame:CGRectZero];
        openDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:openDate];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:22.0]];
        [titleLabel setTextColor:[GlobalStuff mainColor]];
        [titleLabel setHighlightedTextColor:[GlobalStuff mainColor]];
        [self.contentView addSubview:titleLabel];
        
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [subTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        [subTitleLabel setTextColor:[GlobalStuff mainColor]];
        [subTitleLabel setHighlightedTextColor:[GlobalStuff mainColor]];
        [self.contentView addSubview:subTitleLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        [dateLabel setTextColor:[GlobalStuff mainColor]];
        [dateLabel setHighlightedTextColor:[GlobalStuff mainColor]];
        [self.contentView addSubview:dateLabel];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        calendar = [[UIImageView alloc] initWithFrame:CGRectZero];
		calendar.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:calendar];

        
    
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
    
    
    
   
    [imageView setFrame:[self _imageViewFrame]];
    [titleLabel setFrame:[self _titleLabelFrame]];
    [subTitleLabel setFrame:[self _subTitleLabelFrame]];
    [calendar setFrame:[self _calendarFrame]];
    [dateLabel setFrame:[self _dateLabelFrame]];
    [openDate setFrame:[self _buttonFrame]];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
  
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    dateLabel.backgroundColor = [UIColor clearColor];
}

#define IMAGE_SIZE          42.0
#define CALENDER_IMAGE_SIZE 35.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   8.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_buttonFrame {
    
    
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0 + CALENDER_IMAGE_SIZE + 5.0, 80, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 - CALENDER_IMAGE_SIZE - 5.0 - 100, 40);
    
}

- (CGRect)_imageViewFrame {
    
    
    return CGRectMake(10.0, 10.0 , IMAGE_SIZE, IMAGE_SIZE);
    
}

- (CGRect)_titleLabelFrame {
    
    
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0, 31 - 10, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 , 20.0);
    
    
}

- (CGRect)_subTitleLabelFrame{
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 9.0, 50, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 , 20);
}

- (CGRect)_dateLabelFrame{
    
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0 + CALENDER_IMAGE_SIZE + 5.0, 90, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 - CALENDER_IMAGE_SIZE - 5.0 , 20);
    
}

- (CGRect)_calendarFrame{
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0, 80, 35 , 35);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
