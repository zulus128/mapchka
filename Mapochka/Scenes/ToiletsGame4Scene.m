//
//  ToiletsGame4Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/22/13.
//
//

#import "ToiletsGame4Scene.h"
#import "SimpleAudioEngine.h"

#define SWEATEROK CGRectMake(318,768-803/2,1256/2 - 318, (803-393)/2)
#define PANTSOK CGRectMake(783/2, 768-1326/2, 1106/2-783/2, (1326-409)/2)
#define LSOCKOK CGRectMake(809/2, 768-1396/2, 938/2-809/2, 1396/2-1226/2)
#define RSOCKOK CGRectMake(984/2, 768-1396/2, 1133/2-984/2, 1396/2-1226/2)
#define LBOOTOK CGRectMake(803/2, 768-1408/2, 942/2-803/2, 1408/2-1284/2)
#define RBOOTOK CGRectMake(984/2, 768-1408/2, 1137/2-984/2, 1408/2-1284/2)

static int gameId = LOG_GAME_TOILET_4;

@interface ToiletsGame4Scene (){
    CCSprite *boy;
    CCSprite *hand;
    CCSprite *eyes;
    CCSprite *pants;
    CCSprite *sweater;
    CCSprite *leftSock;
    CCSprite *rightSock;
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

@implementation ToiletsGame4Scene

-(void)createGame{
    boy=[CCSprite spriteWithFile:@"tGame4Boy.png"];
    hand=[CCSprite spriteWithFile:@"tGame4Hand.png"];
    eyes=[CCSprite spriteWithFile:@"tGame4Eyes.png"];
    sweater=[CCSprite spriteWithFile:@"tGame4Sweater.png"];
    pants=[CCSprite spriteWithFile:@"tGame4Pants.png"];
    leftSock=[CCSprite spriteWithFile:@"tGame4LSock.png"];
    rightSock=[CCSprite spriteWithFile:@"tGame4RSock.png"];
    leftBoot=[CCSprite spriteWithFile:@"tGame4LBoot.png"];
    rightBoot=[CCSprite spriteWithFile:@"tGame4RBoot.png"];
    //
    boy.position=ccp(480, 768-368);
    hand.position=ccp(620, 768-206);
    eyes.position=ccp(483, 768-143);
    eyes.visible=NO;
    sweater.position=ccp(808, 768-412);
    pants.position=ccp(171, 768-281);
    leftSock.position=ccp(752, 768-143);
    rightSock.position=ccp(845, 768-118);
    leftBoot.position=ccp(125, 768-584);
    rightBoot.position=ccp(231, 768-584);
    //
    [self addChild:boy];
    [self addChild:hand];
    [self addChild:eyes];
    [self addChild:leftSock];
    [self addChild:rightSock];
    [self addChild:leftBoot];
    [self addChild:rightBoot];
    [self addChild:sweater];
    [self addChild:pants];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletsGame4Scene *layer=[ToiletsGame4Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"tGame4Bg.jpg"];
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
    [Flurry logEvent:@"ToiletGame4" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_TOILET_4, YES);
    [self schedule:@selector(blink) interval:3.0];
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"4.1 Pomogi.wav"];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"ToiletGame4" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_TOILET_4);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleAllSelectors];
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
        for (int i = 0; i<6; i++)
            [self.
             things addObject:[NSNumber numberWithInt:0]];
        
    }
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(sweater.boundingBox, loc) && [[self.things objectAtIndex:1]intValue]==0){
        movNum=1;
        moving=YES;
    }else if (CGRectContainsPoint(pants.boundingBox, loc) && [[self.things objectAtIndex:5]intValue]==0 && [[self.things objectAtIndex:4]intValue]==0){
        movNum=2;
        moving=YES;
    }else if(CGRectContainsPoint(rightBoot.boundingBox, loc)){
        movNum=5;
        moving=YES;
    }else if (CGRectContainsPoint(leftBoot.boundingBox, loc)){
        movNum=6;
        moving=YES;
    }else if(CGRectContainsPoint(leftSock.boundingBox, loc) && [[self.things objectAtIndex:5]intValue]==0){
        movNum=3;
        moving=YES;
    }else if (CGRectContainsPoint(rightSock.boundingBox, loc) && [[self.things objectAtIndex:4]intValue]==0){
        movNum=4;
        moving=YES;
    }
    return moving;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    switch (movNum) {
        case 1:
            sweater.position=loc;
            break;
        case 2:
            pants.position=loc;
            break;
        case 3:
            leftSock.position=loc;
            break;
        case 4:
            rightSock.position=loc;
            break;
        case 5:
            rightBoot.position=loc;
            break;
        case 6:
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
            if (CGRectIntersectsRect(sweater.boundingBox, SWEATEROK)){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(SWEATEROK.origin.x+SWEATEROK.size.width/2, SWEATEROK.origin.y+SWEATEROK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(808, 768-412)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [sweater runAction:move];
            break;
        case 2:
            if (CGRectIntersectsRect(pants.boundingBox, PANTSOK)&&sweater.position.x==SWEATEROK.origin.x+SWEATEROK.size.width/2){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(PANTSOK.origin.x+PANTSOK.size.width/2, PANTSOK.origin.y+PANTSOK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(171, 768-281)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [pants runAction:move];
            break;
        case 3:
            if (CGRectIntersectsRect(leftSock.boundingBox, LSOCKOK)){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(LSOCKOK.origin.x+LSOCKOK.size.width/2, LSOCKOK.origin.y+LSOCKOK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(752, 768-143)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [leftSock runAction:move];
            break;
        case 4:
            if (CGRectIntersectsRect(rightSock.boundingBox, RSOCKOK)){
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(RSOCKOK.origin.x+RSOCKOK.size.width/2, RSOCKOK.origin.y+RSOCKOK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:0.5 position:ccp(845, 768-118)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [rightSock runAction:move];
            break;
        case 5:
            if (CGRectIntersectsRect(rightBoot.boundingBox, RBOOTOK) &&
                rightSock.position.x==RSOCKOK.origin.x+RSOCKOK.size.width/2 &&
                [[self.things objectAtIndex:1] intValue]==1){
                
                move=[CCMoveTo actionWithDuration:.5 position:ccp(RBOOTOK.origin.x+RBOOTOK.size.width/2, RBOOTOK.origin.y+RBOOTOK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:.5 position:ccp(231, 768-584)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [rightBoot runAction:move];
            break;
        case 6:
            if (CGRectIntersectsRect(leftBoot.boundingBox, LBOOTOK) &&
                leftSock.position.x==LSOCKOK.origin.x+LSOCKOK.size.width/2 &&
                [[self.things objectAtIndex:1] intValue]==1){
                move=[CCMoveTo actionWithDuration:.5 position:ccp(LBOOTOK.origin.x+LBOOTOK.size.width/2, LBOOTOK.origin.y+LBOOTOK.size.height/2)];
                if ([[self.things objectAtIndex:movNum-1]intValue] == 1){
                    doubleAction = YES;
                }
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:1]];
            }else{
                move=[CCMoveTo actionWithDuration:.5 position:ccp(125, 768-584)];
                [self.things replaceObjectAtIndex:movNum-1 withObject:[NSNumber numberWithInt:0]];
            }
            [leftBoot runAction:move];
            break;
        default:
            break;
    }
    moving=NO;
    
    for (int i = 0; i < 6; i++)
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
    id forward = [CCRotateBy actionWithDuration:0.3 angle:15];
    id moveRight = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(10, -5)];
    id moveLeft  = [CCMoveBy actionWithDuration:0.6 position:CGPointMake(-20, 10)];
    id reverse = [CCRotateBy actionWithDuration:0.6 angle:-30];
    id forward1 = [CCRotateBy actionWithDuration:0.3 angle:15];
    id moveRight1 = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(10, -5)];
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
