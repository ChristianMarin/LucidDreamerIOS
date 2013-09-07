


#import "JournalCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface JournalCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_titleLabelFrame;
- (CGRect)_dateLabelFrame;
- (CGRect)_bodyLabelFrame;
- (CGRect)_backgroundImageViewFrame;

@end


#pragma mark -
#pragma mark FAQCustomCell implementation

@implementation JournalCell

@synthesize entry, dateLabel, titleLabel, imageView, backgroundImageView, bodyLabel, extendableCell, longPressRecognizer;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:backgroundImageView];

        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:titleLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [dateLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        [dateLabel setTextColor:[UIColor blackColor]];
        [dateLabel setHighlightedTextColor:[UIColor whiteColor]];
        [dateLabel setTextAlignment:UITextAlignmentCenter];
        [self.contentView addSubview:dateLabel];
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imageView];
    
        
        bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [bodyLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [bodyLabel setTextColor:[UIColor whiteColor]];
        [bodyLabel setHighlightedTextColor:[UIColor clearColor]];
        [bodyLabel setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:bodyLabel];
        
    }
    self.contentView.backgroundColor = [UIColor blackColor];
    return self;
}


#pragma mark -
#pragma mark Laying out subviews


- (void)layoutSubviews {
    [super layoutSubviews];
	
    
    [imageView setFrame:[self _imageViewFrame]];
    [titleLabel setFrame:[self _titleLabelFrame]];
    [dateLabel setFrame:[self _dateLabelFrame]];
    [bodyLabel setFrame:[self _bodyLabelFrame]];
    [backgroundImageView setFrame:[self _backgroundImageViewFrame]];
    
}


#define IMAGE_SIZE          40.0
#define TEXT_LEFT_MARGIN    8.0
#define DATE_RIGHT_MARGIN   8.0
#define DATE_WIDTH 17.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_backgroundImageViewFrame {
    
    
    CGFloat cellheight;
    
    if (!self.extendableCell){
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        NSString *test = @"10";
        // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
        CGSize labelSize = [titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:19.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        cellheight = labelSize.height;
        if(labelSize.height < 60.0){
            cellheight = 60.0;
        }else{
            cellheight = cellheight + 5.0;
        }
        
        return CGRectMake(0, 0, self.contentView.bounds.size.width, cellheight);
    }
    return CGRectMake(0, 0, 0, 0);
    
    
    
}

- (CGRect)_imageViewFrame {
    
     
    if (self.extendableCell == NO){
        
        CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - 47.0, self.contentView.bounds.size.height/2 - IMAGE_SIZE/2, IMAGE_SIZE, IMAGE_SIZE);
        
    }
    
    else
        return CGRectMake(0, 0, 0, 0);
}

- (CGRect)_titleLabelFrame {
        
    CGFloat cellheight;
    
    if (!self.extendableCell){
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        
        // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
        CGSize labelSize = [titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:19.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        cellheight = labelSize.height;
        if(labelSize.height < 44.0){
            cellheight = 44.0;
        }
        
        return CGRectMake(10, self.contentView.bounds.size.height/2 - cellheight/2 , self.contentView.bounds.size.width - IMAGE_SIZE - DATE_RIGHT_MARGIN - TEXT_LEFT_MARGIN - DATE_WIDTH - 11.0, cellheight);
    }
     return CGRectMake(0, 0, 0, 0);   
}

- (CGRect)_dateLabelFrame {
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    NSString *test = @"10";
    // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
    CGSize labelSize = [dateLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
        
        if (self.extendableCell == NO) {
            
            return CGRectMake((imageView.frame.origin.x + IMAGE_SIZE/2) - labelSize.width/2 - 1, self.contentView.bounds.size.height/2 - labelSize.height/2 , labelSize.width, labelSize.height);
        
        }
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect)_bodyLabelFrame {
    
    
    if(self.extendableCell == YES){
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
    CGSize labelSize = [bodyLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return CGRectMake( 25 , 10, 320.0 - 50, labelSize.height);
    }
    return CGRectMake(0, 0, 0, 0);
}



-(void)setEntry:(JournalEntry *)item
{
    
        
    if(!self.extendableCell ){
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    titleLabel.textColor = [GlobalStuff mainColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = item.title;
    titleLabel.numberOfLines = 0;
        
    bodyLabel.text = nil;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [GlobalStuff mainColor];
    
        
    NSDate *currentDate = [item date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; 
       
        if ([components day] < 10) {
           self.dateLabel.frame = CGRectMake(self.contentView.frame.size.width - 36.0, self.contentView.frame.size.height/2 - dateLabel.frame.size.height/2 + 5, dateLabel.frame.size.width, dateLabel.frame.size.height);
        }
        else{
            self.dateLabel.frame = CGRectMake(self.contentView.frame.size.width - 36.0, self.contentView.frame.size.height/2 - dateLabel.frame.size.height/2 , dateLabel.frame.size.width, dateLabel.frame.size.height);
        }
    
    dateLabel.text = [NSString stringWithFormat:@"%i",[components day]];
    backgroundImageView.image = [UIImage imageNamed:@"journal_item_bg.png"];
        
    if(item.lucid == [NSNumber numberWithInt:0])
    imageView.image = [UIImage imageNamed:@"journal_lucid_false.png"];

    else
        imageView.image = [UIImage imageNamed:@"journal_lucid_true_blue.png"];
    }
    else{
        
        bodyLabel.text = item.notes;
        bodyLabel.numberOfLines = 0;
        bodyLabel.textColor = [GlobalStuff mainColor];
        bodyLabel.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
        self.contentView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
        dateLabel.text = Nil;
        imageView.image = Nil;
        titleLabel.text = Nil;
    }
    
}


-(void)setLongPressRecognizer:(UILongPressGestureRecognizer *)newLongPressRecognizer {
    
    if (longPressRecognizer != newLongPressRecognizer) {
        
        if (longPressRecognizer != nil) {
            [self removeGestureRecognizer:longPressRecognizer];
        }
        
        if (newLongPressRecognizer != nil) {
            [self addGestureRecognizer:newLongPressRecognizer];
        }
        
        longPressRecognizer = newLongPressRecognizer;
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
