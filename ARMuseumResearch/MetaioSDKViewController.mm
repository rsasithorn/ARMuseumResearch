//
//  MetaioSDKViewController.m
//  metaio SDK
//
// Copyright 2007-2014 metaio GmbH. All rights reserved.
//
#import "MetaioSDKViewController.h"

#include <metaioSDK/IGeometry.h>
#include <metaioSDK/STLCompatibility.h>
#include <metaioSDK/SensorsComponentIOS.h>

#import <QuartzCore/QuartzCore.h>

#import "EAGLView.h"



@interface MetaioSDKViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
@end



@implementation MetaioSDKViewController
@synthesize closeButton;
@synthesize glView;
@synthesize animating, context, displayLink;


#pragma mark - UIViewController lifecycle

- (void)dealloc
{
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    // delete sdk instance
    if( m_metaioSDK )
    {
        delete m_metaioSDK;
        m_metaioSDK = NULL;
    }
    
    // delete our sensors component
    if( m_sensors )
    {
        delete m_sensors;
        m_sensors = NULL;
    }
    
    [context release];
    
    [glView release];
    [super dealloc];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    if( !context )
    {
        EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!aContext)
            NSLog(@"Failed to create ES context");
        else if (![EAGLContext setCurrentContext:aContext])
            NSLog(@"Failed to set ES context current");
        
        self.context = aContext;
        [aContext release];
    }
    
    
    // set the openGL context
    [glView setContext:context];
    [glView setFramebuffer];
    animating = FALSE;
    self.displayLink = nil;

	// In case you need a transparent GL view, e.g. with the SDK's see-through mode, uncomment the
	// following lines:
	// glView.opaque = false;
	// glView.backgroundColor = [UIColor clearColor];
    
    // limit OpenGL framerate to 30FPS, as the camera has a maximum of 30FPS anyway
    animationFrameInterval = 2;
    
    
	// Get the license string from the plist file
    NSString* sdkLicense = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MetaioLicenseString"];

    // Create metaio SDK instance
    m_metaioSDK = metaio::CreateMetaioSDKIOS([sdkLicense UTF8String]);
    if( !m_metaioSDK )
    {
        NSLog(@"SDK instance could not be created. Please verify the signature string");
        return;
    }

	// Listen to app pause/resume events because in those events we have to pause/resume the SDK
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(onApplicationWillResignActive:)
	 name:UIApplicationWillResignActiveNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(onApplicationDidBecomeActive:)
	 name:UIApplicationDidBecomeActiveNotification
	 object:nil];

    m_sensors = new metaio::SensorsComponentIOS();
    if( !m_sensors )
    {
        NSLog(@"Could not create the sensors interface.");
        return;
    }
    m_metaioSDK->registerSensorsComponent( m_sensors );

    // initialize rendered for our sdk instance
    float scaleFactor = [UIScreen mainScreen].scale;
    metaio::Vector2d screenSize;
    screenSize.x = self.glView.bounds.size.width * scaleFactor;
    screenSize.y = self.glView.bounds.size.height * scaleFactor;

    m_metaioSDK->initializeRenderer(screenSize.x, screenSize.y, metaio::getScreenRotationForInterfaceOrientation(self.interfaceOrientation), metaio::ERENDER_SYSTEM_OPENGL_ES_2_0, context);
    
    // necessary for requesting screenshots
    m_metaioSDK->setRendererFrameBuffers([glView getDefaultFrameBuffer], [glView getColorRenderBuffer]);
    
    
    // register our callback method for animations
    m_metaioSDK->registerDelegate(self);
        
}


- (void) startCamera
{
    if( m_metaioSDK )
    {
		metaio::stlcompat::Vector<metaio::Camera> cameras = m_metaioSDK->getCameraList();
		if (!cameras.empty())
		{
			m_metaioSDK->startCamera(cameras[0]);
		} else {
			NSLog(@"No Camera Found");
		}
    }
}

- (void)viewWillAppear:(BOOL)animated
{	
    [super viewWillAppear:animated];
    
	// if the renderer appears we start rendering and capturing the camera
    [self startAnimation]; 
    [self startCamera];
    
    // if we start up in landscape mode after having portrait before, we want to make sure that the renderer is rotated correctly
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;    
    [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0];
}



- (void) viewDidAppear:(BOOL)animated
{	
	[super viewDidAppear:animated];

}


- (void)viewWillDisappear:(BOOL)animated
{
	// as soon as the view disappears, we stop rendering and stop the camera
    [self stopAnimation];	
    if( m_metaioSDK )
    {
        m_metaioSDK->stopCamera();
    }
    
    [super viewWillDisappear:animated];	
}


- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setGlView:nil];
    [self setCloseButton:nil];
    [self setGlView:nil];

	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:UIApplicationWillResignActiveNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:UIApplicationDidBecomeActiveNotification
	 object:nil];

    [super viewDidUnload];
}


- (void)onApplicationWillResignActive:(NSDictionary*)userInfo
{
	if (m_metaioSDK)
		m_metaioSDK->pause();
}


- (void)onApplicationDidBecomeActive:(NSDictionary*)userInfo
{
	if (m_metaioSDK)
		m_metaioSDK->resume();
}


- (void) viewDidLayoutSubviews
{
	float scale = [UIScreen mainScreen].scale;
	m_metaioSDK->resizeRenderer(self.glView.bounds.size.width*scale, self.glView.bounds.size.height*scale);
}


// Force fullscreen without status bar on iOS 7
- (BOOL)prefersStatusBarHidden
{
	return YES;
}


#pragma mark - Rotation handling


// pre-iOS 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // allow rotation in all directions
    return [self shouldAutorotate] && ([self supportedInterfaceOrientations] & (1 << toInterfaceOrientation));
}


// iOS 6+
- (BOOL)shouldAutorotate
{
	return YES;
}


// iOS 6+
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}


// We will keep the renderer always in the same orientation
// However, if the interface changes, we need to compensate the UI rotation by applying an inverse rotation
// This method is also being called on viewWillAppear
//
// If you don't want your interface to rotate, just return 'NO' in shouldAutorotateToInterfaceOrientation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // adjust the rotation based on the interface orientation
    m_metaioSDK->setScreenRotation( metaio::getScreenRotationForInterfaceOrientation(interfaceOrientation) ); 
    
    // on ios5, we handle this in didLayoutSubView
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if( version < 5.0)
	{
		float scale = [UIScreen mainScreen].scale;
		m_metaioSDK->resizeRenderer(self.glView.bounds.size.width*scale, self.glView.bounds.size.height*scale);
	}
}




#pragma mark - Handling Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Implement if you need to handle touches
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Implement if you need to handle touches
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Implement if you need to handle touches
}

#pragma mark - @protocol MetaioSDKDelegate

- (void) onAnimationEnd: (metaio::IGeometry*) geometry  andName:(NSString*) animationName
{
    // Implement if you want to react to animation callbacks
}

- (void) onSDKReady
{
    // implement if there's a need to react when the SDK is ready
}


- (void) onNewCameraFrame:(metaio::ImageStruct *)cameraFrame
{
    // implement if you want to react to this event
    // (request an image using m_metaioSDK->requestCameraImage)
}

- (void) onCameraImageSaved: (NSString*) filepath
{
}

- (void) onRenderEvent:(metaio::IGeometry*)geometry renderEvent:(const metaio::RenderEvent&)renderEvent
{
    // Implement if you want to handle render events
}

-(void) onScreenshot:(NSString*) filepath
{
}

- (void) onScreenshotImageIOS:(UIImage *)image
{
}

- (void) onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues>&)trackingValues
{
}

- (void) onInstantTrackingEvent:(bool)success file:(NSString*)file
{
    
}

- (void) onVisualSearchResult:(const metaio::stlcompat::Vector<metaio::VisualSearchResponse>&)response errorCode:(int)errorCode
{
    
}

- (void) onVisualSearchStatusChanged:(metaio::EVISUAL_SEARCH_STATE)state
{
    
}

#pragma mark - OpenGL related
//
// You usually don't have to change anything for the methods below
//

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating) {
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}

- (void)drawFrame
{
    [glView setFramebuffer];
    
    // tell sdk to render
    if( m_metaioSDK )
    {
        m_metaioSDK->render();    
    }
    
    [glView presentFramebuffer];
}


- (IBAction)onBtnClosePushed:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
