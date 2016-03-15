//
//  BirdGame4Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/20/13.
//
//

#import "BirdGame4Scene.h"
#include "stdlib.h"
#import "SimpleAudioEngine.h"

#define SUNPOSITION ccp(850, 580)
#define SUNOVERLEFT ccp(390, 550)
#define SUNOVERRIGHT ccp(800, 220)

static int gameId = LOG_GAME_BIRD_3;

@interface BirdGame4Scene (){
    CCSprite *cloudLeft;
    CCSprite *cloudRight;
    Sun *sun;
    CCSprite *hiddenUnder;
    BOOL allowToChoose;
    BOOL allowToHide;
    BOOL firstFide;
    BOOL catchSun;
    CGPoint lastPoint;
    ALuint currentSoundID;
}

-(void)hideSunToLeft:(BOOL)left;
-(void)showSun;

@end

@implementation BirdGame4Scene

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame4Scene *layer=[BirdGame4Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        allowToChoose=NO;
        allowToHide=NO;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"bGame4Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg];
        sun=[Sun node];
        sun.position=SUNPOSITION;
        [sun blink];
        [self addChild:sun];
        cloudLeft=[CCSprite spriteWithFile:@"bGame4Cloud1.png"];
        cloudLeft.position=ccp(270, 550);
        cloudRight=[CCSprite spriteWithFile:@"bGame4Cloud2.png"];
        cloudRight.position=ccp(680, 220);
        [self addChild:cloudLeft];
        [self addChild:cloudRight];
        
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:1];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void)onEnter{
    firstFide = YES;
    //    [self scheduleOnce:@selector(hideSun) delay:2];
    [super onEnter];
    [Flurry logEvent:@"BirdGame3" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_3, YES);
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [self unscheduleAllSelectors];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
    [Flurry endTimedEvent:@"BirdGame3" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_3);
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)whereIsIt{
    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"3.2 GdeSolnyshko.wav"];
}

-(void)hideSunToLeft:(BOOL)left{
    allowToHide=NO;
    id moveSun;
    if (left){
        double distance = sqrt(powf(sun.position.x - SUNOVERLEFT.x, 2) + powf(sun.position.y - SUNOVERLEFT.y, 2));
        moveSun=[CCMoveTo actionWithDuration:distance/900.0 position:SUNOVERLEFT]; hiddenUnder=cloudLeft;
    }else{
        double distance = sqrt(powf(sun.position.x - SUNOVERRIGHT.x, 2) + powf(sun.position.y - SUNOVERRIGHT.y, 2));
        moveSun=[CCMoveTo actionWithDuration:distance/900.0 position:SUNOVERRIGHT]; hiddenUnder=cloudRight;
    }
    [sun runAction:moveSun];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allowToChoose=YES;
        if(firstFide){
            currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"3.1 SolnyshkoSpryatalos.wav"];
            firstFide = NO;
        }else
            currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"3.4 ASeichas.wav"];
        
        [self unschedule:@selector(whereIsIt)];
        [self scheduleOnce:@selector(whereIsIt) delay:5];
    });
}

-(void)showSun{
    double distance = sqrt(powf(sun.position.x - SUNPOSITION.x, 2) + powf(sun.position.y - SUNPOSITION.y, 2));
    id moveSun=[CCMoveTo actionWithDuration:distance/900.0 position:SUNPOSITION];
    [sun runAction:moveSun];
    allowToChoose=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hiddenUnder = nil;
    });
    //    [self scheduleOnce:@selector(hideSun) delay:3.0];
}


#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    lastPoint = [self convertTouchToNodeSpace:touch];
    catchSun = CGRectContainsPoint(CGRectMake(sun.position.x - sun.contentSize.width/2.0 + sun.body.position.x - sun.body.contentSize.width/2.0,
                                              sun.position.y - sun.contentSize.height/2.0 + sun.body.position.y - sun.body.contentSize.height/2.0,
                                              sun.body.contentSize.width,
                                              sun.body.contentSize.height), lastPoint) && !allowToChoose;
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!catchSun)
        return;
    //    CGPoint loc=[self convertTouchToNodeSpace:touch];
    //    sun.position = ccp(sun.position.x - (lastPoint.x - loc.x),
    //                       sun.position.y - (lastPoint.y - loc.y));
    
    lastPoint = [self convertTouchToNodeSpace:touch];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    //    if(catchSun){
    //        sun.position = ccp(sun.position.x - (lastPoint.x - loc.x),
    //                           sun.position.y - (lastPoint.y - loc.y));
    //
    //        if(CGRectContainsPoint(CGRectMake(cloudLeft.position.x - cloudLeft.contentSize.width/2.0,
    //                                          cloudLeft.position.y - cloudLeft.contentSize.height/2.0,
    //                                          cloudLeft.contentSize.width,
    //                                          cloudLeft.contentSize.height),
    //                               sun.position))
    //            [self hideSunToLeft:YES];
    //        else if(CGRectContainsPoint(CGRectMake(cloudRight.position.x - cloudRight.contentSize.width/2.0,
    //                                               cloudRight.position.y - cloudRight.contentSize.height/2.0,
    //                                               cloudRight.contentSize.width,
    //                                               cloudRight.contentSize.height),
    //                                    sun.position))
    //            [self hideSunToLeft:NO];
    //        else
    //            [self showSun];
    //
    //
    //    }
    if(!hiddenUnder){
        if(CGRectContainsPoint(cloudLeft.boundingBox, loc)){
            [self hideSunToLeft:YES];
        }else if(CGRectContainsPoint(cloudRight.boundingBox, loc)){
            [self hideSunToLeft:NO];
        }
    }else if (CGRectContainsPoint(hiddenUnder.boundingBox, loc)&&allowToChoose){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        [self showSun];
        if(rand()%2 == 1)
            [[SimpleAudioEngine sharedEngine] playEffect:@"3.3 VotOno.wav"];
        else
            [[SimpleAudioEngine sharedEngine] playEffect:@"3.5 Pravilno.wav"];
        [self unschedule:@selector(whereIsIt)];
    }
}

@end
