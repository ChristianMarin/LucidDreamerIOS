//
//  MMPDeepSleepPreventer.m
//  MMPDeepSleepPreventer
//

#pragma mark -
#pragma mark Imports

#import "MMPDeepSleepPreventer.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


#pragma mark -
#pragma mark MMPDeepSleepPreventer Private Interface

@interface MMPDeepSleepPreventer ()

- (void)mmp_playPreventSleepSound;
- (void)mmp_setUpAudioSession;

@end


@implementation MMPDeepSleepPreventer


#pragma mark -
#pragma mark Synthesizes

@synthesize audioPlayer       = audioPlayer_;
@synthesize preventSleepTimer = preventSleepTimer_;


#pragma mark -
#pragma mark Creation and Destruction

- (id)init
{
	if ( !(self = [super init]) )
		return nil;
	
	[self mmp_setUpAudioSession];
	
	// Set up path to sound file
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"MMPSilence"
	                                                          ofType:@"wav"];
	
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
	
	// Set up audio player with sound file
	audioPlayer_ = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
	                                                      error:nil];
	
	[self.audioPlayer prepareToPlay];
	
    self.audioPlayer.volume = 0.1;
    
    self.audioPlayer.numberOfLoops = -1;
	
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)startPreventSleep
{
	// We need to play a sound at least every 10 seconds to keep the iPhone awake.
	// It doesn't seem to affect battery life how often inbetween these 10 seconds the sound file is played.
	// To prevent the iPhone from falling asleep due to timing/performance issues, we play a sound file every five seconds.
	
	// We create a new repeating timer, that begins firing immediately and then every five seconds afterwards.
	// Every time it fires, it calls -mmp_playPreventSleepSound.
	NSTimer *preventSleepTimer = [[NSTimer alloc] initWithFireDate:[NSDate date]
	                                                      interval:5.0
	                                                        target:self
	                                                      selector:@selector(mmp_playPreventSleepSound)
	                                                      userInfo:nil
	                                                       repeats:YES];
	self.preventSleepTimer = preventSleepTimer;
	
	// Add the timer to the current run loop.
	[[NSRunLoop currentRunLoop] addTimer:self.preventSleepTimer
	                             forMode:NSDefaultRunLoopMode];
}


- (void)stopPreventSleep
{
	[self.preventSleepTimer invalidate];
	self.preventSleepTimer = nil;
}


#pragma mark -
#pragma mark Private Methods

- (void)mmp_playPreventSleepSound
{
	[self.audioPlayer play];
}


- (void)mmp_setUpAudioSession
{
	// Initialize audio session
	AudioSessionInitialize
	(
		NULL, // Use NULL to use the default (main) run loop.
		NULL, // Use NULL to use the default run loop mode.
		NULL, // A reference to your interruption listener callback function.
		      // See “Responding to Audio Session Interruptions” in Apple's "Audio Session Programming Guide" for a description of how to write
		      // and use an interruption callback function.
		NULL  // Data you intend to be passed to your interruption listener callback function when the audio session object invokes it.
	);
	
	// Activate audio session
	OSStatus activationResult = 0;
	activationResult          = AudioSessionSetActive(true);
	
	if (activationResult)
	{
		MMPDLog(@"AudioSession is active");
	}
	
	// Set up audio session category to kAudioSessionCategory_MediaPlayback.
	// While playing sounds using this session category at least every 10 seconds, the iPhone doesn't go to sleep.
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback; // Defines a new variable of type UInt32 and initializes it with the identifier 
	                                                              // for the category you want to apply to the audio session.
	AudioSessionSetProperty
	(
		kAudioSessionProperty_AudioCategory, // The identifier, or key, for the audio session property you want to set.
		sizeof(sessionCategory),             // The size, in bytes, of the property value that you are applying.
		&sessionCategory                     // The category you want to apply to the audio session.
	);
	
	// Set up audio session playback mixing behavior.
	// kAudioSessionCategory_MediaPlayback usually prevents playback mixing, so we allow it here. This way, we don't get in the way of other sound playback in an application.
	// This property has a value of false (0) by default. When the audio session category changes, such as during an interruption, the value of this property reverts to false.
	// To regain mixing behavior you must then set this property again.
	
	// Always check to see if setting this property succeeds or fails, and react appropriately; behavior may change in future releases of iPhone OS.
	OSStatus propertySetError = 0;
	UInt32 allowMixing        = true;
	
	propertySetError = AudioSessionSetProperty
	(
		kAudioSessionProperty_OverrideCategoryMixWithOthers, // The identifier, or key, for the audio session property you want to set.
		sizeof(allowMixing),                                 // The size, in bytes, of the property value that you are applying.
		&allowMixing                                         // The value to apply to the property.
	);
	
	if (propertySetError)
	{
		MMPALog(@"Error setting kAudioSessionProperty_OverrideCategoryMixWithOthers: %ld", propertySetError);
	}
}

@end
