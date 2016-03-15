//
//  MainMenu.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/14/13.
//
//
#import "MainMenu.h"
#import "StoryMenu.h"
#import "ScalingMenuItemSprite.h"
#import "ParentsMenu.h"
#import "ListOfUsersView.h"
#import "ResumeView.h"


#define me self

typedef enum {
    MOVING_THING_KASHA,
    MOVING_THING_WATER,
    MOVING_THING_SPOON,
    MOVING_THING_BLANKET,
    MOVING_THING_BIB,
    MOVING_THING_NOTHING
}MOVING_THING;

#define RHAND CGRectMake(406.0,768-716,496-406,716-599)
#define LHAND CGRectMake(269,768-709,365-269,709-599)
#define BODY CGRectMake(291,768-564,449-291,564-471)
#define SPOONCHICKOLD CGRectMake(171,20,70,35)
#define SPOONCHICK CGRectMake(8,22,71-8,95-59)
#define MOUTH CGRectMake(360,768-425,430-360,425-384)

#define BODYTAG 50
#define HEADTAG 51
#define TAILTAG 52
#define TONGUETAG 53
#define EYETAG 54
#define SUBEYESTAG 55
#define LEARTAG 56
#define REARTAG 57

@interface MainMenu (){
    CCSprite *kasha, *water, *spoon, *bib, *blanket;
    CCSprite *kashaOnSpoon;
    //Tiger
    kBodyPlace bodyPlace;
    kHeadState headState;
    //
    BOOL eatingKasha;
    BOOL drinking;
    BOOL sleeping;
    BOOL canPlay;
    NSUInteger eatCounter;
    NSInteger drinkCounter;
    MOVING_THING movingThing;
    UIPanGestureRecognizer *panny;
    CGPoint beginPoint;
    int movePath;
    ALuint currentSoundID;
}

@end

@implementation MainMenu

#pragma mark - Graphics cycling

-(void)setNormalBody{
    [me removeChildByTag:BODYTAG cleanup:YES];
    CCSprite *body=[CCSprite spriteWithFile:@"mmBodyNorm.png"];
    body.position=ccp(388.0, 768.0-540.0);
    bodyPlace=kBodyNormal;
    [self addChild:body z:0 tag:BODYTAG];
}

-(void)setHandsUp:(BOOL)leftHand{
    [me removeChildByTag:BODYTAG cleanup:YES];
    CCSprite *body=[CCSprite spriteWithFile:@"mmBodyHand.png"];
    body.position=ccp(379, 768-530);
    body.scaleX=leftHand?1:-1;
    bodyPlace=kBodyHand;
    [self addChild:body z:0 tag:BODYTAG];
    [me unschedule:@selector(setNormalBody)];
    [me scheduleOnce:@selector(setNormalBody) delay:1.5];
}

-(void)setDrinkingBody{
    [me removeChildByTag:BODYTAG cleanup:YES];
    CCSprite *body=[CCSprite spriteWithFile:@"mmBodyDrink.png"];
    body.position=ccp(388, 768-598);
    bodyPlace=kBodyDrink;
    [me addChild:body z:0 tag:BODYTAG];
}

-(void)setLaughHead{
    CGPoint lastHeadPosition = [me getChildByTag:HEADTAG].position;
    NSLog(@"lastHeadPosition = (%f, %f)", lastHeadPosition.x, lastHeadPosition.y);
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadLaughNE.png"];
    if (bodyPlace==kBodyNormal)
        head.position=ccp(368.0, 768.0-286.0);
    else{
        head.position = lastHeadPosition;
    }
    headState=kHeadLaugh;
    [self addChild:head z:2 tag:HEADTAG];
    CCSprite *subEyes=[CCSprite spriteWithFile:@"mmEyesHalf.png"];
    subEyes.position=ccp(224, 144);
    subEyes.visible=NO;
    subEyes.scaleX=1.045;
    [head addChild:subEyes z:0 tag:SUBEYESTAG];
    CCSprite *eyes=[CCSprite spriteWithFile:@"mmEyesClosed.png"];
    eyes.position=ccp(226, 135);
    eyes.visible=NO;
    eyes.scaleX=1.05;
    [head addChild:eyes z:0 tag:EYETAG];
    CCSprite *lEar=[CCSprite spriteWithFile:@"mmEarL.png"];
    lEar.position=ccp(74, head.contentSize.height-90);
    [head addChild:lEar z:0 tag:LEARTAG];
    CCSprite *rEar=[CCSprite spriteWithFile:@"mmEarR.png"];
    rEar.position=ccp(373, lEar.position.y);
    [head addChild:rEar z:0 tag:REARTAG];
}

-(void)setSmileHead{
    CGPoint lastHeadPosition = [me getChildByTag:HEADTAG].position;
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadSmile.png"];
    if (bodyPlace==kBodyNormal)
        head.position=ccp(368.0, 768.0-286.0);
    else{
        head.position = lastHeadPosition;
    }
    headState=kHeadSmile;
    [me addChild:head z:2 tag:HEADTAG];
}

-(void)setHeadTurnLeft{
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadNoLeft.png"];
    if (bodyPlace==kBodyNormal)
        head.position=ccp(368.0, 768.0-286.0);
    headState=kHeadNoLeft;
    [me addChild:head z:2 tag:HEADTAG];
}

-(void)setHeadTurnRight{
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadNoRight.png"];
    if (bodyPlace==kBodyNormal)
        head.position=ccp(368.0, 768.0-286.0);
    headState=kHeadNoRight;
    [me addChild:head z:2 tag:HEADTAG];
}

-(void)setHeadDrinking{
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadNod.png"];
    //    if (bodyPlace==kBodyNormal || bodyPlace == kBodyDrink)
    head.position=ccp(375.0, 768-408.0);
    headState=kHeadDrink;
    [me addChild:head z:2 tag:HEADTAG];
    CCSprite *subEyes=[CCSprite spriteWithFile:@"mmEyesHalf.png"];
    subEyes.position=ccp(228-8, 116-5);
    subEyes.visible=NO;
    [head addChild:subEyes z:0 tag:SUBEYESTAG];
    CCSprite *eyes=[CCSprite spriteWithFile:@"mmEyesClosed.png"];
    eyes.position=ccp(230-8, 106-5);
    eyes.visible=NO;
    [head addChild:eyes z:0 tag:EYETAG];
    id move=[CCMoveTo actionWithDuration:0.5 position:ccp(375, 768-515)];
    [head runAction:move];
    CCSprite *tongue=[CCSprite spriteWithFile:@"mmTongue.png"];
    tongue.position=ccp(12+head.contentSize.width/2, 18);
    tongue.visible=NO;
    [head addChild:tongue z:0 tag:TONGUETAG];
    [me schedule:@selector(tongueBlink) interval:0.2 repeat:9 delay:0.5];
}

-(void)setAskWaterAgain{
    [[me getChildByTag:HEADTAG] runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(375, 768-408)]];
    if(rand()%3==1){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"I_want_drink_again.wav"];
    }
    drinking=NO;
}

-(void)drinkWaterAgain{
    [[me getChildByTag:HEADTAG] runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(375, 768-500)]];
    [me unschedule:@selector(tongueBlink)];
    [me schedule:@selector(tongueBlink) interval:0.2 repeat:9 delay:0.0];
}

-(void)tongueBlink{
    [[me getChildByTag:HEADTAG] getChildByTag:TONGUETAG].visible=![[me getChildByTag:HEADTAG] getChildByTag:TONGUETAG].visible;
}

-(void)setSleeping{
    [me removeChildByTag:BODYTAG cleanup:YES];
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *body=[CCSprite spriteWithFile:@"mmBodySleep0.png"];
    body.position=ccp(386.0, 768.0-541.0);
    [self addChild:body z:0 tag:BODYTAG];
    bodyPlace=kBodyPreSleep;
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadSleep.png"];
    head.position=ccp(313.0, 768.0-311.0);
    [self addChild:head z:2 tag:HEADTAG];
    headState=kHeadSleep;
    [me scheduleOnce:@selector(setTotalSleep) delay:1.0];
}

-(void)setTotalSleep{
    [me removeChildByTag:BODYTAG cleanup:YES];
    [me removeChildByTag:HEADTAG cleanup:YES];
    CCSprite *body=[CCSprite spriteWithFile:@"mmBodySleep.png"];
    body.position=ccp(394, 768-584);
    [self addChild:body z:0 tag:BODYTAG];
    bodyPlace=kBodySleep;
    CCSprite *head=[CCSprite spriteWithFile:@"mmHeadSleep.png"];
    head.position=ccp(313.0, 768-484);
    [self addChild:head z:2 tag:HEADTAG];
    headState=kHeadSleep;
    CCSprite *closedEyes=[CCSprite spriteWithFile:@"mmEyesClosed.png"];
    closedEyes.rotation=341.2;
    closedEyes.position=ccp(254, 132);
    closedEyes.visible=NO;
    [head addChild:closedEyes z:0 tag:EYETAG];
}

-(void)tailShake{
    CCNode *tail=[me getChildByTag:TAILTAG];
    if ([[tail actionManager] numberOfRunningActionsInTarget:tail]>0)
        return;
    id rot=[CCRotateBy actionWithDuration:0.3 angle:-35.0];
    id seq=[CCSequence actions:rot, [rot reverse], nil];
    [tail runAction:seq];
}

-(void)closeEyes{
    CCNode *head=[me getChildByTag:HEADTAG];
    CCNode *eyes=[head getChildByTag:EYETAG];
    eyes.visible=YES;
}

-(void)blinkEye{
    CCNode *head=[me getChildByTag:HEADTAG];
    CCNode *half=[head getChildByTag:SUBEYESTAG];
    half.visible=YES;
    [me scheduleOnce:@selector(finishBlink) delay:0.1];
}

-(void)finishBlink{
    CCNode *head=[me getChildByTag:HEADTAG];
    CCNode *half=[head getChildByTag:SUBEYESTAG];
    CCNode *eye=[head getChildByTag:EYETAG];
    half.visible=NO;
    eye.visible=YES;
    [me scheduleOnce:@selector(resetEyes) delay:0.1];
}

-(void)resetEyes{
    CCNode *head=[me getChildByTag:HEADTAG];
    CCNode *half=[head getChildByTag:SUBEYESTAG];
    CCNode *eye=[head getChildByTag:EYETAG];
    half.visible=NO;
    eye.visible=NO;
}

#pragma mark - Lifecycle

-(void)returnToStartState{
    panny.enabled=YES;
    
    [self unschedule:@selector(setAskWaterAgain)];
    [me setNormalBody];
    [me setLaughHead];
    if(water.position.x==379){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Thaaaaaanks.wav"];
    }
    [kasha runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(707.0, 768.0-646.0)]];
    [water runAction:[CCMoveTo actionWithDuration:.5 position:ccp(885.0, 768.0-646.0)]];
    [kashaOnSpoon removeFromParentAndCleanup:YES];
    kashaOnSpoon=nil;
    [spoon removeFromParentAndCleanup:YES];
    spoon=nil;
    [bib removeFromParentAndCleanup:YES];
    bib=nil;
    [blanket removeFromParentAndCleanup:YES];
    blanket=nil;
    sleeping=NO;
    eatingKasha=NO;
    drinking=NO;
}

-(void)createEatingScenario{
    [me setNormalBody];
    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"wear_me_a_bib.wav"];
    eatingKasha=YES;
    id moveKasha=[CCMoveTo actionWithDuration:0.5 position:ccp(379, 768-700)];
    [kasha runAction:moveKasha];
    [spoon removeFromParentAndCleanup:YES];
    spoon=[CCSprite spriteWithFile:@"mmSpoonR.png"];
    spoon.position=ccp(765, 768-540);
    [self addChild:spoon z:3];
    [kashaOnSpoon removeFromParentAndCleanup:YES];
    kashaOnSpoon=[CCSprite spriteWithFile:@"mmSpoonKasha.png"];
    kashaOnSpoon.position=ccp(SPOONCHICK.origin.x+SPOONCHICK.size.width/2, SPOONCHICK.origin.y+SPOONCHICK.size.height/2);
    kashaOnSpoon.scaleX=-1;
    kashaOnSpoon.visible=NO;
    [spoon addChild:kashaOnSpoon z:0];
    [bib removeFromParentAndCleanup:YES];
    bib=[CCSprite spriteWithFile:@"mmBib.png"];
    bib.position=ccp(765, 768-408);
    [self addChild:bib z:1];
    panny.enabled=NO;
}

-(void)createDrinkingScenario{
    [me setHeadDrinking];
    [me setDrinkingBody];
    [water runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(379, 768-700)]];
    [me scheduleOnce:@selector(setAskWaterAgain) delay:2];
    panny.enabled=NO;
    drinking = YES;
}

-(void)createSleepingScenario{
    [me setSleeping];
    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
    [[SimpleAudioEngine sharedEngine] playEffect:@"cover_me.wav"];
    blanket=[CCSprite spriteWithFile:@"mmBlanket.png"];
    blanket.position=ccp(765, 768-540);
    [self addChild:blanket z:3];
    panny.enabled=NO;
    sleeping=YES;
}

- (void)askForDrinkIsPosible{
    if(!eatingKasha && !drinking && !sleeping){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"I_want_drink.wav"];
    }
}

- (void)askForStoryWatch{
    if(!eatingKasha && !drinking && !sleeping){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Lets_watch_story.wav"];
    }
}

- (void)sayLoveYou{
    if(!eatingKasha && !drinking && !sleeping){
        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"I_love_you.wav"];
    }
}

-(void)createUI{
    CGSize s=[CCDirector sharedDirector].winSize;
    
    CCSprite *bg=[CCSprite spriteWithFile:@"mmBg.jpg"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:-1];
    
    CCSprite *parSprite=[CCSprite spriteWithFile:@"mmBtnParent.png"];
    ScalingMenuItemSprite *parentBtn=[ScalingMenuItemSprite itemWithNormalSprite:parSprite
                                                                  selectedSprite:nil
                                                                           block:^(id sender){
                                                                               [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ParentsMenu scene]]];
                                                                           }];
    CCMenu *menu1=[CCMenu menuWithItems:parentBtn, nil];
    [menu1 setPosition:ccp(103, 768-97)];
    [self addChild:menu1 z:4];
    ScalingMenuItemSprite *childBtn=[ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"mmBtnChild.png"]
                                                                 selectedSprite:nil
                                                                          block:^(id sender){
                                                                              [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StoryMenu scene]]];
                                                                          }];
    CCMenu *menu2=[CCMenu menuWithItems:childBtn, nil];
    [menu2 setPosition:ccp(839, 768-164)];
    [self addChild:menu2 z:4];
    
    kasha=[CCSprite spriteWithFile:@"mmKasha.png"];
    kasha.position=ccp(707.0, 768.0-646.0);
    [self addChild:kasha z:3];
    water=[CCSprite spriteWithFile:@"mmWater.png"];
    water.position=ccp(885.0, 768.0-646.0);
    [self addChild:water z:3];
    
    CCSprite *tail=[CCSprite spriteWithFile:@"mmTail.png"];
    tail.anchorPoint=ccp(0.2, 0.75);
    tail.position=ccp(551.0-tail.contentSize.width*0.3, (768.0-676.0)+tail.contentSize.height*0.25);
    [self addChild:tail z:0 tag:TAILTAG];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    MainMenu *layer=[MainMenu node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    if (self=[super init]){
        self.isTouchEnabled=YES;
        eatingKasha=NO;
        drinking=NO;
        sleeping=NO;
        movingThing = MOVING_THING_NOTHING;
        eatCounter=0;
        
        [self createUI];
        [self setNormalBody];
        [self setLaughHead];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    [super dealloc];
}

-(void)onEnter{
    [super onEnter];
}

-(void)onExit{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleAllSelectors];
    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
    [super onExit];
}

- (void)sayHello{
    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Hello.wav"];
}

- (void)sayIWantEat{
    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"I_want_eat.wav"];
}

-(void)onEnterTransitionDidFinish{
    canPlay = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentFullPath(@"childs.json")]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeClosed) name:@"ResumeView_hiden" object:nil];
        ListOfUsersView *v = [ListOfUsersView view];
        v.alpha = 0.0;
        ResumeView *res = [ResumeView view];
        res.cancelButton.alpha = 1.0;
        res.child = nil;
        res.delegate = v;
        [v addSubview:res];
        [[[CCDirector sharedDirector] view] addSubview:v];
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             v.alpha = 1.0;
                         } completion:nil];
        
    }else
        [self startScreen];
}

- (void)resumeClosed{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResumeView_hiden" object:nil];
    [self startScreen];
}

- (void)startScreen{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menus.mp3"];
    [self scheduleOnce:@selector(sayHello) delay:0.6];
    [self scheduleOnce:@selector(sayIWantEat) delay:2.0];
    
    [self schedule:@selector(tailShake) interval:60.0];
    [self schedule:@selector(blinkEye) interval:5.0];
    panny=[self watchForPan:@selector(panHandle:) target:self];
    int sec = rand()%150 + 25;
    [self schedule:@selector(askForDrinkIsPosible) interval:sec];
    
    sec = rand()%200 + 25;
    [self schedule:@selector(askForStoryWatch) interval:sec];
    
    sec = rand()%500 + 25;
    [self schedule:@selector(sayLoveYou) interval:sec];
    
}

-(void)onExitTransitionDidStart{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    [me unwatchPan:panny];
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    beginPoint = loc;
    movePath = 0;
    movingThing = MOVING_THING_NOTHING;
    if (CGRectContainsPoint(kasha.boundingBox, loc) && !CGRectIntersectsRect(bib.boundingBox, BODY)){
        movingThing = MOVING_THING_KASHA;
        return YES;
    }
    if (CGRectContainsPoint(water.boundingBox, loc)){
        movingThing = MOVING_THING_WATER;
        return YES;
    }
    if (eatingKasha){
        if (CGRectContainsPoint(spoon.boundingBox, loc)){
            if(bib.position.x==BODY.origin.x+BODY.size.width/2){
                movingThing = MOVING_THING_SPOON;
            }else{
                if(canPlay){
                    canPlay = NO;
                    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"wear_me_a_bib.wav"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        canPlay = YES;
                    });
                }
                
                
            }
        }else if (CGRectContainsPoint(bib.boundingBox, loc)){
            movingThing = MOVING_THING_BIB;
        }
    }else if (sleeping&&blanket.position.x!=372){
        if (CGRectContainsPoint(blanket.boundingBox, loc)){
            movingThing = MOVING_THING_BLANKET;
            
        }
    }
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    movePath += (abs(beginPoint.x - loc.x) + abs(beginPoint.y - loc.y))/2.0;
    if (movingThing == MOVING_THING_SPOON){
        spoon.position=loc;
        CGRect res=CGRectOffset(SPOONCHICK, spoon.boundingBox.origin.x, spoon.boundingBox.origin.y);
        if (CGRectIntersectsRect(res, kasha.boundingBox)){
            kashaOnSpoon.visible=YES;
        }else if (CGRectIntersectsRect(res, MOUTH)&&kashaOnSpoon.visible){
            if(eatCounter >= 5){
                [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"dont_want.wav"];
                [me scheduleOnce:@selector(setHeadTurnLeft) delay:0.25];
                [me scheduleOnce:@selector(setHeadTurnRight) delay:0.5];
                return;
            }
            if(eatCounter == 0){
                [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Mmm… Tasty.wav"];
            }
            if(eatCounter == 2)
                [[SimpleAudioEngine sharedEngine] playEffect:@"I_want_more.wav"];
            kashaOnSpoon.visible=NO;
            eatCounter++;
            [me setSmileHead];
            [me scheduleOnce:@selector(setLaughHead) delay:0.15];
            if (eatCounter==5){
                [[SimpleAudioEngine sharedEngine] playEffect:@"Mmm… Tasty.wav"];
                [[SimpleAudioEngine sharedEngine] playEffect:@"Thanks_was_tasty.wav" delayed:2];
            }
        }
    }
    else if (movingThing == MOVING_THING_BIB)
        bib.position=loc;
    else if (movingThing == MOVING_THING_BLANKET)
        blanket.position=loc;
    else if (movingThing == MOVING_THING_KASHA)
        kasha.position = loc;
    else if (movingThing == MOVING_THING_WATER)
        water.position = loc;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    double diffX = abs(beginPoint.x - loc.x);
    double diffY = abs(beginPoint.y - loc.y);
    
    if (movingThing != MOVING_THING_NOTHING && (diffX > 5 || diffY > 5) && !CGPointEqualToPoint(beginPoint, CGPointZero)){
        if (movingThing == MOVING_THING_BIB && !sleeping && !drinking){
            CGPoint tar;
            if (CGRectIntersectsRect(bib.boundingBox, BODY)){
                tar=ccp(BODY.origin.x+BODY.size.width/2, BODY.origin.y+BODY.size.height/2+50);
                if(canPlay){
                    canPlay = NO;
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"feed_me.wav"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        canPlay = YES;
                    });
                }
            }
            else
                tar=ccp(765, 768-408);
            [bib runAction:[CCMoveTo actionWithDuration:0.25 position:tar]];
        }else if(movingThing == MOVING_THING_BLANKET){
            CCNode *body=[me getChildByTag:BODYTAG];
            if (CGRectIntersectsRect(body.boundingBox, blanket.boundingBox)){
                [blanket removeFromParentAndCleanup:YES];
                blanket=nil;
                blanket=[CCSprite spriteWithFile:@"mmBlanket2.png"];
                blanket.position=ccp(372, 768-592);
                [self addChild:blanket z:1];
                [self unschedule:@selector(blinkEye)];
                [self scheduleOnce:@selector(closeEyes) delay:0.4];
                panny.enabled=YES;
                [[SimpleAudioEngine sharedEngine] playEffect:@"Thanks.wav"];
                [self scheduleOnce:@selector(sleepSound) delay:1];
                [self schedule:@selector(sleepSound) interval:8.3];
                
            }
        }else if (movingThing == MOVING_THING_KASHA){
            CGPoint tar=ccp(379, 768-700);
            if(water.position.x == 379 || sleeping){
                tar=ccp(707, 768.0-646.0);
                [kasha runAction:[CCMoveTo actionWithDuration:0.25 position:tar]];
            }else{
                if (!CGRectIntersectsRect(kasha.boundingBox, CGRectMake(tar.x - 50, tar.y - 50, 100, 100))){
                    [self returnToStartState];
                }else{
                    //                    if(!eatingKasha){
                    [self createEatingScenario];
                    //                    }else{
                    //                        tar=ccp(707.0, 768.0-646.0);
                    //                        [kasha runAction:[CCMoveTo actionWithDuration:0.25 position:tar]];
                    //                    }
                }
            }
            
        }else if (movingThing == MOVING_THING_WATER){//&& !drinking){
            CGPoint tar=ccp(379, 768-700);
            if(eatingKasha || sleeping){
                tar=ccp(885, 768.0-646.0);
                [water runAction:[CCMoveTo actionWithDuration:0.25 position:tar]];
            }else{
                
                if (!CGRectIntersectsRect(water.boundingBox, CGRectMake(tar.x - 50, tar.y - 50, 100, 100))){
                    [self returnToStartState];
                }else{
                    //                    if(!drinking){
                    [self createDrinkingScenario];
                    //                    }else{
                    //                        tar=ccp(379, 768.0-646.0);
                    //                        [water runAction:[CCMoveTo actionWithDuration:0.25 position:tar]];
                    //                    }
                }
            }
            
        }
        movingThing=MOVING_THING_NOTHING;
        return;
    }else if (!sleeping){
        if (CGRectContainsPoint(RHAND, loc)&&!drinking&&!spoon&&!sleeping&&water.position.x!=379){
            [self setHandsUp:YES];
        }else if(CGRectContainsPoint(LHAND, loc)&&!drinking&&!spoon&&!sleeping&&water.position.x!=379){
            [self setHandsUp:NO];
        }else if (CGRectContainsPoint([me getChildByTag:TAILTAG].boundingBox, loc)&&water.position.x!=379){
            [me tailShake];
        }else if (CGRectContainsPoint(kasha.boundingBox, loc)&&!drinking&&water.position.x!=379&&!sleeping){
            if(!eatingKasha){
                eatCounter=0;
                [me createEatingScenario];
            }else{
                if(eatCounter > 0)
                    [self returnToStartState];
                else
                    if(canPlay){
                        canPlay = NO;
                        
                        [[SimpleAudioEngine sharedEngine] playEffect:@"feed_me.wav"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            canPlay = YES;
                        });
                    }
                
            }
        }else if (CGRectContainsPoint(water.boundingBox, loc)&&!drinking&&!eatingKasha&&water.position.x!=379&&!sleeping){
            [me createDrinkingScenario];
            drinkCounter = 0;
            drinking=YES;
        }else if (CGRectContainsPoint(water.boundingBox, loc)&&!drinking&&!eatingKasha&&water.position.x==379&&!sleeping){
            drinkCounter++;
            [me drinkWaterAgain];
            drinking=YES;
            [me scheduleOnce:@selector(setAskWaterAgain) delay:2.0];
            if (drinkCounter>6){
                [me unschedule:@selector(returnToStartState)];
                [me scheduleOnce:@selector(returnToStartState) delay:1.0];
            }
        }else if(CGRectContainsPoint([me getChildByTag:BODYTAG].boundingBox, loc))
            if (!CGRectContainsPoint([me getChildByTag:HEADTAG].boundingBox, loc)) {
                if(!drinking){
                    //                    if(movePath < 5){
                    //                        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    //                        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"that hurts.wav"];
                    //                    }else{
                    //                        [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    //                        currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"LOL.wav"];
                    //                    }
                }
            }else{
                if (!sleeping && water.position.x!=379){
                    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    
                    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"sneeze.wav"];
                    
                    [me scheduleOnce:@selector(setSmileHead) delay:0.50];    //хотели чтобы при чихании качал головой=)
                    [me scheduleOnce:@selector(setLaughHead) delay:0.65];
                }
            }
            else if (CGRectContainsPoint([me getChildByTag:HEADTAG].boundingBox, loc)){
                CGPoint hLoc=[[me getChildByTag:HEADTAG] convertToNodeSpace:loc];
                
                if (CGRectContainsPoint([[me getChildByTag:HEADTAG] getChildByTag:LEARTAG].boundingBox, hLoc)){
                    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    currentSoundID =[[SimpleAudioEngine sharedEngine] playEffect:@"LOL.wav"];
                }else if (CGRectContainsPoint([[me getChildByTag:HEADTAG] getChildByTag:REARTAG].boundingBox, hLoc)){
                    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    currentSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"LOL.wav"];
                }
                
                hLoc=[[[me getChildByTag:HEADTAG] getChildByTag:EYETAG] convertToNodeSpace:loc];
                CGRect rect = [[me getChildByTag:HEADTAG] getChildByTag:EYETAG].boundingBox;
                int dist1 = abs(rect.size.width / 2.0 - hLoc.x);
                if (CGRectContainsPoint(CGRectMake(0, 0, rect.size.width, rect.size.height), hLoc) && dist1 > 50){
                    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
                    currentSoundID =[[SimpleAudioEngine sharedEngine] playEffect:@"that hurts.wav"];
                }
            }
    }
    beginPoint = CGPointZero;
}

- (void)sleepSound{
    [[SimpleAudioEngine sharedEngine] stopEffect:currentSoundID];
    [[SimpleAudioEngine sharedEngine] playEffect:@"sleep.mp3"];
}

#pragma mark - Handle swipes

-(void)panHandle:(UIPanGestureRecognizer*)pan{
    CGPoint loc;
    static float distPanning;
    static CGPoint prevLoc;
    CCSprite *body=(CCSprite*)[self getChildByTag:BODYTAG];
    CCSprite *head=(CCSprite*)[self getChildByTag:HEADTAG];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStatePossible:
            loc=[[CCDirector sharedDirector] convertToGL:[pan locationInView:[CCDirector sharedDirector].view]];
            if (CGRectContainsPoint(body.boundingBox, loc) || CGRectContainsPoint(head.boundingBox, loc)){
                distPanning=0;
                prevLoc=loc;
            }else{
                pan.enabled=NO;
            }
            break;
        case UIGestureRecognizerStateChanged:
            loc=[[CCDirector sharedDirector] convertToGL:[pan locationInView:[CCDirector sharedDirector].view]];
            if (CGRectContainsPoint(body.boundingBox, loc) || CGRectContainsPoint(head.boundingBox, loc)){
                distPanning+=ccpDistance(loc, prevLoc);
                if (distPanning>=3000){
                    [self unschedule:@selector(sleepSound)];
                    if (!sleeping){
                        [self createSleepingScenario];
                    }
                    else {
                        [self returnToStartState];
                    }
                    distPanning=0;
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            loc=[[CCDirector sharedDirector] convertToGL:[pan locationInView:[CCDirector sharedDirector].view]];
            if (CGRectContainsPoint(body.boundingBox, loc) || CGRectContainsPoint(head.boundingBox, loc)){
                
            }else{
                pan.enabled=YES;
            }
            break;
        default:
            break;
    }
}

-(UIPanGestureRecognizer*)watchForPan:(SEL)selector target:(id)tar{
    UIPanGestureRecognizer *panner=[[UIPanGestureRecognizer alloc] initWithTarget:tar action:selector];
    panner.cancelsTouchesInView = NO;
    panner.delaysTouchesBegan = NO;
    panner.delaysTouchesEnded = NO;
    panner.minimumNumberOfTouches=1;
    panner.maximumNumberOfTouches=1;
    [[CCDirector sharedDirector].view addGestureRecognizer:panner];
    return panner;
}

-(void)unwatchPan:(UIPanGestureRecognizer*)panner{
    [[CCDirector sharedDirector].view removeGestureRecognizer:panner];
}

@end
