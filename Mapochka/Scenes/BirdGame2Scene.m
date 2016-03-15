//
//  BirdGame2Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/19/13.
//
//

#import "BirdGame2Scene.h"
#import "SimpleAudioEngine.h"


#define LEAFSPEED 200.0


static int gameId = LOG_GAME_BIRD_4;


@interface BirdGame2Scene (){
//    NSMutableArray *leafs;
}

@property (atomic) NSMutableArray *leafs;

-(void)spawnStarsOnLeaf:(NSUInteger)num;

@end

@implementation BirdGame2Scene
@synthesize leafs=leafs;

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdGame2Scene *layer=[BirdGame2Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        leafs=[[NSMutableArray alloc] init];
        
        CCSprite *bg=[CCSprite spriteWithFile:@"bGame2Bg.jpg"];
        bg.position=ccp(s.width*.5, s.height*.5);
        [self addChild:bg];
        
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

-(void)dealloc{
    [leafs removeAllObjects];
    CCLOG(@"Deallocing 2nd game");
    [leafs release];
    [super dealloc];
}

- (void)catchIt{
    [[SimpleAudioEngine sharedEngine] playEffect:@"4.2 LoviSkorei.wav"];
}

- (void)tapTwice{
    [[SimpleAudioEngine sharedEngine] playEffect:@"4.3 NazhmiNaListochek.wav"];
}

- (void)goodBoy{
    [[SimpleAudioEngine sharedEngine] playEffect:@"2.2 Molodec.wav"];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"BirdGame4" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_BIRD_4, YES);
    [self spawnLeaf:@(1)];
    [[SimpleAudioEngine sharedEngine] playEffect:@"4.1 Poimai.wav"];
    [self scheduleOnce:@selector(catchIt) delay:5];
    [self scheduleOnce:@selector(tapTwice) delay:60];
    [self schedule:@selector(goodBoy) interval:23];
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
    [super onExit];
    [Flurry endTimedEvent:@"BirdGame4" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_BIRD_4);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleAllSelectors];
}

-(void)spawnLeaf:(NSNumber*)count{
    NSUInteger much=[count unsignedIntegerValue];
    if (leafs.count==2)
        return;
    else if (leafs.count==1)
        much=1;
    CGSize s=[CCDirector sharedDirector].winSize;
    for (int i=0;i<much;i++){
        CCSprite *leaf=[CCSprite spriteWithFile:@"bGame2Leaf.png"];
        leaf.position=ccp(s.width/2, s.height/2);
        leaf.tag=leafs.count;
        [self addChild:leaf z:0 tag:leafs.count];
        [leafs addObject:leaf];
        ccBezierConfig conf;
        conf.endPosition=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
        conf.controlPoint_1=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
        conf.controlPoint_2=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
        float sumDistance=ccpDistance(leaf.position, conf.controlPoint_2);
        sumDistance+=ccpDistance(conf.controlPoint_1, conf.controlPoint_2);
        sumDistance+=ccpDistance(conf.controlPoint_2, conf.endPosition);
        id move=[CCBezierTo actionWithDuration:sumDistance/LEAFSPEED bezier:conf];
        id slight=[CCEaseInOut actionWithAction:move rate:2.0];
        [leaf runAction:slight];
        [self performSelector:@selector(continueBezierForLeaf:) withObject:@(leaf.tag) afterDelay:[(CCEaseInOut*)slight duration]];
    }
}

-(void)continueBezierForLeaf:(NSNumber*)leafNum{
    CCSprite *leaf=(CCSprite*)[self getChildByTag:[leafNum integerValue]];
    ccBezierConfig conf;
    float dist=0;
    while (dist<400){
        conf.endPosition=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
        dist=ccpDistance(leaf.position, conf.endPosition);
    }
    conf.controlPoint_1=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
    conf.controlPoint_2=ccp(CCRANDOM_0_1()*(1024-leaf.contentSize.width/2), CCRANDOM_0_1()*(768-leaf.contentSize.height/2));
    float sumDistance=ccpDistance(leaf.position, conf.controlPoint_2);
    sumDistance+=ccpDistance(conf.controlPoint_1, conf.controlPoint_2);
    sumDistance+=ccpDistance(conf.controlPoint_2, conf.endPosition);
    id move=[CCBezierTo actionWithDuration:sumDistance/LEAFSPEED bezier:conf];
    id slight=[CCEaseInOut actionWithAction:move rate:2.0];
    [leaf runAction:slight];
    [self performSelector:@selector(continueBezierForLeaf:) withObject:leafNum afterDelay:[(CCEaseInOut*)slight duration]];

}

-(void)spawnStarsOnLeaf:(NSUInteger)num{
    CCSprite *leaf=(CCSprite*)[self getChildByTag:num];
    [leaf stopAllActions];
    __block CCSprite *stars1=[CCSprite spriteWithFile:@"bGame2Stars1.png"];
    __block CCSprite *stars2=[CCSprite spriteWithFile:@"bGame2Stars2.png"];
    stars1.scale=0.75;
    stars2.scale=0.75;
    stars1.position=leaf.position;
    stars2.position=leaf.position;
    [leaf removeFromParentAndCleanup:YES];
//    [leafs removeObject:leaf];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(continueBezierForLeaf:) object:@(num)];
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
    });
    
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    NSMutableArray *toRemove = [NSMutableArray array];
    for (CCSprite *leaf in leafs){
        if (CGRectContainsPoint(leaf.boundingBox, loc)){
            switch (touch.tapCount) {
                case 2:
                    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTouch:) object:touch];
                    [self spawnStarsOnLeaf:leaf.tag];
                    [toRemove addObject:leaf];
                    [self performSelector:@selector(spawnLeaf:) withObject:@(2) afterDelay:1.5];
                    break;
                case 1:
                    [self performSelector:@selector(handleSingleTouchOnLeaf:) withObject:@(leaf.tag) afterDelay:0.3];
                default:
                    break;
            }
        }
    }
    [self.leafs removeObjectsInArray:toRemove];
    [self unschedule:@selector(catchIt)];
}

-(void)handleSingleTouchOnLeaf:(NSNumber*)leafNum{
    CCSprite *l = (CCSprite*)[self getChildByTag:[leafNum integerValue]];
    [self spawnStarsOnLeaf:[leafNum integerValue]];
    [leafs removeObject:l];
    if (leafs.count<1)
        [self performSelector:@selector(spawnLeaf:) withObject:@(1) afterDelay:1.5];
}

@end
