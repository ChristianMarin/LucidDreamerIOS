//
//  CurtainViewController.m
//  LucidDreamer
//



#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://guardanis.com/lucid/database/acc.php?email=domio19922@gmail.com&platform=android"] //2

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0f)

#import "CurtainViewController.h"
#import "MainViewController.h"
#import "MWFSlideNavigationViewController.h"
#import "Reachability.h"

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end




@interface CurtainViewController ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation CurtainViewController
@synthesize managedObjectContext;
@synthesize ring;
@synthesize mainViewController;


- (void)dismissVertical
{
    //MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.mainViewController.managedObjectContext = self.managedObjectContext;
    
    
    MWFSlideNavigationViewController * slideNavCtl = [[MWFSlideNavigationViewController alloc] initWithRootViewController:self.mainViewController];
    
    [self curtainRevealViewController:slideNavCtl transitionStyle:RECurtainTransitionVertical];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"splash_bg.png"]] : [UIColor grayColor];
        
        
    }
   

    return self;
}



- (void)viewDidLoad
{
        
    [super viewDidLoad];
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    //float screenHeight = 568.0f;
     self.ring = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash_ring.png"]];
    if (IS_IPHONE_5) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController5" bundle:nil];
        self.ring.frame = CGRectMake(160 - 105, self.view.bounds.size.height/2 - 137, 210, 210);
    }
    else{
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.ring.frame = CGRectMake(160 - 105, self.view.bounds.size.height/2 - 93, 210, 210);
    }

    
    //[self checkInternet];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissVertical) userInfo:nil repeats:NO];
   
    
    
    [self.view addSubview:self.ring];
    
    [UIView animateWithDuration:2 animations:^(void) {
        ring.alpha = 1;
        ring.alpha = .5;
    }
                     completion:^(BOOL finished){
                         //Appear
                         [UIView animateWithDuration:1.75 animations:^(void) {
                             
                             ring.alpha = .5;
                             
                             ring.alpha = 1;
                         }];
                     }];
    
}

-(void)userData
{
    NSData* data = [NSData dataWithContentsOfURL: kLatestKivaLoansURL];
    
    if(data != nil){
    
    dispatch_async(kBgQueue, ^{
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
 
    }
        
}

-(void)checkInternet
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    internetReachable.reachableBlock = ^(Reachability * reachability)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // blockLabel.text = @"Block Says Reachable";
            
        });
    };
    
    internetReachable.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
           // blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [internetReachable startNotifier];
    
    
    
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        if (!dataSynced) {
           // [self userData];
            dataSynced = !dataSynced;
            
        }
    }
    else
    {
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions
                                                           error:&error];
    
    NSNumber* fullAccess = [json objectForKey:@"full_access"];
       
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:fullAccess forKey:@"fullAccess"];
    [defaults synchronize];
    
   // NSLog(@"%@",json);
    //NSLog(@"%@",[defaults objectForKey:@"fullAccess"]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
}


@end
