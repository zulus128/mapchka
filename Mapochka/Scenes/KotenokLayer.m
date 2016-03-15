//
//  KotenokLayer.m
//  Mapochka
//
//  Created by Nikita Anisimov on 2/6/13.
//
//

#import "KotenokLayer.h"
#import "IntroLayer.h"
#import "GameMenu.h"
#import "ScalingMenuItemSprite.h"

@interface KotenokLayer ()
@property (nonatomic) NSTimeInterval time;
@end

@implementation KotenokLayer

+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    KotenokLayer *layer = [KotenokLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    if (self=[super init]){
        NSError *error=nil;
        NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kotenok" ofType:@"mp3"]];
        track=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error)
            NSLog(@"Troubles with track init");
        [track setDelegate:self];
        self.isTouchEnabled=YES;
        enableMoreMilk=NO;
        finita=NO;
        bendedHim=NO;
        nearBowley=NO;
        cameToPause=NO;
        asksMore=NO;
        [self createUI];
        
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
            [track stop];
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        }];
        CCSprite *next=[CCSprite spriteWithFile:@"playButton.png"];
        ScalingMenuItemSprite *nextItem=[ScalingMenuItemSprite itemWithNormalSprite:next selectedSprite:nil block:^(id sender){
            [track stop];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameMenu sceneWithTheme:kMenuWalkingCat]]];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Lets_play.wav"];
        }];
        CCMenu *navMenu=[CCMenu menuWithItems:backItem, nextItem, nil];
        [navMenu setPosition:ccp(s.width/2, s.height-70)];
        [navMenu alignItemsHorizontallyWithPadding:780.0];
        [self addChild:navMenu z:1];
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"Kotenok story deallocing.");
    [track stop];
    [track setDelegate:nil];
    [track release];
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)onEnterTransitionDidFinish{
    self.time = [[NSDate date] timeIntervalSince1970];
}

-(void)onEnter{
    [super onEnter];
    
    [Flurry logEvent:@"CatStory" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_STORY_CAT, YES);
    [track prepareToPlay];
    [track play];
    [self schedule:@selector(checkPlaybackTime) interval:0.2f];
    [self schedule:@selector(blinkEyes) interval:3];
}

-(void)onExit{
    [super onExit];
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:LOG_STORY_CAT] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:LOG_STORY_CAT withObject:stat];
    [[AppController appController] saveStat];
    [Flurry endTimedEvent:@"CatStory" withParameters:nil];
    MDLogEndTimedEvent(LOG_STORY_CAT);
    [track stop];
    [self unscheduleAllSelectors];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void)createUI{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCSprite *bg=[CCSprite spriteWithFile:@"nbg.jpg"];
    [bg setPosition:ccp(s.width/2, s.height/2)];
    [self addChild:bg];
    
    CCSprite *head=[CCSprite spriteWithFile:@"head.png"];
    [head setPosition:ccp(s.width*0.304, s.height-s.height*0.233)];
    [self addChild:head];
    
    eyesup=[CCSprite spriteWithFile:@"eyesup.png"];
    [eyesup setPosition:ccp(s.width*0.298, s.height-s.height*0.2784)];
    [self addChild:eyesup];
    
    eyesdown=[CCSprite spriteWithFile:@"eyesdown.png"];
    [eyesdown setPosition:eyesup.position];
    [eyesdown setVisible:NO];
    [self addChild:eyesdown];
    
    veki=[CCSprite spriteWithFile:@"veki.png"];
    [veki setPosition:ccpAdd(eyesup.position, ccp(0, 8))];
    [veki setVisible:NO];
    [self addChild:veki];
    
    eyesoff=[CCSprite spriteWithFile:@"eyesoff.png"];
    [eyesoff setPosition:eyesup.position];
    [eyesoff setVisible:NO];
    [self addChild:eyesoff];
    
//    backBtn=[CCSprite spriteWithFile:@"btn.png"];
//    [backBtn setPosition:ccp(s.width*0.08, s.height*0.9)];
//    [self addChild:backBtn];
//    
//    nextBtn=[CCSprite spriteWithFile:@"btn.png"];
//    [nextBtn setPosition:ccp(s.width*0.92, s.height*0.9)];
//    [nextBtn setScaleX:-1.0];
//#warning TEST TIME, SET VISIBLE NO
//    [nextBtn setVisible:YES];
//    [self addChild:nextBtn];
    
    CCSprite *bowley=[CCSprite spriteWithFile:@"bowley.png"];
    [bowley setPosition:ccp(s.width*0.3715, s.height-s.height*0.855)];
    bowleyRect=bowley.boundingBox;
    [self addChild:bowley];
    
    milky=[CCSprite spriteWithFile:@"milky.png"];
    [milky setPosition:ccp(s.width*0.3715, s.height-s.height*0.855)];
    [self addChild:milky];
    
    catty=[Kot node];
    [catty setPosition:ccp(1346, s.height*0.055)];
    [catty setDelegate:self];
    [self addChild:catty];
}

#pragma mark - Animation methods

-(void)blinkEyes{
    [eyesoff setVisible:YES];
    [self scheduleOnce:@selector(restoreEyes) delay:0.3];
}

-(void)restoreEyes{
    [eyesoff setVisible:NO];
}

#pragma mark - Touch handling

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [self convertTouchToNodeSpace:touch];
//    if (CGRectContainsPoint(backBtn.boundingBox, loc)){
//        [track stop];
//        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
//    }else if (CGRectContainsPoint(nextBtn.boundingBox, loc)){
//        [track stop];
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameMenu sceneWithTheme:kMenuWalkingCat]]];
    if (CGRectContainsPoint(bowleyRect, loc)&&((asksMore&&!finita)||(enableMoreMilk))&&!bendedHim){
        [milky setVisible:YES];
        [catty eatMore];
        [catty bend];
        finita=enableMoreMilk?NO:YES;
    }else{
        if (!nearBowley && cameToPause){
            CGSize s = [[CCDirector sharedDirector] winSize];
            CCLOG(@"Coming from pos = (%f,%f)", catty.position.x, catty.position.y);
            CCLOG(@"To pos = (%f,%f)", s.width/2 - 100, s.height*0.055);
            [catty walkTo:ccp(s.width/2 - 100 + catty.boundingBox.size.width/2, s.height*0.055)];
            nearBowley=YES;
        }
    }
}

#pragma mark - Player handling

-(void)checkPlaybackTime{
    double seconds = [track currentTime];
    if (seconds>=17.5 && seconds<=17.9 && !cameToPause){
        [track pause];
        cameToPause=YES;
    }else if(seconds>=40.2 && seconds<=40.8 && !asksMore){
        [track pause];
        asksMore=YES;
    }else if(seconds>=48.7 && seconds<=49.2){
        [catty nod];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    CCLOG(@"Story finished.");
    enableMoreMilk=YES;
}

#pragma mark - Kot things

-(void)kotPoshel{
    [track setCurrentTime:18.0];
    [track play];
}

-(void)kotPrishel{
    [veki setVisible:YES];
    [catty scheduleOnce:@selector(bend) delay:8.5];
}

-(void)kotBending{
    [eyesdown setVisible:YES];
    ccTime delay;
    if (!asksMore)
        delay=8;
    else
        delay=2.5;
    bendedHim=YES;
    [catty scheduleOnce:@selector(lollipopIt) delay:.5];
    [catty scheduleOnce:@selector(stopLolli) delay:delay];
    [catty scheduleOnce:@selector(unbend) delay:(delay+0.3)];
}

-(void)kotUnBending{
    [milky setVisible:NO];
    [eyesdown setVisible:NO];
    [catty scheduleOnce:@selector(sayThx) delay:.5];
    [self scheduleOnce:@selector(unbended) delay:1];
    if (finita)
        [track play];
}

-(void)unbended{
    bendedHim=NO;
}

@end
