//
//  MomSonCatScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "MomSonCatScene.h"

static int gameId = LOG_GAME_CAT_3;

@interface MomSonCatScene (){
    CCSprite *boyWatch;
    CCSprite *boySits;
    CCSprite *boyBend;
    CCSprite *boyLeftHandSit;
    CCSprite *boyRightHandSit;
    CCSprite *boyLeftHandBend;
    CCSprite *boyRightHandBend;
    CCSprite *boyLeftHandToy;
    CCSprite *boyRightHandToy;
    CCSprite *momSits;
    CCSprite *catHead;
}

-(void)createSprites;

@end

@implementation MomSonCatScene

-(void)createSprites{
    
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    MomSonCatScene *layer=[MomSonCatScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:@"mom_cat_son_bg.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];

        
        
        
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
        
        
        boyRightHandSit=[CCSprite spriteWithFile:@"bGame6bRHandSit.png"];
        boyRightHandSit.position=ccp(1541/2, 768-988/2);
        [self addChild:boyRightHandSit];
        
        boyRightHandBend=[CCSprite spriteWithFile:@"bGame6bRHandBend.png"];
        boyRightHandBend.position=ccp(1525/2, 768-916/2);
        boyRightHandBend.visible=NO;
        [self addChild:boyRightHandBend];
        
        boyRightHandToy=[CCSprite spriteWithFile:@"bGame6bRHandToy.png"];
        boyRightHandToy.position=ccp(1527/2, 768-973/2);
        boyRightHandToy.visible=NO;
        [self addChild:boyRightHandToy];
        
        boySits=[CCSprite spriteWithFile:@"bGame6boySits.png"];
        boySits.position=ccp(1564/2, 768-920/2);
        [self addChild:boySits];
        
        boyBend=[CCSprite spriteWithFile:@"bGame6boyBend.png"];
        boyBend.position=ccp(1570/2, 768-912/2);
        boyBend.visible=NO;
        [self addChild:boyBend];
        
        boyWatch=[CCSprite spriteWithFile:@"bGame6boyWatch.png"];
        boyWatch.position=ccp(1552/2, 768-920/2);
        boyWatch.visible=NO;
        [self addChild:boyWatch];
        
        boyLeftHandSit=[CCSprite spriteWithFile:@"bGame6bLHandSit.png"];
        boyLeftHandSit.position=ccp(1643/2, 768-864/2);
        [self addChild:boyLeftHandSit];
        
        boyLeftHandBend=[CCSprite spriteWithFile:@"bGame6bLHandBend.png"];
        boyLeftHandBend.position=ccp(1578/2, 768-826/2);
        boyLeftHandBend.visible=NO;
        [self addChild:boyLeftHandBend];
        
        boyLeftHandToy=[CCSprite spriteWithFile:@"bGame6bLHandToy.png"];
        boyLeftHandToy.position=ccp(1642/2, 768-898/2);
        boyLeftHandToy.visible=NO;
        [self addChild:boyLeftHandToy];
        
        
        catHead=[CCSprite spriteWithFile:@"catHead_front.png"];
        catHead.position=ccp(435, 435);
        catHead.visible=YES;
        [self addChild:catHead];
        
    }
    return self;
}

-(void)onEnter{
    
    [super onEnter];
    [Flurry logEvent:@"CatGame3" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_3, YES);
}

-(void) onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"5.1 Vozmi1.wav"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"5.2 Vozmi2.wav" delayed:4];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"CatGame3" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_3);
}

@end
