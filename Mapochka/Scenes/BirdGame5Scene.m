//
//  BirdGame5Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/22/13.
//
//

#import "BirdGame5Scene.h"
#import "Sun.h"
#import "SimpleAudioEngine.h"


static int gameId = LOG_GAME_BIRD_2;

@interface BirdGame5Scene (){
    NSMutableArray *drops;
    CCSprite *cloud;
    NSUInteger count;
    Sun *sun;
}

-(void)refreshDrops;

@end

@implementation BirdGame5Scene

-(void)refreshDrops{
    
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame5Scene *layer=[BirdGame5Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        drops=[[NSMutableArray alloc] init];
        
        CCSprite *bg=[CCSprite spriteWithFile:@"bGame5Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg];
        
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:1];
        
        sun=[Sun node];
        sun.scale=0.75;
        sun.position=ccp(455+150, 768-165);
        sun.visible=NO;
        [self addChild:sun];
        
        cloud=[CCSprite spriteWithFile:@"bGame5Cloud.png"];
        cloud.position=ccp(455, 768-165);
        [self addChild:cloud];
        
        CGPoint dropPos[14]={ccp(345, 768-309), ccp(444, 768-335), ccp(556, 768-335), ccp(642, 768-274), ccp(674, 768-362), ccp(355, 768-413), ccp(630, 768-436), ccp(444, 768-480), ccp(544, 768-462), ccp(720, 768-529), ccp(626, 768-562), ccp(417, 768-594), ccp(520, 768-612), ccp(612, 768-674)};
        for (int i=0;i<14;i++){
            NSString *spriteName=(i==0||i==3||i==4)?@"bGame5Drop1.png":@"bGame5Drop2.png";
            CCSprite *drop=[CCSprite spriteWithFile:spriteName];
            drop.scale=(i==0||i==3||i==4)?1.0:2.0;
            drop.position=dropPos[i];
            [self addChild:drop];
            [drops addObject:drop];
        }
        count=14;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"BirdGame2" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_2, YES);
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"2.1 LopniVse.wav"];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [drops removeAllObjects];
    [drops release];
    [self unscheduleAllSelectors];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
    [Flurry endTimedEvent:@"BirdGame2" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_2);
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
    if (CGRectContainsPoint(cloud.boundingBox, loc)){
        for (CCSprite *each in drops)
            each.visible=YES;
        if (count==0){
            id move=[CCMoveTo actionWithDuration:1 position:ccp(455+150, 768-155)];
            [sun runAction:move];
            [sun animateSunlights];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                sun.visible=NO;
                [[SimpleAudioEngine sharedEngine] playEffect:@"2.1 LopniVse.wav"];
            });
        }
        count=14;
        return;
    }
    for (CCSprite *each in drops){
        if (CGRectContainsPoint(each.boundingBox, loc)&&each.visible){
            each.visible=NO;
            count--;
            break;
        }
    }
    if (count==0&&!sun.visible){
        sun.visible=YES;
        id move = [CCMoveBy actionWithDuration:1.0 position:ccp(256+150, 40)];
        [sun performSelector:@selector(runAction:) withObject:move afterDelay:0.5];
        [sun scheduleOnce:@selector(animateSunlights) delay:0.5];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"2.2 Molodec.wav" delayed:1.5];
    }
}

@end
