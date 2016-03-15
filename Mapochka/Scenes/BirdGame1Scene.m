//
//  BirdGame1Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/18/13.
//
//

#import "BirdGame1Scene.h"
#import "SimpleAudioEngine.h"


static int gameId = LOG_GAME_BIRD_1;

@interface BirdGame1Scene (){
    Bird *bird;
    //
    BOOL birdSing;
    BOOL wingsAnim;
    BOOL birdJump;
    BOOL birdTail;
    BOOL allowUser;
}

@end

@implementation BirdGame1Scene

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame1Scene *layer=[BirdGame1Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        birdSing=NO;
        wingsAnim=NO;
        birdJump=NO;
        birdTail=NO;
        allowUser=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"bGame1Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg];
        
        bird=[Bird node];
        bird.position=ccp(s.width/2, 104.0);
        bird.delegate=self;
        [self addChild:bird];
        
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    NSLog(@"Bird game 1 deallocing");
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"BirdGame1" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_1, YES);
    [bird blinkEyes];
}

- (void)I_like_play_with_you{
    [[SimpleAudioEngine sharedEngine] playEffect:@"1.2 SToboyTakInteresnoIgrat.wav"];
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"1.1 PoigraySoMnoy.wav"];
    [self schedule:@selector(I_like_play_with_you) interval:45.0];
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
    [Flurry endTimedEvent:@"BirdGame1" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_1);
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return allowUser;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(bird.boundingBox, loc)){
        CGPoint hLoc=[bird.head convertToNodeSpace:loc];
        loc=[bird convertToNodeSpace:loc];
        if ((CGRectContainsPoint(bird.wingLeft.boundingBox, loc)||CGRectContainsPoint(bird.wingRight.boundingBox, loc))&&!birdJump){
            [bird wingsAnimate];
        }else if (CGRectContainsPoint(bird.body.boundingBox, loc)&&!birdJump){
            [bird jump];
        }else if (CGRectContainsPoint(bird.mouth.boundingBox, hLoc)&&!birdSing){
            [bird chickChirick];
        }else if (CGRectContainsPoint(bird.tail.boundingBox, loc)&&!birdTail){
            [bird swipeTail];
        }else if (CGRectContainsPoint(bird.head.boundingBox, loc)){
            [bird headSwipe];
        }else if (CGRectContainsPoint(bird.lLeg.boundingBox, loc)){
            [bird leftLegUp];
        }else if (CGRectContainsPoint(bird.rLeg.boundingBox, loc)){
            [bird rightLegUp];
        }
    }else if(loc.x>=175 && loc.x<=866){
//        id moveBird=[CCMoveTo actionWithDuration:1 position:ccp(loc.x, 104.0)];
//        [bird jump];
        [bird jumpAndMoveTo:ccp(loc.x, 104.0)];
//        [bird runAction:moveBird];
    }else if(loc.x<175){
//        id moveBird=[CCMoveTo actionWithDuration:1 position:ccp(175, 104)];
        [bird jumpAndMoveTo:ccp(175, 104.0)];
//        [bird runAction:moveBird];
    }else if(loc.x>835){
//        id moveBird=[CCMoveTo actionWithDuration:1 position:ccp(835, 104)];
        [bird jumpAndMoveTo:ccp(866, 104.0)];
//        [bird runAction:moveBird];
    }
}

#pragma mark - Bird

-(void)birdFlyingAndMoving{
    allowUser=NO;
}
-(void)birdFlewAndMoved{
    allowUser=YES;
}
-(void)birdStartWingFly{
    birdJump=YES;
}
-(void)birdEndWingFly{
    birdJump=NO;
}
-(void)birdStartJump{
    birdJump=YES;
}
-(void)birdEndJump{
    birdJump=NO;
}
-(void)birdStartChirick{
    birdSing=YES;
}
-(void)birdEndChirick{
    birdSing=NO;
}
-(void)birdStartTail{
    birdTail=YES;
}
-(void)birdEndTail{
    birdTail=NO;
}

@end
