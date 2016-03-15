//
//  ToiletsGame3Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/22/13.
//
//

#import "ToiletsGame3Scene.h"
#import "SimpleAudioEngine.h"
#define PANTSWIN CGRectMake(403, 768-694, 146, 354)
#define HOODWIN CGRectMake(335, 768-380, 279, 190)
#define LBOOTWIN CGRectMake(366, 768-706,117,96)
#define RBOOTWIN CGRectMake(477, 768-715, 95, 90)
#define DRESSWIN CGRectMake(325, 768-571, 300, 399)


static int gameId = LOG_GAME_TOILET_3;

@interface ToiletsGame3Scene (){
    CCSprite *girl;
    CCSprite *hand;
    CCSprite *eyes;
    CCSprite *dress;
    CCSprite *pants;
    CCSprite *hood;
    CCSprite *leftBoot;
    CCSprite *rightBoot;
    BOOL moving;
    BOOL handShaking;
    BOOL stopShaking;
    NSUInteger movNum;
}

@property (nonatomic, strong) NSMutableArray * things;

-(void)createGame;

@end

@implementation ToiletsGame3Scene

-(void)createGame{
    girl=[CCSprite spriteWithFile:@"tGame3Girl.png"];
    hand=[CCSprite spriteWithFile:@"tGame3Hand.png"];
    eyes=[CCSprite spriteWithFile:@"tGame3Eyes.png"];
    dress=[CCSprite spriteWithFile:@"tGame3Dress.png"];
    pants=[CCSprite spriteWithFile:@"tGame3Pants.png"];
    hood=[CCSprite spriteWithFile:@"tGame3Hood.png"];
    leftBoot=[CCSprite spriteWithFile:@"tGame3LBoot.png"];
    rightBoot=[CCSprite spriteWithFile:@"tGame3RBoot.png"];
    //
    girl.position=ccp(473, 768-363);
    hand.position=ccp(342, 768-196);
    eyes.position=ccp(458, 768-131);
    eyes.visible=NO;
    dress.position=ccp(183, 768-200);
    pants.position=ccp(760, 768-242);
    hood.position=ccp(213, 768-598);
    leftBoot.position=ccp(697, 768-564);
    rightBoot.position=ccp(818, 768-576);
    //
    [self addChild:girl];
    [self addChild:hand];
    [self addChild:eyes];
    [self addChild:hood];
    [self addChild:pants];
    [self addChild:dress];
    [self addChild:leftBoot];
    [self addChild:rightBoot];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletsGame3Scene *layer=[ToiletsGame3Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"tGame3Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:1];
        
        [self createGame];
    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"ToiletGame3" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_TOILET_3, YES);
    [self schedule:@selector(blink) interval:3.0];
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"5.1 Pomogi.wav"];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"ToiletGame3" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_TOILET_3);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(void)blink{
    eyes.visible=YES;
    [self scheduleOnce:@selector(blinkBack) delay:0.5];
}

-(void)blinkBack{
    eyes.visible=NO;
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!self.things){
        self.things = [NSMutableArray array];
        for (int i = 0; i<5; i++)
            [self.
             things addObject:[NSNumber numberWithInt:0]];
    }
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(dress.boundingBox, loc)){
        movNum=1;
        moving=YES;
    }else if (CGRectContainsPoint(hood.boundingBox, loc)){
        movNum=2;
        moving=YES;
    }else if(CGRectContainsPoint(pants.boundingBox, loc) && [[self.things objectAtIndex:3] intValue]==0 && [[self.things objectAtIndex:4] intValue]==0){
        movNum=3;
        moving=YES;
    }else if(CGRectContainsPoint(rightBoot.boundingBox, loc)){
        movNum=4;
        moving=YES;
    }else if (CGRectContainsPoint(leftBoot.boundingBox, loc)){
        movNum=5;
        moving=YES;
    }
    return moving;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    switch (movNum) {
        case 1:
            dress.position=loc;
            break;
        case 2:
            hood.position=loc;
            break;
        case 3:
            pants.position=loc;
            break;
        case 4:
            rightBoot.position=loc;
            break;
        case 5:
            leftBoot.position=loc;
            break;
        default:
            break;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    id move=NULL;
    BOOL doubleAction = NO;
    switch (movNum) {
        case 1:
            if (CGRectIntersectsRect(dress.boundingBox, DRESSWIN)&&pants.position.x==PANTSWIN.origin.x+PANTSWIN.size.width/2&&hood.position.x==HOODWIN.origin.x+HOODWIN.size.width/2){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(DRESSWIN.origin.x+DRESSWIN.size.width/2, DRESSWIN.origin.y+DRESSWIN.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(183, 768-200)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [dress runAction:move];
            break;
        case 2:
            if (CGRectIntersectsRect(hood.boundingBox, HOODWIN)){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(HOODWIN.origin.x+HOODWIN.size.width/2, HOODWIN.origin.y+HOODWIN.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(213, 768-598)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [hood runAction:move];
            break;
        case 3:
            if (CGRectIntersectsRect(pants.boundingBox, PANTSWIN)){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(PANTSWIN.origin.x+PANTSWIN.size.width/2, PANTSWIN.origin.y+PANTSWIN.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(760, 768-242)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [pants runAction:move];
            break;
        case 4:
            if (CGRectIntersectsRect(rightBoot.boundingBox, RBOOTWIN)&&pants.position.x==PANTSWIN.origin.x+PANTSWIN.size.width/2){
                move=[CCMoveTo actionWithDuration:.5 position:ccp(RBOOTWIN.origin.x+RBOOTWIN.size.width/2, RBOOTWIN.origin.y+RBOOTWIN.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:.5 position:ccp(818, 768-576)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [rightBoot runAction:move];
            break;
        case 5:
            if (CGRectIntersectsRect(leftBoot.boundingBox, LBOOTWIN)&&pants.position.x==PANTSWIN.origin.x+PANTSWIN.size.width/2){
                move=[CCMoveTo actionWithDuration:.5 position:ccp(LBOOTWIN.origin.x+LBOOTWIN.size.width/2, LBOOTWIN.origin.y+LBOOTWIN.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:.5 position:ccp(697, 768-564)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [leftBoot runAction:move];
            break;
        default:
            break;
    }
    moving=NO;
    for (int i = 0; i < 5; i++)
        if ([[self.things objectAtIndex:i] intValue]==0){
            stopShaking = YES;
            handShaking = NO;
            return;
        }
    if (!doubleAction){
        [[SimpleAudioEngine sharedEngine] playEffect:@"4.2 Spasibo.wav"];
        stopShaking = NO;
        [self handShake];
    }
}

- (void)handShake{
    if(handShaking)
        return;
    handShaking = YES;
    [self shakeAnimation];
}

- (void)shakeAnimation{
    if(stopShaking)
        return;
    id forward = [CCRotateBy actionWithDuration:0.3 angle:-15];
    id moveRight = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(-10, -5)];
    id moveLeft  = [CCMoveBy actionWithDuration:0.6 position:CGPointMake(20, 10)];
    id reverse = [CCRotateBy actionWithDuration:0.6 angle:30];
    id forward1 = [CCRotateBy actionWithDuration:0.3 angle:-15];
    id moveRight1 = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(-10, -5)];
    /*
     id forward = [CCRotateTo actionWithDuration:0.3 angle:15];
     id moveRight = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(hand.position.x + 10, hand.position.y - 5)];
     id moveLeft  = [CCMoveTo actionWithDuration:0.6 position:CGPointMake(hand.position.x - 20, hand.position.y + 10)];
     id reverse = [CCRotateTo actionWithDuration:0.6 angle:-15];
     id forward1 = [CCRotateTo actionWithDuration:0.3 angle:0];
     id moveRight1 = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(hand.position.x + 10, hand.position.y - 5)];
     
     
     */
    
    [hand runAction:forward];
    [hand runAction:moveRight];
    [hand performSelector:@selector(runAction:) withObject:reverse afterDelay:0.3];
    [hand performSelector:@selector(runAction:) withObject:moveLeft afterDelay:0.3];
    [hand performSelector:@selector(runAction:) withObject:forward1 afterDelay:0.9];
    [hand performSelector:@selector(runAction:) withObject:moveRight1 afterDelay:0.9];
    [self performSelector:_cmd withObject:nil afterDelay:1.2001];
}

@end
