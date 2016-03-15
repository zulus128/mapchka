//
//  AppDelegate.h
//  Mapochka
//
//  Created by Nikita Anisimov on 1/30/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, strong) NSMutableArray * gameStatistics;


+(AppController *)appController;
-(void)saveStat;
@end
