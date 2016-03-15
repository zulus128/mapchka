//
//  AppDelegate.m
//  Mapochka
//
//  Created by Nikita Anisimov on 1/30/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "IntroLayer.h"
#import <AVFoundation/AVAudioSession.h>
#import "UIDevice+IdentifierAddition.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

static AppController *instance;

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;


+(AppController *)appController{
    return instance;
}

-(void)saveStat{
    [self.gameStatistics writeToFile:documentFullPath(@"statistic.plist") atomically:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    instance = self;
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"3B52KTZPDTWZHVC4WPTW"];
    //load statisctic
    
    self.gameStatistics = [NSArray arrayWithContentsOfFile:documentFullPath(@"statistic.plist")];
    
    if (!self.gameStatistics){
        self.gameStatistics = [NSMutableArray array];
        for (int i=0; i<20; i++){
            [self.gameStatistics addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"count", [NSNumber numberWithInt:0], @"time", nil]];
        }
    }
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:GL_DEPTH_COMPONENT16	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	director_.wantsFullScreenLayout = YES;
    
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
    
	// attach the openglView to the director
	[director_ setView:glView];
    
	// for rotation and other messages
	[director_ setDelegate:self];
    
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    //	[director setProjection:kCCDirectorProjection3D];
    
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  :@"-ipadhd",@"-ipad", @"-hd"
	// On iPad     :@"-ipad",@"-hd"
	// On iPhone HD:@"-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is@"-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is@"ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is@"-ipadhd"
    
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]];
    
	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
    //	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    //set audio session
    NSError *error=nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
        NSLog(@"Unable to set session category:\n%@", error);
	[application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeSound];
    
    [Fabric with:@[[Crashlytics class]]];

	return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *str = [NSString stringWithFormat:@"Device Token=%@", deviceToken];
	NSLog(@"deviceTok = %@", str);
	NSMutableString *deviceTokStr = [NSMutableString stringWithFormat:@"%@", deviceToken];
	NSString *token = [NSString stringWithFormat:@"%@", [deviceTokStr stringByReplacingOccurrencesOfString:@"@" withString:@""]];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	[self sendProviderDeviceToken:token];
}

- (void)sendProviderDeviceToken:(NSString*)str {
	CFStringRef tokenRef=CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	NSString *token= (__bridge NSString *)tokenRef;
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([appVersion length] == 0)
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *urlStr = [NSString stringWithFormat:@"http://portal.moslight.com/mapochka/updateUserInfo.php?push_token=%@&id=%@&appVersion=%@",
                        token,
                        [[UIDevice currentDevice] uniqueDeviceIdentifier],
                        appVersion];
    
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:queue
						   completionHandler:^(NSURLResponse *resp, NSData *data, NSError *  err) {
                               NSLog(@"resp = %@", resp);
                               NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               NSLog(@"err = %@", err);
						   }];
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    [application cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    [[SimpleAudioEngine sharedEngine] playEffect:@"byu_byu.wav"];
    //    UILocalNotification *local = [[UILocalNotification alloc] init];
    //    local.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    //    local.timeZone  = [NSTimeZone systemTimeZone];
    //    local.soundName = @"I_missing.wav";
    //    local.applicationIconBadgeNumber = 1;
    //    local.alertBody = @"Я скучаю по тебе..";
    //    [application scheduleLocalNotification:local];
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
    [application cancelAllLocalNotifications];
    
    NSArray *pushes =@[
                       @{@"day" : @(7), @"month" : @(1),
                         @"text" :@"Как рассказать малышу о доброте и любви? Показывайте то, где живет любовь. Дети чувствуют любовь, заботу и доброту, с которой создавалось это приложение."},
                       
                       
                       @{@"day" : @(18), @"month" : @(1),
                         @"text" :@"Собирают ли дети пирамидку в год? Когда пора сажать на горшочек? Огромная подробнейшая статья уже у Мапочки от детского психолога."},
                       
                       @{@"day" : @(16), @"month" : @(2),
                         @"text" :@"Единственная методика, которая творит чудеса - это мамина любовь, уважение природы ребёнка и тотальное принятие)"},
                       
                       @{@"day" : @(23), @"month" : @(2),
                         @"text" :@"Любовь папы - уникальна, особенна. Тот, который защитит, объяснит и научит, с кем можно баловаться и говорить на волнующие темы."},
                       
                       @{@"day" : @(1), @"month" : @(3),
                         @"text" :@"Малыши с восторгом наблюдают как оживает природа весной. Как звонко чирикает их любимый герой - воробушек! а вы нашли где он прячется?)"},
                       
                       @{@"day" : @(8), @"month" : @(3),
                         @"text" :@"Мамочки, от всех детских сердец, мы благодарим вас за то, что дарите нам своё время, любите безусловно, прощаете, встаёте по ночам, терпите боль и всё равно улыбаетесь. Спасибо вам!"},
                       
                       @{@"day" : @(18), @"month" : @(3),
                         @"text" :@"Хотите посмотреть, в какую игру ваш малыш играет чаще всего? Загляните в статистику и начинайте играть в любимых героев в реальной жизни)"},
                       
                       @{@"day" : @(1), @"month" : @(4),
                         @"text" :@"Нешуточная методика приучения к горшочку)"},
                       
//                       //test
//#warning TEST PUSH MESSAGE
//                       @{@"day" : @(19), @"month" : @(4),
//                         @"text" :@"Мамочки, от всех детских сердец, мы благодарим вас за то, что дарите нам своё время, любите безусловно, прощаете, встаёте по ночам, терпите боль и всё равно улыбаетесь. Спасибо вам!"},
//                       //test
                       
                       @{@"day" : @(29), @"month" : @(4),
                         @"text" :@"Как поесть шашлык спокойно, не боясь, что малыш решит исследовать огонь? Мамочки особенно рекомендуют раскраски в приложении Мапочка."},
                       
                       @{@"day" : @(18), @"month" : @(5),
                         @"text" :@"Лететь на отдых с Мапочкой - счастье для детишек и минутки спокойствия для родителей)"},
                       
                       @{@"day" : @(1), @"month" : @(6),
                         @"text" :@"Привилегия - находиться рядом с ребёнком! Создавать сказку для детей - трепетно, волшебно."},
                       
                       @{@"day" : @(29), @"month" : @(6),
                         @"text" :@"Хохочут и взрослые, и детки, рассаживая любимых персонажей на горшочки. Время в дороге пролетает незаметно) Вы уже попробовали?)"},
                       
                       @{@"day" : @(29), @"month" : @(7),
                         @"text" :@"Кто не любит кушать кашку? Смотря как кушает котёнок, малыши с радостью съедают свою порцию, подражая любимому герою."},
                       
                       @{@"day" : @(18), @"month" : @(8),
                         @"text" :@"Уход ребенка ко сну - важнейший ритуал. Помогите малышу уложить тигрёнка спать, погладив его, укройте одеялком и пожелайте добрых снов)"},
                       
                       @{@"day" : @(18), @"month" : @(9),
                         @"text" :@"Любые знания малыш схватывает моментально, находясь в атмосфере поддержки, добра и любви."},
                       
                       @{@"day" : @(18), @"month" : @(10),
                         @"text" :@"Природа сама рассказывает малышам об осени. Дотронуться до капелек, уловить листочек - малыши увлечённо играют с Мапочкой."},
                       
                       @{@"day" : @(18), @"month" : @(11),
                         @"text" :@"Спящие животные пробуждают в малышах самые добрые чувства, заботу. Уложите спать тигрёнка, накрыв одеялком."},
                       
                       @{@"day" : @(1), @"month" : @(12),
                         @"text" :@"Детишки любят гулять, но не любят одеваться. Знакомо и вам? Одевая любимых героев Мапочки, малыши одеваются заметно лучше)"},
                       
                       @{@"day" : @(27), @"month" : @(12),
                         @"text" :@"Снежинки на окнах, борода из ваты... Напомните малышу покормить в новогоднюю ночь любимого Тигрёнка волшебной кашкой)"}
                       ];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:12];
    [components setMinute:0];
    NSDate *now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:now];
    [components setYear:[ageComponents year]];
    NSMutableArray *pushArray = [NSMutableArray array];
    for (NSDictionary *push in pushes.reverseObjectEnumerator) {
        [components setDay:[push[@"day"] intValue]];
        [components setMonth:[push[@"month"] intValue]];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        if([now compare:date] == NSOrderedAscending)
            [pushArray addObject:@{@"date" : date, @"text" : push[@"text"]}];
        else{
            [components setYear:components.year + 1];
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
            [pushArray addObject:@{@"date" : date, @"text" : push[@"text"]}];
        }
    }
    for (NSDictionary *dict in pushArray) {
        UILocalNotification *local = [[UILocalNotification alloc] init];
        local.timeZone  = [NSTimeZone defaultTimeZone];
        local.fireDate = dict[@"date"];
        local.alertBody = dict[@"text"];
        [application scheduleLocalNotification:local];
        NSLog(@"UILocalNotification = %@", local);
    }
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
    MDSendCollectedLogs();
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
    
	[super dealloc];
}
@end

