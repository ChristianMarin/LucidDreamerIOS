//
//  JournalEntry.h
//  LucidDreamer
//




@interface JournalEntry : NSManagedObject
{
    
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) NSNumber *lucid;
@property (nonatomic) NSInteger *month;
@property (nonatomic) NSInteger *year;


@end

