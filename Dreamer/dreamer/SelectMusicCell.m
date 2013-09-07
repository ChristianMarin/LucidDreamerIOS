//
//  HelpCell.m
//  LucidDreamer
//


#import "SelectMusicCell.h"

@implementation SelectMusicCell
@synthesize backgroundImageView, titleLabel, subTitleLabel, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:backgroundImageView];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
        [titleLabel setTextColor:[GlobalStuff mainColor]];
        [titleLabel setHighlightedTextColor:[GlobalStuff mainColor]];
        [self.contentView addSubview:titleLabel];
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        
    }
    
    
    
    
    return self;

}

- (void)layoutSubviews {
    [super layoutSubviews];
	
    
    
    
    [backgroundImageView setFrame:[self _backgroundImageViewFrame]];
    [imageView setFrame:[self _imageViewFrame]];
    [titleLabel setFrame:[self _titleLabelFrame]];
    
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    
}

#define IMAGE_SIZE          42.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   8.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_backgroundImageViewFrame {
    
    
        return CGRectMake(0, 0, self.contentView.bounds.size.width, 55.0);
    
    
}


- (CGRect)_imageViewFrame {
    
    
    return CGRectMake(10.0, self.contentView.bounds.size.height/2 - IMAGE_SIZE/2 , IMAGE_SIZE, IMAGE_SIZE);
    
}

- (CGRect)_titleLabelFrame {
    
    return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0, self.contentView.bounds.size.height/2 - 15/2, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 , 15.0);

    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = [GlobalStuff mainColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
