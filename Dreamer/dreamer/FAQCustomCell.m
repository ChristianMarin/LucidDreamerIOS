


#import "FAQCustomCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface FAQCustomCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_titleLabelFrame;
@end


#pragma mark -
#pragma mark FAQCustomCell implementation

@implementation FAQCustomCell

@synthesize question, imageView, titleLabel, backgroundImageView, extendableCell;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
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


#pragma mark -
#pragma mark Laying out subviews


- (void)layoutSubviews {
    [super layoutSubviews];
	
    
    
    
    [backgroundImageView setFrame:[self _backgroundImageViewFrame]];
    [imageView setFrame:[self _imageViewFrame]];
    [titleLabel setFrame:[self _titleLabelFrame]];
    
    
    
}


#define IMAGE_SIZE          42.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   8.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_backgroundImageViewFrame {
    
    
    CGFloat cellheight;
    
    if (!self.extendableCell){
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        
        // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
        CGSize labelSize = [titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:19.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        cellheight = labelSize.height;
        if(labelSize.height < 50.0){
            cellheight = 50.0;
        }else{
            cellheight = cellheight + 10.0;
        }
        
        return CGRectMake(0, 0, self.contentView.bounds.size.width, cellheight);
    }
    return CGRectMake(0, 0, 0, 0);
    
    
    
}


- (CGRect)_imageViewFrame {
    
        return CGRectMake(10.0, self.contentView.bounds.size.height/2 - IMAGE_SIZE/2 , IMAGE_SIZE, IMAGE_SIZE);
}

- (CGRect)_titleLabelFrame {
    
    
    if (self.extendableCell == NO) {
        CGSize constraintSize = CGSizeMake(238.0f, MAXFLOAT);
        
        // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
        CGSize labelSize = [titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN + 10.0, self.contentView.bounds.size.height/2 - labelSize.height/2, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - 10 , labelSize.height);
            }
    else{
        CGSize constraintSize = CGSizeMake(238.0f, MAXFLOAT);
        
        // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
        CGSize labelSize = [titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return CGRectMake(20 , self.contentView.bounds.size.height/2 - labelSize.height/2 , 280.0, labelSize.height);
        
    }
    
   
    
}




#pragma mark -
#pragma mark Recipe set accessor

- (void)setQuestion:(NSString *)item{
    titleLabel.text = item;
    titleLabel.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"Help.png"];
    backgroundImageView.image = [UIImage imageNamed:@"journal_entry_group_item_bg.png"];
    
    if (!([item isEqualToString:@"What is Lucid Dreaming?" ] || [item isEqualToString: @"How do I use this app?"] || [item isEqualToString: @"What is a Binaural Beat?"] || [item isEqualToString:@"What is REM sleep?" ] || [item isEqualToString:@"When does REM sleep happen?" ] || [item isEqualToString:@"Why does the default beat only last about 10 seconds?" ] || [item isEqualToString:@"What time should I set the countdown be set to?" ] || [item isEqualToString:@"What should the volume be set to?"] || [item isEqualToString:@"What else can I do to help lucid dream?"] || [item isEqualToString:@"There's no sound!?"] || [item isEqualToString:@"How do I edit a Journal Entry?"] || [item isEqualToString:@"How do I add a new Journal Entry?"]))
    {
        imageView.image = nil;
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        self.contentView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    }
    
         
}

#pragma mark -
#pragma mark Memory management
/*
- (void)dealloc {
    [recipe release];
    [imageView release];
    [nameLabel release];
    [overviewLabel release];
    [prepTimeLabel release];
    [super dealloc];
}
*/
@end
