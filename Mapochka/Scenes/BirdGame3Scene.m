//
//  BirdGame3Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/30/13.
//
//

#import "BirdGame3Scene.h"
#import "Bird.h"
#import "Sun.h"
#import "SimpleAudioEngine.h"

#define RAINTAG 55
#define DROPSTAG 56

#define LEFTUPPOS ccp(0,0)
#define LEFTDOWNPOS ccp(584/2, (1536-986)/2);
#define RIGHTDOWNPOS ccp(1500/2, (1546-1100)/2)
#define RIGHTUPPOS ccp(1506/2, (1536-320)/2)

static int gameId = LOG_GAME_BIRD_5;

@interface BirdGame3Scene (){
    Bird *bird;
    Sun *sun;
    CCSprite *leaf;
    CCSprite *cloud;
    NSMutableArray *curVec;
    CGPoint sunPos[4];
    CGPoint cloudPos[4];
    CGPoint birdPos[4];
    CGPoint leafPos[4];
    BOOL allowChoose;
    int shouldSelect;
    int rightAnswers;
}

-(void)spawnRain;
-(void)randomizeEm;

@property (atomic) NSMutableArray *leafs;
@end

@implementation BirdGame3Scene
@synthesize leafs = leafs;

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame3Scene *layer=[BirdGame3Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        allowChoose=YES;
        curVec=[[NSMutableArray alloc] initWithObjects:@(0),@(1),@(2),@(3), nil];
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        
        sunPos[0]=ccp(608.0/2.0 + 120, (1536-421)/2 + 80);
        sunPos[1]=ccp(608.0/2.0 + 120, (1536-986)/2 - 80);
        sunPos[2]=ccp(1506/2 + 80, (1536-320)/2);
        sunPos[3]=ccp(1500/2 + 120, (1546-1400)/2+120);
        cloudPos[0]=ccp(608.0/2.0, (1536-421)/2 + 70);
        cloudPos[1]=ccp(584/2, (1536-986)/2);
        cloudPos[2]=ccp(1506/2, (1536-320)/2+50);
        cloudPos[3]=ccp(1500/2, (1546-1400)/2+170);
        birdPos[0]=ccp(608.0/2.0-30, (1536-421)/2 - 190);
        birdPos[1]=ccp(584/2, (1536-986)/2-235);
        birdPos[2]=ccp(1506/2, (1536-320)/2 - 200);
        birdPos[3]=ccp(1506/2, (1536-1400)/2 - 30);
        leafPos[0]=ccp(608.0/2.0, (1536-421)/2 + 30);
        leafPos[1]=ccp(584/2, (1536-986)/2 - 75);
        leafPos[2]=ccp(1506/2, (1536-320)/2);
        leafPos[3]=ccp(1500/2, (1546-1400)/2+120);
        
        sun=[Sun node];
        sun.position=sunPos[0];
        sun.scale=0.75;
        [self addChild:sun];
        
        cloud=[CCSprite spriteWithFile:@"cloud.png"];
        cloud.position=cloudPos[1];
        [self addChild:cloud];
        
        bird=[Bird node];
        bird.position=birdPos[3];
        bird.scale=0.65;
        [bird lookLeft];
        [self addChild:bird];
        
        leaf=[CCSprite spriteWithFile:@"bGame3Leaf.png"];
        leaf.position=leafPos[2];
        [self addChild:leaf];
        
        //add back storyArrLeft
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:1];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"BirdGame5" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_5, YES);
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [self sayWhatToSelect];
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
    [Flurry endTimedEvent:@"BirdGame5" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_5);
}

-(void)dealloc{
    [curVec removeAllObjects];
    [curVec release];
    [super dealloc];
}

-(void)spawnRain{
    if ([self getChildByTag:RAINTAG]) return;
    CCSprite *rain=[CCSprite spriteWithFile:@"rain.png"];
    CCSprite *rainDrops=[CCSprite spriteWithFile:@"rainDrops.png"];
    rain.position=ccp(cloud.position.x, cloud.position.y-cloud.contentSize.height/3-rain.contentSize.height/3 - 20);
    rainDrops.position=rain.position;
    [self addChild:rain z:0 tag:RAINTAG];
    [self addChild:rainDrops z:0 tag:DROPSTAG];
    [self scheduleOnce:@selector(cleanRain) delay:2.0];
}

-(void)cleanRain{
    [self removeChildByTag:RAINTAG cleanup:YES];
    [self removeChildByTag:DROPSTAG cleanup:YES];
}

- (void)moveRandom{
    for (int i=0;i<3;i++){
        int rand=round(CCRANDOM_0_1()*3);
        [curVec exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
    id sunMove=[CCMoveTo actionWithDuration:1.0 position:sunPos[[[curVec objectAtIndex:0] intValue]]];
    id leafMove=[CCMoveTo actionWithDuration:1.0 position:leafPos[[[curVec objectAtIndex:1] intValue]]];
    id cloudMove=[CCMoveTo actionWithDuration:1.0 position:cloudPos[[[curVec objectAtIndex:2] intValue]]];
    id birdMove=[CCMoveTo actionWithDuration:1.0 position:birdPos[[[curVec objectAtIndex:3] intValue]]];
    [sun runAction:sunMove];
    [leaf runAction:leafMove];
    [cloud runAction:cloudMove];
    [bird runAction:birdMove];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allowChoose=YES;
        shouldSelect = arc4random_uniform(4);
        [self sayWhatToSelect];
        rightAnswers = 0;
    });
}

-(void)randomizeEm{
    if(rightAnswers >= 4){
        [self scheduleOnce:@selector(moveRandom) delay:2.0];
    }else{
        shouldSelect = arc4random_uniform(4);
        [self scheduleOnce:@selector(sayWhatToSelect) delay:2.5];
        //        allowChoose = YES;
    }
    
}

- (BOOL)sayRight:(int)selected{
    if(selected == shouldSelect){
        [[SimpleAudioEngine sharedEngine] playEffect:@"5.5 Pravilno.wav"];
        rightAnswers++;
        return YES;
    }
    else{
        rightAnswers = 0;
        [[SimpleAudioEngine sharedEngine] playEffect:@"5.7 NeNe.mp3"];
        return NO;
    }
}

- (void)sayWhatToSelect{
    switch (shouldSelect) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"5.1 Gde1.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"5.2 Gde2.wav"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"5.3 Gde3.wav"];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"5.4 Gde4.wav"];
            break;
            
        default:
            break;
    }
}

-(void)spawnStarsOnLeaf{
    
    
    leaf.visible = NO;
    __block CCSprite *stars1=[CCSprite spriteWithFile:@"bGame2Stars1.png"];
    __block CCSprite *stars2=[CCSprite spriteWithFile:@"bGame2Stars2.png"];
    stars1.scale=0.75;
    stars2.scale=0.75;
    stars1.position=leaf.position;
    stars2.position=leaf.position;
    
    [self addChild:stars1];
    [self addChild:stars2];
    id fade1=[CCFadeOut actionWithDuration:1.5];
    id fade2=[CCFadeOut actionWithDuration:1.5];
    [stars1 runAction:fade1];
    [stars2 runAction:fade2];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [stars1 removeFromParentAndCleanup:YES];
        [stars2 removeFromParentAndCleanup:YES];
        leaf.visible = YES;
    });
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return allowChoose;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(allowChoose){
        [self unschedule:@selector(makeAllowToChoose)];
        [self scheduleOnce:@selector(makeAllowToChoose) delay:1.5];
        //        NSLog(@"allowChoose = %@", allowChoose ? @"YES" : @"NO");
        CGPoint loc=[self convertTouchToNodeSpace:touch];
        CGPoint sLoc=[sun convertToNodeSpace:loc];
        if (CGRectContainsPoint(bird.boundingBox, loc)){
            allowChoose=NO;
            if([self sayRight:3])
                [bird wingsAnimate];
            [self randomizeEm];
        }else if (CGRectContainsPoint(sun.body.boundingBox, sLoc)){
            if([self sayRight:0])
                [sun animateSunlights];
            allowChoose=NO;
            [self randomizeEm];
        }else if (CGRectContainsPoint(cloud.boundingBox, loc)){
            
            if([self sayRight:2])
                [self spawnRain];
            allowChoose=NO;
            [self randomizeEm];
        }else if (CGRectContainsPoint(leaf.boundingBox, loc)){
            allowChoose=NO;
            if([self sayRight:1])
                [self spawnStarsOnLeaf];
            [self randomizeEm];
        }
    }
}

- (void)makeAllowToChoose{
    allowChoose = YES;
    
    NSLog(@"allowChoose SET TO = YES");
}

@end
