//
//  BirdGame6Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/22/13.
//
//

#import "BirdGame6Scene.h"

static int gameId = LOG_GAME_BIRD_6;

@interface BirdGame6Scene (){
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
    CCSprite *momGives;
    CCSprite *momShows;
    CCSprite *momTakes;
    
    BOOL boyToy;
}

-(void)createSprites;
-(void)giveToysToBoy;
-(void)giveToysToMom;

@end

@implementation BirdGame6Scene

-(void)createSprites{
    CGSize s=[CCDirector sharedDirector].winSize;
    
    CCSprite *bg=[CCSprite spriteWithFile:@"bGame6Bg.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg];
    
    CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
    CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        [[CCDirector sharedDirector] popScene];

    }];
    CCMenu *menu=[CCMenu menuWithItems:back, nil];
    [menu setPosition:ccp(70, s.height-70)];
    [self addChild:menu z:1];
    
    momGives=[CCSprite spriteWithFile:@"bGame6momGives.png"];
    momGives.position=ccp(700/2, 768-745/2);
    momGives.visible=NO;
    [self addChild:momGives];
    
    momShows=[CCSprite spriteWithFile:@"bGame6momShows.png"];
    momShows.position=ccp(661/2, 768-740/2);
    [self addChild:momShows];
    
    momSits=[CCSprite spriteWithFile:@"bGame6momSits.png"];
    momSits.position=ccp(594/2, 768-746/2);
    momSits.visible=NO;
    [self addChild:momSits];
    
    momTakes=[CCSprite spriteWithFile:@"bGame6momTakes.png"];
    momTakes.position=ccp(653/2, 768-746/2);
    momTakes.visible=NO;
    [self addChild:momTakes];
    
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
    
//    CCSprite *momBody=[CCSprite spriteWithFile:@"bGame6momBody.png"];
//    momBody.position=ccp(558/2, 768 - 736/2);
//    [self addChild:momBody];
//    
//    CCSprite *momHead=[CCSprite spriteWithFile:@"bGame6momHead.png"];
//    momHead.position=ccp(711/2, 768-363/2);
//    [self addChild:momHead];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame6Scene *layer=[BirdGame6Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        boyToy=NO;
        [self createSprites];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"BirdGame6" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_6, YES);
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
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleAllSelectors];
    [super onExit];
    [Flurry endTimedEvent:@"BirdGame6" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_6);
}

-(void)giveToysToBoy{
    momGives.visible=YES;
    momShows.visible=NO;
    momSits.visible=NO;
    momTakes.visible=NO;
    boyBend.visible=YES;
    boyRightHandBend.visible=YES;
    boyLeftHandBend.visible=YES;
    boySits.visible=NO;
    boyRightHandSit.visible=NO;
    boyLeftHandSit.visible=NO;
    boyWatch.visible=NO;
    boyLeftHandToy.visible=NO;
    boyRightHandToy.visible=NO;
    [self scheduleOnce:@selector(finalToysToBoy) delay:1.0];
}

-(void)finalToysToBoy{
    momSits.visible=YES;
    momGives.visible=NO;
    momShows.visible=NO;
    momTakes.visible=NO;
    boyWatch.visible=YES;
    boySits.visible=NO;
    boyBend.visible=NO;
    boyLeftHandToy.visible=YES;
    boyRightHandToy.visible=YES;
    boyLeftHandSit.visible=NO;
    boyRightHandSit.visible=NO;
    boyLeftHandBend.visible=NO;
    boyRightHandBend.visible=NO;
    boyToy=YES;
}

-(void)giveToysToMom{
    momTakes.visible=YES;
    momShows.visible=NO;
    momSits.visible=NO;
    momGives.visible=NO;
    boyBend.visible=YES;
    boySits.visible=NO;
    boyWatch.visible=NO;
    boyLeftHandToy.position=ccp(1600/2, 768-898/2);
    boyRightHandToy.position=ccp(1587/2, 768-973/2);
    [self scheduleOnce:@selector(finalToysToMom) delay:1];
}

-(void)finalToysToMom{
    momShows.visible=YES;
    momGives.visible=NO;
    momSits.visible=NO;
    momTakes.visible=NO;
    boyLeftHandToy.position=ccp(1642/2, 768-898/2);
    boyRightHandToy.position=ccp(1527/2, 768-973/2);
    boyWatch.visible=NO;
    boyBend.visible=NO;
    boySits.visible=YES;
    boyLeftHandBend.visible=NO;
    boyRightHandBend.visible=NO;
    boyLeftHandToy.visible=NO;
    boyRightHandToy.visible=NO;
    boyLeftHandSit.visible=YES;
    boyRightHandSit.visible=YES;
    boyToy=NO;
}

#pragma mark - Touches

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(momGives.boundingBox, loc)&&boyToy){
        [self giveToysToMom];
    }else if (CGRectContainsPoint(boySits.boundingBox, loc)&&!boyToy){
        [self giveToysToBoy];
    }
}

@end
