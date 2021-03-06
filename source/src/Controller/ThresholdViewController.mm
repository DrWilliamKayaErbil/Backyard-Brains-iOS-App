
#import "ThresholdViewController.h"
//#import "BBBTManager.h"

@interface ThresholdViewController() {
    dispatch_source_t callbackTimer;
}

@end

@implementation ThresholdViewController
@synthesize triggerHistoryLabel;

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Starting threshold view");
    [super viewWillAppear:animated];
    // our CCGLTouchView being added as a subview
    if(glView)
    {
        [glView stopAnimation];
        [glView removeFromSuperview];
        [glView release];
        glView = nil;
    }

    
    
    
    glView = [[MultichannelCindeGLView alloc] initWithFrame:self.view.frame];
    glView.mode = MultichannelGLViewModeThresholding;
    [glView setNumberOfChannels: [[BBAudioManager bbAudioManager] sourceNumberOfChannels ] samplingRate:[[BBAudioManager bbAudioManager] sourceSamplingRate] andDataSource:self];
    [[BBAudioManager bbAudioManager] startThresholding:8192];
	[self.view addSubview:glView];
    [self.view sendSubviewToBack:glView];
	
    // set our view controller's prop that will hold a pointer to our newly created CCGLTouchView
    [self setGLView:glView];
    
    
    [glView loadSettings:TRUE];
    [glView startAnimation];
   /* [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noBTConnection) name:NO_BT_CONNECTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btDisconnected) name:BT_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btSlowConnection) name:BT_SLOW_CONNECTION object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reSetupScreen) name:RESETUP_SCREEN_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [glView saveSettings:TRUE];
    [[BBAudioManager bbAudioManager] saveSettingsToUserDefaults];
    [[BBAudioManager bbAudioManager] stopThresholding];
    [glView stopAnimation];
   /* [[NSNotificationCenter defaultCenter] removeObserver:self name:NO_BT_CONNECTION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BT_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BT_SLOW_CONNECTION object:nil];*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESETUP_SCREEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [glView removeFromSuperview];
    [glView release];
    glView = nil;
   // [super viewWillDisappear:<#animated#>];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


}


-(void) applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"\n\nApp will become active - Threshold\n\n");
    if(glView)
    {
        [glView startAnimation];
        [[BBAudioManager bbAudioManager] startThresholding:8192];
    }
}

-(void) applicationWillResignActive:(UIApplication *)application {
    NSLog(@"\n\nResign active - Threshold\n\n");
    [glView stopAnimation];
    [[BBAudioManager bbAudioManager] stopThresholding];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Terminating from threshold app...");
    [glView saveSettings:TRUE];
    [[BBAudioManager bbAudioManager] saveSettingsToUserDefaults];
    [glView stopAnimation];
    [[BBAudioManager bbAudioManager] stopThresholding];
}




-(void) noBTConnection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Bluetooth connection."
                                                    message:@"Please pair with BYB bluetooth device in Bluetooth settings."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) btDisconnected
{
    if([[BBAudioManager bbAudioManager] btOn])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Bluetooth connection."
                                                        message:@"Bluetooth device disconnected. Get in range of the device and try to pair with the device in Bluetooth settings again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) btSlowConnection
{
    /*if([[BBAudioManager bbAudioManager] btOn])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Slow Bluetooth connection."
                                                        message:@"Bluetooth connection is very slow. Try moving closer to Bluetooth device and start session again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }*/

}


-(void) reSetupScreen
{
    NSLog(@"Resetup screen");
    if(glView)
    {
        [glView stopAnimation];
        [glView removeFromSuperview];
        [glView release];
        glView = nil;
    }
    
    
   
    
    glView = [[MultichannelCindeGLView alloc] initWithFrame:self.view.frame];
    glView.mode = MultichannelGLViewModeThresholding;
    [glView setNumberOfChannels: [[BBAudioManager bbAudioManager] sourceNumberOfChannels ] samplingRate:[[BBAudioManager bbAudioManager] sourceSamplingRate] andDataSource:self];
    [[BBAudioManager bbAudioManager] startThresholding:8192];
    [self.view addSubview:glView];
    [self.view sendSubviewToBack:glView];
    
    // set our view controller's prop that will hold a pointer to our newly created CCGLTouchView
    [self setGLView:glView];
    [glView startAnimation];
}


- (void)setGLView:(MultichannelCindeGLView *)view
{
    glView = view;
    callbackTimer = nil;
}

- (IBAction)updateNumTriggersInThresholdHistory:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    int newHistoryLength = (int)theSlider.value;
    [[BBAudioManager bbAudioManager] setNumTriggersInThresholdHistory:newHistoryLength];
    triggerHistoryLabel.text = [NSString stringWithFormat:@"%dx", newHistoryLength];
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (float) fetchDataToDisplay:(float *)data numFrames:(UInt32)numFrames whichChannel:(UInt32)whichChannel
{
    return [[BBAudioManager bbAudioManager] fetchAudio:data numFrames:numFrames whichChannel:whichChannel stride:1];
}

#pragma mark - selecting

-(BOOL) shouldEnableSelection
{
    return ![[BBAudioManager bbAudioManager] playing];
}

-(void) updateSelection:(float) newSelectionTime timeSpan:(float) timeSpan
{
    [[BBAudioManager bbAudioManager] updateSelection:newSelectionTime timeSpan:1.0f];
}

-(float) selectionStartTime
{
    return [[BBAudioManager bbAudioManager] selectionStartTime];
}

-(float) selectionEndTime
{
    return [[BBAudioManager bbAudioManager] selectionEndTime];
}

-(void) endSelection
{
    [[BBAudioManager bbAudioManager] endSelection];
}

-(BOOL) selecting
{
    return [[BBAudioManager bbAudioManager] selecting];
}

-(float) rmsOfSelection
{
    return [[BBAudioManager bbAudioManager] rmsOfSelection];
}

#pragma mark - Thresholding

-(BOOL) thresholding
{
    return [[BBAudioManager bbAudioManager] thresholding];
}

-(float) threshold
{
    return [[BBAudioManager bbAudioManager] threshold];
}


- (void)setThreshold:(float)newThreshold
{
    [[BBAudioManager bbAudioManager] setThreshold:newThreshold];
}

-(void) selectChannel:(int) selectedChannel
{
    [[BBAudioManager bbAudioManager] selectChannel:selectedChannel];
}


- (void)dealloc {
    [triggerHistoryLabel release]; 
    [super dealloc];
}

- (void)viewDidUnload {
    [triggerHistoryLabel release];
    triggerHistoryLabel = nil;
    [self setTriggerHistoryLabel:nil];
    [super viewDidUnload];
}
@end