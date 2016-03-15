//
//  BirdStoryScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/18/13.
//
//

#import "BirdStoryScene.h"
#import "GameMenu.h"
#import "ScalingMenuItemSprite.h"

#define BIRDPOS ccp(632.0,117.0)
#define SUNSHOWN ccp(435.0,675.0)
#define SUNHIDDEN ccp(350.0,550.0)
#define LEAFSHOWN ccp(705.0,282.0)
#define LEAFHIDDEN ccp(1400.0,282.0)


@interface BirdStoryScene (){
    Bird *bird;
    Sun *sun;
    CCSprite *leaf;
    CCSprite *cloud;
    CCSprite *rain;
    CCSprite *rainDrops;
    CCSprite *drop1;
    CCSprite *drop2;
    AVAudioPlayer *track;
    //
    BOOL birdSing,birdJump,birdWing, sunSmile;
    BOOL allowToPlay;
}
@property (nonatomic) NSTimeInterval time;

-(void)createScene;

@end

@implementation BirdStoryScene

-(void)createScene{
    
    sun=[Sun node];
    sun.position=SUNHIDDEN;
    sun.scale=0.8;
    [self addChild:sun];
    
    rain=[CCSprite spriteWithFile:@"rain.png"];
    rain.position=ccp(233.0, 768.0-490.0);
    rain.visible=NO;
    [self addChild:rain];
    
    rainDrops=[CCSprite spriteWithFile:@"rainDrops.png"];
    rainDrops.position=ccp(233.0, 768.0-503.0);
    rainDrops.visible=NO;
    [self addChild:rainDrops];
    
    cloud=[CCSprite spriteWithFile:@"cloud.png"];
    cloud.position=ccp(203.0, 501.0);
    [self addChild:cloud];
    
    drop1=[CCSprite spriteWithFile:@"water1.png"];
    drop1.position=ccp(475.0, 142.0);
    drop1.visible=NO;
    [self addChild:drop1];
    drop2=[CCSprite spriteWithFile:@"water2.png"];
    drop2.position=ccp(854.0, 168.0);
    drop2.visible=NO;
    [self addChild:drop2];
    
    bird=[Bird node];
    bird.position=BIRDPOS;
//    bird.delegate=self;
    [bird blinkEyes];
    [self addChild:bird];
    
    leaf=[CCSprite spriteWithFile:@"leaf.png"];
    leaf.position=LEAFHIDDEN;
    [self addChild:leaf];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BirdStoryScene *layer=[BirdStoryScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        birdSing=NO;
        birdJump=NO;
        birdWing=NO;
        sunSmile=NO;
        allowToPlay=NO;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"birdBg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        
        CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCSprite *next=[CCSprite spriteWithFile:@"playButton.png"];
        ScalingMenuItemSprite *nextItem=[ScalingMenuItemSprite itemWithNormalSprite:next selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameMenu sceneWithTheme:kMenuSparrow]]];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Lets_play.wav"];
        }];
        CCMenu *navMenu=[CCMenu menuWithItems:backItem, nextItem, nil];
        [navMenu setPosition:ccp(s.width/2, s.height-70)];
        [navMenu alignItemsHorizontallyWithPadding:780.0];
        [self addChild:navMenu z:1];
        
        [self createScene];
        NSError *error=nil;
        NSString *path=[[NSBundle mainBundle] pathForResource:@"bird" ofType:@"mp3"];
        track=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        track.delegate=self;
        if (error)
            NSLog(@"Trouble getting track in Bird Story.");
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    [track stop];
    track.delegate=nil;
    [track release];
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
    
    self.time = [[NSDate date] timeIntervalSince1970];
    [Flurry logEvent:@"BirdStory" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_STORY_BIRD, YES);
    [self schedule:@selector(checkPlaybackTime) interval:0.25];
}

-(void)onEnterTransitionDidFinish{
    [track prepareToPlay];
    [track play];
}

-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:LOG_STORY_BIRD] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:LOG_STORY_BIRD withObject:stat];
    [[AppController appController] saveStat];
    [Flurry endTimedEvent:@"BirdStory" withParameters:nil];
    MDLogEndTimedEvent(LOG_STORY_BIRD);
    [self unscheduleAllSelectors];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void)onExitTransitionDidStart{
    [track stop];
}

-(void)checkPlaybackTime{
    NSTimeInterval time=[track currentTime];
    CCLOG(@"Time = %f", time);
    if (time>7.0 && time<7.5 && sun.position.x==SUNHIDDEN.x){
        id moveSun=[CCMoveTo actionWithDuration:0.8 position:SUNSHOWN];
        [sun runAction:moveSun];
        [sun animateSunlights];
    }else if(time>10.3 && time<10.8 && !birdSing){
        [bird chickChirick];
        birdSing=YES;
    }else if(time>16.1 && time<16.6 && !sunSmile){
        [sun smile];
        sunSmile=YES;
    }else if(time>18.45 && time<19 && !birdWing){
        [bird wingsAnimate];
        birdWing=YES;
    }else if(time>24.8 && time<25.3 && sun.position.x==SUNSHOWN.x){
        id moveSun=[CCMoveTo actionWithDuration:0.8 position:SUNHIDDEN];
        [sun runAction:moveSun];
        [sun animateSunlights];
        [sun shutMouth];
        sunSmile=NO;
    }else if(time>30.9 && time<31.4 && !rain.visible){
        rain.visible=YES;
        rainDrops.visible=YES;
    }else if(time>36.6 && 37.1 && !birdJump){
        [bird jump];
        [bird scheduleOnce:@selector(jump) delay:1.2];
        birdJump=YES;
    }else if(time>41.5 && time<42 && leaf.position.x==LEAFHIDDEN.x){
        id moveLeaf=[CCMoveTo actionWithDuration:0.8 position:LEAFSHOWN];
        [leaf runAction:moveLeaf];
    }else if(time>50.1 && time<50.6 && sun.position.x==SUNHIDDEN.x){
        id moveSun=[CCMoveTo actionWithDuration:0.8 position:SUNSHOWN];
        [sun runAction:moveSun];
        [sun animateSunlights];
        rain.visible=NO;
        rainDrops.visible=NO;
        drop1.visible=YES;
        drop2.visible=YES;
    }else if(time>53.8 && time<54.4){
        id moveLeaf=[CCMoveTo actionWithDuration:0.8 position:LEAFHIDDEN];
        [leaf runAction:moveLeaf];
    }else if(time>57.0 && time<57.5 && birdSing){
        [bird chickChirick];
        birdSing=NO;
    }else if(time>59.8 && time<60.3 && !sunSmile){
        [sun smile];
        sunSmile=YES;
    }
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return allowToPlay;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    CGPoint sunLoc=[sun convertToNodeSpace:loc];
    if (CGRectContainsPoint(sun.body.boundingBox, sunLoc)){
        [sun animateSunlights];
    }else if (CGRectContainsPoint(drop1.boundingBox, loc)){
        drop1.visible=NO;
    }else if (CGRectContainsPoint(drop2.boundingBox, loc)){
        drop2.visible=NO;
    }else if (CGRectContainsPoint(leaf.boundingBox, loc)){
        id moveSun=[CCMoveTo actionWithDuration:0.8 position:SUNSHOWN];
        [sun runAction:moveSun];
        [sun animateSunlights];
        [sun smile];
        id moveLeaf=[CCMoveTo actionWithDuration:0.8 position:LEAFHIDDEN];
        [leaf runAction:moveLeaf];
        rain.visible=NO;
        rainDrops.visible=NO;
        drop1.visible=YES;
        drop2.visible=YES;
    }else if(CGRectContainsPoint(bird.boundingBox, loc)){
        CGPoint birdLoc=[bird convertToNodeSpace:loc];
        CGPoint birdMouth=[bird.head convertToNodeSpace:loc];
        if (CGRectContainsPoint(bird.mouth.boundingBox, birdMouth)&&!birdSing){
            [bird chickChirick];
            birdSing=YES;
        }else if (CGRectContainsPoint(bird.head.boundingBox, birdLoc)){
            [bird headSwipe];
        }else if ((CGRectContainsPoint(bird.wingLeft.boundingBox, birdLoc) || CGRectContainsPoint(bird.wingRight.boundingBox, birdLoc)) && !birdWing){
            [bird wingsAnimate];
            birdWing=YES;
        }else if (CGRectContainsPoint(bird.tail.boundingBox, birdLoc)){
            [bird swipeTail];
        }else if (CGRectContainsPoint(bird.body.boundingBox, birdLoc) && !birdJump){
            [bird jump];
            birdJump=YES;
        }
    }else if (CGRectContainsPoint(cloud.boundingBox, loc)){
        id moveSun=[CCMoveTo actionWithDuration:0.8 position:SUNHIDDEN];
        [sun runAction:moveSun];
        [sun animateSunlights];
        [sun shutMouth];
        id moveLeaf=[CCMoveTo actionWithDuration:0.8 position:LEAFSHOWN];
        [leaf runAction:moveLeaf];
        rain.visible=YES;
        rainDrops.visible=YES;
        allowToPlay=NO;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            allowToPlay=YES;
        });
    }
}

#pragma mark - Bird

-(void)birdEndJump{
    birdJump=NO;
}
-(void)birdEndWingFly{
    birdWing=NO;
}
-(void)birdEndChirick{
    birdSing=NO;
}

#pragma mark - Player

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self unschedule:@selector(checkPlaybackTime)];
    bird.delegate=self;
    allowToPlay=YES;
    birdWing=NO;
    birdJump=NO;
    birdSing=NO;
}

@end
