//
//  JournalCell.h
//  LucidDreamer
//




#import <UIKit/UIKit.h>
#import "JournalEntry.h"
#import "GlobalStuff.h"


@interface JournalCell : UITableViewCell
{
    JournalEntry *entry;
    UIImageView *imageView;
    UIImageView *backgroundImageView;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILongPressGestureRecognizer *longPressRecognizer;
    BOOL extendableCell;
    UILabel *bodyLabel;
}

@property (nonatomic, retain) JournalEntry *entry;
@property (nonatomic) BOOL extendableCell;


@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *bodyLabel;

@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end
