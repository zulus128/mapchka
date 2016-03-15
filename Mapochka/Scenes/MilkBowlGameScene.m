//
//  MilkBowlGameScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/4/13.
//
//

#import "MilkBowlGameScene.h"
#import <AVFoundation/AVFoundation.h>
#import "SimpleAudioEngine.h"

static int gameId = LOG_GAME_CAT_2;

@interface MilkBowlGameScene (){
//    CCSprite *backBtn;
    CCSprite *bowl;
    CCSprite *milk;
    BOOL allow_touch;
}

@end

@implementation MilkBowlGameScene

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    MilkBowlGameScene *layer=[MilkBowlGameScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
        bowl=[CCSprite spriteWithFile:@"bowl.png"];
        [bowl setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bowl];
        milk=[CCSprite spriteWithFile:@"milkBig.png"];
        [milk setPosition:ccp(s.width/2 + 5, s.height/2)];
        [self addChild:milk];
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"Deallocing MilkBowlGame");
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"CatGame2" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_2, YES);
}


-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"2.1 VTarelke.wav"];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allow_touch = YES;
    });
}
-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"CatGame2" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_2);
}

#pragma mark - Touch handling

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [self convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(bowl.boundingBox, loc)?YES:NO;
}

//-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//    
//}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!allow_touch)
        return;
    allow_touch = NO;
    
    milk.visible=!milk.visible;
    if (milk.visible){
        [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 Est.wav"];
    }else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"2.2 Oi.wav"];
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allow_touch = YES;
    });
}

@end
