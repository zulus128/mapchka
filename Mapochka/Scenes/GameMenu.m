//
//  GameMenu.m
//  Mapochka
//
//  Created by Nikita Anisimov on 2/20/13.
//
//

#import "MainMenu.h"
#import "GameMenu.h"
#import "WalkingCat.h"
#import "MilkBowlGameScene.h"
#import "MomSonCatScene.h"
#import "StudyCattyScene.h"
#import "BigSmallScene.h"
#import "StayLieSitCatScene.h"
#import "BirdGame1Scene.h"
#import "BirdGame2Scene.h"
#import "BirdGame3Scene.h"
#import "BirdGame4Scene.h"
#import "BirdGame5Scene.h"
#import "BirdGame6Scene.h"
#import "ToiletsGame1Scene.h"
#import "ToiletsGame2Scene.h"
#import "ToiletsGame3Scene.h"
#import "ToiletsGame4Scene.h"
#import "ToiletsGame5Scene.h"
#import "ScalingMenuItemSprite.h"

@interface GameMenu (){
    
}

@property (nonatomic,readwrite) kMenuTheme theme;

-(void)createMenu;

@end

@implementation GameMenu
@synthesize theme=_theme;

-(void)setType:(kMenuTheme)theme{
    _theme=theme;
}

+(CCScene *)sceneWithTheme:(kMenuTheme)theme{
    CCScene *scene=[CCScene node];
    GameMenu *layer=[GameMenu node];
    [layer setTheme:theme];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        //arrows
        CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        }];
        CCSprite *next=[CCSprite spriteWithFile:@"homeButton.png"];
        ScalingMenuItemSprite *nextItem=[ScalingMenuItemSprite itemWithNormalSprite:next selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]]];
        }];
        CCMenu *navMenu=[CCMenu menuWithItems:backItem, nextItem, nil];
        [navMenu setPosition:ccp(s.width/2, s.height-65)];
        [navMenu alignItemsHorizontallyWithPadding:780.0];
        [self addChild:navMenu];
        
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"Deallocing game menu");
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
    if (![self getChildByTag:50]){
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:(self.theme==kMenuWalkingCat?@"catGameBg.jpg":@"birdGameBg.jpg")];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1 tag:50];
        [self createMenu];
    }
}

-(void)onExit{
    [super onExit];
}

-(void)onEnterTransitionDidFinish{
    [Flurry logEvent:@"EnterGameMenu"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menus.mp3"];
}

-(void)onExitTransitionDidStart{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

-(void)createMenu{
    ScalingMenuItemSprite *one, *two, *three, *four, *five, *six;
    switch (_theme) {
        case kMenuWalkingCat:
            one=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame1.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BigSmallScene scene]]];
            }];
            two=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame2.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[WalkingCat scene]]];
            }];
            three=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame3.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MilkBowlGameScene scene]]];
            }];
            four= [ScalingMenuItemSprite itemWithBlock:^(id sender){}];//[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame4.png"] selectedSprite:nil block:^(id sender){
//                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MomSonCatScene scene]]];
//            }];
            five=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame5.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StudyCattyScene scene]]];
            }];
            six=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"catGame6.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StayLieSitCatScene scene]]];
            }];
            break;
        case kMenuSparrow:
            one=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame1.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdGame1Scene scene]]];
            }];
            two=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame2.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdGame2Scene scene]]];
            }];
            three=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame3.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdGame5Scene scene]]];
            }];
            four=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame4.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:.5 scene:[BirdGame3Scene scene]]];
            }];
            five=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame5.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdGame4Scene scene]]];
            }];
            six=[ScalingMenuItemSprite itemWithBlock:^(id sender){}];
//            six=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"birdGame6.png"] selectedSprite:nil block:^(id sender){
//                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdGame6Scene scene]]];
//            }];
            break;
        case kMenuToilets:
            one=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"toiletGame1.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletsGame5Scene scene]]];
            }];
            two=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"toiletGame2.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletsGame4Scene scene]]];
            }];
            three=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"toiletGame3.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletsGame1Scene scene]]];
            }];
            four=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"toiletGame4.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletsGame3Scene scene]]];
            }];
            five=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"toiletGame5.png"] selectedSprite:nil block:^(id sender){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletsGame2Scene scene]]];
            }];
            six=[ScalingMenuItemSprite itemWithBlock:^(id sender){}];
            break;
        default:
            break;
    }
    //
    CGSize s=[CCDirector sharedDirector].winSize;
    NSMutableArray *row1=[NSMutableArray array];
    NSMutableArray *row2=[NSMutableArray array];
    [@[one,two,three,four,five,six] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if (obj==nil||[obj tag]==49) return;
        if (idx%2==0) [row2 addObject:obj];
        else [row1 addObject:obj];
    }];
    CCMenu *menu1=[CCMenu menuWithArray:row1];
    float padding1=row1.count==3?40.0:102.0;
    [menu1 alignItemsHorizontallyWithPadding:padding1];
    menu1.position=ccp(s.width/2, 256.0-60.0);
    CCMenu *menu2=[CCMenu menuWithArray:row2];
    float padding2=row2.count==3?40.0:102.0;
    [menu2 alignItemsHorizontallyWithPadding:padding2];
    menu2.position=ccp(s.width/2, 563.0-50.0);
    [self addChild:menu1 z:0];
    [self addChild:menu2 z:0];
}

@end
