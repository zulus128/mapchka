//
//  ToiletStoryScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/18/13.
//
//

#import "ToiletStoryScene.h"
#import "ScalingMenuItemSprite.h"
#import "GameMenu.h"

#define MENUTAG 55
#define me self
static const NSMutableArray *audioParts;
@interface ToiletStoryScene (){
    AVAudioPlayer *track;
    UIView * blackScreen;
}
@property (nonatomic) NSTimeInterval time;
@end

@implementation ToiletStoryScene

-(void)cleanUpScene{
    //[track pause];
    //    CCNode *menu=[self getChildByTag:MENUTAG];
    //    [menu retain];
    //    [self removeAllChildrenWithCleanup:YES];
    //    [self addChild:menu z:1 tag:MENUTAG];
    //    [menu release];
    
    //    for (CCNode *child in [me children]){
    //        if ([child tag]!=MENUTAG) [child removeFromParentAndCleanup:YES];
    //    }
    
    [me removeAllChildrenWithCleanup:YES];
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
    ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
//        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        [[CCDirector sharedDirector] popScene];

    }];
    CCSprite *next=[CCSprite spriteWithFile:@"playButton.png"];
    ScalingMenuItemSprite *nextItem=[ScalingMenuItemSprite itemWithNormalSprite:next selectedSprite:nil block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameMenu sceneWithTheme:kMenuToilets]]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Lets_play.wav"];
    }];
    CCMenu *navMenu=[CCMenu menuWithItems:backItem, nextItem, nil];
    [navMenu setPosition:ccp(s.width/2, s.height-70)];
    [navMenu alignItemsHorizontallyWithPadding:780];
    [self addChild:navMenu z:1 tag:MENUTAG];
    
    [self unschedule:@selector(redBlink)];
    [self unschedule:@selector(blueBlink)];
    [self unschedule:@selector(openTheirEyes)];
    [self unschedule:@selector(closeTheirEyes)];
}

#pragma mark - Scene 1

-(void)setFirstScene{
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg1.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    
    CCSprite *mom=[CCSprite spriteWithFile:@"tMom.png"];
    mom.anchorPoint=ccp(0.44, 0.38);
    mom.position=ccp(488, 768-374);
    [self addChild:mom z:0 tag:58];
    CCSprite *girl=[CCSprite spriteWithFile:@"tGirl.png"];
    girl.anchorPoint=ccp(0.5, 0.09);
    girl.position=ccp(235, 768-644);
    [self addChild:girl z:0 tag:59];
    CCSprite *boy=[CCSprite spriteWithFile:@"tBoy.png"];
    boy.anchorPoint=ccp(0.5, 0.08);
    boy.position=ccp(805, 768-635);
    [self addChild:boy z:0 tag:60];
    
    
    [self scheduleOnce:@selector(setSecondScene) delay:11.2];
}

-(void)girlNod{
    id nod=[CCRotateBy actionWithDuration:0.3 angle:12.0];
    CCSprite *girl=(CCSprite*)[self getChildByTag:59];
    [girl runAction:nod];
    [girl performSelector:@selector(runAction:) withObject:[nod reverse] afterDelay:0.35];
}

-(void)boyNod{
    id nod=[CCRotateBy actionWithDuration:0.3 angle:-10.0];
    CCSprite *boy=(CCSprite*)[self getChildByTag:60];
    [boy runAction:nod];
    [boy performSelector:@selector(runAction:) withObject:[nod reverse] afterDelay:0.35];
}

-(void)momNod{
    id nod=[CCRotateBy actionWithDuration:0.3 angle:12];
    CCSprite *mom=(CCSprite*)[self getChildByTag:58];
    [mom runAction:nod];
    [mom performSelector:@selector(runAction:) withObject:[nod reverse] afterDelay:0.35];
}

#pragma mark - Scene 2

-(void)setSecondScene{
    [self cleanUpScene];
    
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg5.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    CCSprite *mom=[CCSprite spriteWithFile:@"tMomToGirl.png"];
    mom.position=ccp(738, 768-380);
    [self addChild:mom z:0 tag:50];
    CCSprite *girl=[CCSprite spriteWithFile:@"tGirlStays.png"];
    girl.position=ccp(292, 768-504);
    [self addChild:girl z:0 tag:51];
    [self scheduleOnce:@selector(giveToGirl) delay:4.0];
    //[track play];
}

-(void)giveToGirl{
    [self removeChildByTag:51 cleanup:YES];
    CCSprite *girl=[CCSprite spriteWithFile:@"tGirlTakes.png"];
    girl.position=ccp(292, 768-504);
    [self addChild:girl z:0 tag:51];
    [self scheduleOnce:@selector(girlTook) delay:2];
}

-(void)girlTook{
    [self removeChildByTag:50 cleanup:YES];
    [self removeChildByTag:51 cleanup:YES];
    CCSprite *mom=[CCSprite spriteWithFile:@"tMomGave.png"];
    mom.position=ccp(738, 768-380);
    [self addChild:mom z:0 tag:50];
    CCSprite *girl=[CCSprite spriteWithFile:@"tGirlWith.png"];
    girl.position=ccp(292, 768-504);
    [self addChild:girl z:0 tag:51];
    
    [self scheduleOnce:@selector(setThirdScene) delay:0.4];
}

#pragma mark - Scene 3

-(void)setThirdScene{
    [self cleanUpScene];
    
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg5.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    CCSprite *mom=[CCSprite spriteWithFile:@"tMomToBoy.png"];
    mom.position=ccp(738, 768-380);
    [self addChild:mom z:0 tag:50];
    CCSprite *boy=[CCSprite spriteWithFile:@"tBoyStays.png"];
    boy.position=ccp(292, 768-504);
    [self addChild:boy z:0 tag:51];
    [self scheduleOnce:@selector(giveToBoy) delay:0.1];
    //[track play];
}

-(void)giveToBoy{
    [self removeChildByTag:51 cleanup:YES];
    CCSprite *boy=[CCSprite spriteWithFile:@"tBoyTakes.png"];
    boy.position=ccp(292, 768-504);
    [self addChild:boy z:0 tag:51];
    [self scheduleOnce:@selector(boyTook) delay:2.0];
}

-(void)boyTook{
    [self removeChildByTag:50 cleanup:YES];
    [self removeChildByTag:51 cleanup:YES];
    CCSprite *mom=[CCSprite spriteWithFile:@"tMomGave.png"];
    mom.position=ccp(738, 768-380);
    [self addChild:mom z:0 tag:50];
    CCSprite *boy=[CCSprite spriteWithFile:@"tBoyWith.png"];
    boy.position=ccp(292, 768-504);
    [self addChild:boy z:0 tag:51];
    
    [self scheduleOnce:@selector(setFourthScene) delay:0.55];
}

#pragma mark - Scene 4

-(void)setFourthScene{
    [self cleanUpScene];
    
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg2.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    CCSprite *red=[CCSprite spriteWithFile:@"tRed.png"];
    red.position=ccp(590.0, 768.0-607.0);
    [self addChild:red];
    CCSprite *blue=[CCSprite spriteWithFile:@"tBlue.png"];
    blue.position=ccp(282, 768-606);
    [self addChild:blue];
    CCSprite *blueFace=[CCSprite spriteWithFile:@"tBlueFace.png"];
    blueFace.position=ccp(300, 768-536);
    [self addChild:blueFace z:0 tag:65];
    CCSprite *redFace=[CCSprite spriteWithFile:@"tRedFace.png"];
    redFace.position=ccp(532, 768-587);
    [self addChild:redFace z:0 tag:66];
    CCSprite *redEyes=[CCSprite spriteWithFile:@"tRedEyes.png"];
    redEyes.position=ccp(532, 768-587);
    redEyes.opacity=0;
    [self addChild:redEyes z:0 tag:67];
    CCSprite *blueEyes=[CCSprite spriteWithFile:@"tBlueEyes.png"];
    blueEyes.position=ccp(300, 768-536);
    blueEyes.opacity=0;
    [self addChild:blueEyes z:0 tag:68];
    
    [self schedule:@selector(redBlink) interval:3.2];
    [self schedule:@selector(blueBlink) interval:3.7];
    
    
    [self scheduleOnce:@selector(setFifthScene) delay:9.5];
    //[track play];
}

#pragma mark - Scene 5

-(void)setFifthScene{
    [self cleanUpScene];
    [self unscheduleAllSelectors];
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg3.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    CCSprite *blue=[CCSprite spriteWithFile:@"tBlue3.png"];
    blue.position=ccp(296, 768-474);
    [self addChild:blue z:0 tag:60];
    CCSprite *sticker1=[CCSprite spriteWithFile:@"tSticker1.png"];
    sticker1.position=ccp(396, 768-604);
    [self addChild:sticker1 z:0 tag:61];
    CCSprite *sticker2=[CCSprite spriteWithFile:@"tSticker2.png"];
    sticker2.position=ccp(467, 768-571);
    [self addChild:sticker2 z:0 tag:62];
    CCSprite *blueFunFace=[CCSprite spriteWithFile:@"tBlueFun.png"];
    blueFunFace.position=ccp(326, 768-343);
    [self addChild:blueFunFace z:0 tag:65];
    CCSprite *blueEyesOff=[CCSprite spriteWithFile:@"tBlueEyesOff.png"];
    blueEyesOff.position=blueFunFace.position;
    blueEyesOff.opacity=0;
    [self addChild:blueEyesOff z:0 tag:68];
    
    CCSprite *red=[CCSprite spriteWithFile:@"tRed3.png"];
    red.position=ccp(746, 768-536);
    [self addChild:red z:0 tag:70];
    CCSprite *redFunFace=[CCSprite spriteWithFile:@"tRedFun.png"];
    redFunFace.position=ccp(637.0, 768.0-504.0);
    [self addChild:redFunFace z:0 tag:66];
    CCSprite *redEyesOff=[CCSprite spriteWithFile:@"tRedEyesOff.png"];
    redEyesOff.position=redFunFace.position;
    redEyesOff.opacity=0;
    [self addChild:redEyesOff z:0 tag:67];
    
    [self schedule:@selector(redBlink)interval:0.5 repeat:3 delay:7.5];
    [self schedule:@selector(redBlink)interval:0.5 repeat:6 delay:11.5];
    
    
    
    [self schedule:@selector(blueBlink) interval:0.5 repeat:3 delay:16.3];
    [self schedule:@selector(blueBlink) interval:0.5 repeat:22 delay:20.8];
    
    
    [self schedule:@selector(redBlink)interval:0.5 repeat:3 delay:33.6];
    [self schedule:@selector(redBlink)interval:0.5 repeat:10 delay:38.6];
    //[self schedule:@selector(blueBlink) interval:3.5];
    [self scheduleOnce:@selector(spawnStickersOnRed) delay:44.6];
    [self scheduleOnce:@selector(setSixthScene) delay:54.1];
    //[track play];
}

-(void)spawnStickersOnRed{
    [self showBlackScreen];
}

-(void)showBlackScreen{
    CGRect frame = CGRectMake(0, 0, [CCDirector sharedDirector].winSize.width, [CCDirector sharedDirector].winSize.height);
    blackScreen= [[UIView alloc]initWithFrame:frame];
    [blackScreen setAlpha:1.0];
    [blackScreen setBackgroundColor:[UIColor blackColor]];
    [[[CCDirector sharedDirector] view] addSubview:blackScreen];
    [self scheduleOnce:@selector(hideBlackScreen) delay:0.4];
}

-(void) hideBlackScreen{
    [blackScreen removeFromSuperview];
    blackScreen = nil;
    CCSprite *sticker1=[CCSprite spriteWithFile:@"tSticker1.png"];
    sticker1.position=ccp(805, 768-596);
    [self addChild:sticker1 z:0 tag:72];
    CCSprite *sticker2=[CCSprite spriteWithFile:@"tSticker2.png"];
    sticker2.position=ccp(876, 768-560);
    [self addChild:sticker2 z:0 tag:73];
    NSArray *redSprites = @[
                            [self getChildByTag:70],//tRed3
                            [self getChildByTag:66],//tRedFun.png
                            [self getChildByTag:67],//tRedEyesOff.png
                            sticker1,
                            sticker2
                            ];
    for (CCSprite *sprite in redSprites) {
        sprite.position = CGPointMake(sprite.position.x + 300, sprite.position.y);
    }
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         blackScreen.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         for (CCSprite *sprite in redSprites) {
                             CCMoveBy *action = [CCMoveBy actionWithDuration:2 position:CGPointMake(-300, 0)];
                             [sprite runAction:action];
                         }
                     }];
    
}

#pragma mark - Scene 6

-(void)setSixthScene{
    [self cleanUpScene];
    
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"tBg4.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    
    CCSprite *boy=[CCSprite spriteWithFile:@"tBoy4.png"];
    boy.anchorPoint=ccp(0.41, 0.07);
    boy.position=ccp(320, 768-300);
    [self addChild:boy z:0 tag:60];
    CCSprite *girl=[CCSprite spriteWithFile:@"tGirl4.png"];
    girl.anchorPoint=ccp(0.48, 0.08);
    girl.position=ccp(760, 768-287);
    [self addChild:girl z:0 tag:61];
    CCSprite *bHand=[CCSprite spriteWithFile:@"tBoyHand.png"];
    bHand.anchorPoint=ccp(0.4, 0.1);
    bHand.position=ccp(461, 768-404);
    [self addChild:bHand z:0 tag:62];
    CCSprite *gHand=[CCSprite spriteWithFile:@"tGirlHand.png"];
    gHand.anchorPoint=ccp(0.7, 0.14);
    gHand.position=ccp(648, 768-385);
    [self addChild:gHand z:0 tag:63];
    
    CCSprite *bEyes=[CCSprite spriteWithFile:@"tBoyEyes4.png"];
    bEyes.position=ccp(350, 768-242);
    bEyes.visible=NO;
    [self addChild:bEyes z:0 tag:64];
    CCSprite *gEyes=[CCSprite spriteWithFile:@"tGirlEyes4.png"];
    gEyes.position=ccp(735, 229);
    gEyes.visible=NO;
    [self addChild:gEyes z:0 tag:65];
    
    [me schedule:@selector(closeTheirEyes) interval:2.5];
    [me scheduleOnce:@selector(openProxy) delay:0.25];
    [me scheduleOnce:@selector(makeTheirHandsSwipe) delay:0.5];
    //[track play];
}

-(void)closeTheirEyes{
    CCSprite *bEyes=(CCSprite*)[me getChildByTag:64];
    //    CCSprite *gEyes=(CCSprite*)[me getChildByTag:65];
    bEyes.visible=YES;
    //    gEyes.visible=YES;
}

-(void)openProxy{
    [me schedule:@selector(openTheirEyes) interval:2.5];
}

-(void)openTheirEyes{
    CCSprite *bEyes=(CCSprite*)[me getChildByTag:64];
    //    CCSprite *gEyes=(CCSprite*)[me getChildByTag:65];
    bEyes.visible=NO;
    //    gEyes.visible=NO;
}

-(void)makeTheirHandsSwipe{
    CCSprite *gHand=(CCSprite*)[self getChildByTag:63];
    id gRot1=[CCRotateBy actionWithDuration:0.25 angle:-12.0];
    id gRot2=[CCRotateBy actionWithDuration:0.18 angle:8.0];
    id gseq=[CCSequence actions:gRot1, [gRot1 reverse], gRot2, [gRot2 reverse], nil];
    [gHand runAction:[CCRepeatForever actionWithAction:gseq]];
    //
    CCSprite *bHand=(CCSprite*)[self getChildByTag:62];
    id bRot1=[CCRotateBy actionWithDuration:0.25 angle:16.0];
    id bRot2=[CCRotateBy actionWithDuration:0.18 angle:-10.0];
    id bseq=[CCSequence actions:bRot1, [bRot1 reverse], bRot2, [bRot2 reverse], nil];
    [bHand runAction:[CCRepeatForever actionWithAction:bseq]];
}

//-(void)sprite:(CCSprite*)spr greetWithNumberOfGreets:(NSUInteger)num durationOfOne:(float)dura angleOne:(float)ang1 angleTwo:(float)ang2{
//    float timer=0;
//    id rot1=[CCRotateBy actionWithDuration:dura angle:ang1];
//    id rot2=[CCRotateBy actionWithDuration:dura angle:ang2];
//    for (NSUInteger i=0;i<num;i++){
//        [spr runAction:rot1];
//        timer+=dura;
//        [spr ]
//    }
//}

#pragma mark - Shared methods


-(void)redBlink2{
    CCSprite *redEyes=(CCSprite*)[self getChildByTag:67];
    CCSprite *redFace=(CCSprite*)[self getChildByTag:66];
    [redEyes setOpacity:255];
    [redFace setOpacity:0];
    [self scheduleOnce:@selector(redBack2) delay:0.2];
}

-(void)redBack2{
    CCSprite *redEyes=(CCSprite*)[self getChildByTag:67];
    CCSprite *redFace=(CCSprite*)[self getChildByTag:66];
    redEyes.opacity=0;
    redFace.opacity=255;
}

-(void)redBlink{
    CCSprite *redEyes=(CCSprite*)[self getChildByTag:67];
    CCSprite *redFace=(CCSprite*)[self getChildByTag:66];
    [redEyes setOpacity:255];
    [redFace setOpacity:0];
    [self scheduleOnce:@selector(redBack) delay:0.2];
}

-(void)redBack{
    CCSprite *redEyes=(CCSprite*)[self getChildByTag:67];
    CCSprite *redFace=(CCSprite*)[self getChildByTag:66];
    redEyes.opacity=0;
    redFace.opacity=255;
}

-(void)blueBlink{
    CCSprite *blueEyes=(CCSprite*)[self getChildByTag:68];
    CCSprite *blueFace=(CCSprite*)[self getChildByTag:65];
    blueEyes.opacity=255;
    blueFace.opacity=0;
    [self scheduleOnce:@selector(blueBack) delay:0.2];
}

-(void)blueBack{
    CCSprite *blueEyes=(CCSprite*)[self getChildByTag:68];
    CCSprite *blueFace=(CCSprite*)[self getChildByTag:65];
    blueEyes.opacity=0;
    blueFace.opacity=255;
}

#pragma mark - Lifecycle

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletStoryScene *layer=[ToiletStoryScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        audioParts = [@[@11.2, @18.3, @22.0] mutableCopy];
        NSError *error=nil;
        NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"toilet" ofType:@"mp3"]];
        track=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error)
            NSLog(@"Troubles with track init");
        [track setDelegate:self];
        
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCSprite *next=[CCSprite spriteWithFile:@"playButton.png"];
        ScalingMenuItemSprite *nextItem=[ScalingMenuItemSprite itemWithNormalSprite:next selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameMenu sceneWithTheme:kMenuToilets]]];
        }];
        CCMenu *navMenu=[CCMenu menuWithItems:backItem, nextItem, nil];
        [navMenu setPosition:ccp(s.width/2, s.height-70)];
        [navMenu alignItemsHorizontallyWithPadding:780.0];
        [self addChild:navMenu z:1 tag:MENUTAG];
        
        [self setFirstScene];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [track stop];
    [track setDelegate:nil];
    [track release];
    [audioParts release];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"ToiletStory" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_STORY_TOILET, YES);
    [track prepareToPlay];
    [track play];
    //    [self schedule:@selector(checkPlaybackTime) interval:0.2f];
}

-(void)onEnterTransitionDidFinish{
    self.time = [[NSDate date] timeIntervalSince1970];
    [self scheduleOnce:@selector(girlNod) delay:1.0];
    [self scheduleOnce:@selector(boyNod) delay:2.0];
    [self scheduleOnce:@selector(momNod) delay:7.2];
}

-(void)onExit{
    [super onExit];
    
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:LOG_STORY_TOILET] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:LOG_STORY_TOILET withObject:stat];
    [[AppController appController] saveStat];

    
    [Flurry endTimedEvent:@"ToiletStory" withParameters:nil];
    MDLogEndTimedEvent(LOG_STORY_TOILET);
    [self unscheduleAllSelectors];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void)onExitTransitionDidStart{
    
}

//-(void)checkPlaybackTime{
//    double seconds = [track currentTime];
//    double d = 0.15;
//    NSLog(@"seconds = %f", seconds);
//    for (NSNumber *part in audioParts) {
//        double partValue = [part doubleValue];
//        NSLog(@"partValue = %f", partValue);
//        if((seconds <= (partValue + d)) &&
//           (seconds >= (partValue - d))){
//            //[track pause];
//            [audioParts removeObject:part];
//            [self scheduleOnce:@selector(continiePlaying) delay:1.7];
//            break;
//        }
//    }
//}
//
//- (void)continiePlaying{
//    //[track play];
//}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    CCLOG(@"Story finished.");
}

@end
