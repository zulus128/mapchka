//
//  StayLieSitCatScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/10/13.
//
//

#import "StayLieSitCatScene.h"
#import "SimpleAudioEngine.h"
#ifndef ONLYONCE
#define ONLYONCE 1
#include "stdlib.h"
#endif

static int gameId = LOG_GAME_CAT_5;

@interface StayLieSitCatScene (){
    CCLayer *sitCat;
    CCLayer *stayCat;
    CCLayer *lieCat;
    CGPoint positions[6][3];
    int nowPos;
    bool actRun[3];\
    int question;
    BOOL allow_touch;
}

@end

@implementation StayLieSitCatScene

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    StayLieSitCatScene *layer=[StayLieSitCatScene node];
    [scene addChild:layer];
    return scene;
}
/*
 1,2,3;
 1,3,2;
 2,1,3;
 2,3,1;
 3,1,2;
 3,2,1;
 */

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        positions[0][0]=ccp(220.0-353.0/2, 520.0-425.0/2);
        positions[0][1]=ccp(775.0-467.0/2, 520.0-418.0/2);
        positions[0][2]=ccp(520.0-936.0/4, 173.0-294.0/2);
        
        positions[1][0]=ccp(220.0-353.0/2, 520.0-425.0/2);
        positions[1][1]=ccp(520.0-936.0/4, 173.0-294.0/2);
        positions[1][2]=ccp(775.0-467.0/2, 520.0-418.0/2);
        
        positions[2][0]=ccp(775.0-467.0/2, 520.0-418.0/2);
        positions[2][1]=ccp(220.0-353.0/2, 520.0-425.0/2);
        positions[2][2]=ccp(520.0-936.0/4, 173.0-294.0/2);
        
        positions[3][0]=ccp(775.0-467.0/2, 520.0-418.0/2);
        positions[3][1]=ccp(220.0-353.0/2, 520.0-425.0/2);
        positions[3][2]=ccp(520.0-936.0/4, 173.0-294.0/2);
        
        positions[4][0]=ccp(520.0-936.0/4, 173.0-294.0/2);
        positions[4][1]=ccp(220.0-353.0/2, 520.0-425.0/2);
        positions[4][2]=ccp(775.0-467.0/2, 520.0-418.0/2);
        
        positions[5][0]=ccp(520.0-936.0/4, 173.0-294.0/2);
        positions[5][1]=ccp(775.0-467.0/2, 520.0-418.0/2);
        positions[5][2]=ccp(220.0-353.0/2, 520.0-425.0/2);
        
        nowPos=0;
        
        actRun[0]=false;
        actRun[1]=false;
        actRun[2]=false;
        //set bg
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg];
        //add back btn
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
        //lets build sit cat
        //its size is (353,425)
        sitCat=[CCLayer node];
        sitCat.contentSize=CGSizeMake(353, 425);
        sitCat.anchorPoint=ccp(0.5, 0.5);
        sitCat.scale=0.8;
        CCSprite *sitBody=[CCSprite spriteWithFile:@"sitCatBody.png"];
        sitBody.position=ccp(sitCat.contentSize.width/2, 136.0);
        [sitCat addChild:sitBody];
        CCSprite *sitHead=[CCSprite spriteWithFile:@"sitCatHead.png"];
        sitHead.position=ccp(241.0, 301.0);
        [sitCat addChild:sitHead z:0 tag:50];
        sitCat.position=positions[0][0];
        [self addChild:sitCat];
        //lets build standingCat
        stayCat=[CCLayer node];
        stayCat.contentSize=CGSizeMake(467, 418);
        stayCat.anchorPoint=ccp(0.5, 0.5);
        stayCat.scale=0.8;
        CCSprite *stayTail=[CCSprite spriteWithFile:@"stayCatTail.png"];
        stayTail.position=ccp(388, 306-stayTail.contentSize.height*0.4);
        stayTail.anchorPoint=ccp(0.5, 0.1);
        [stayCat addChild:stayTail z:0 tag:50];
        CCSprite *stayBody=[CCSprite spriteWithFile:@"stayCatBody.png"];
        stayBody.position=ccp(220, 200);
        [stayCat addChild:stayBody];
        stayCat.position=positions[0][1];
        [self addChild:stayCat];
        //lets build lying cat
        lieCat=[CCLayer node];
        lieCat.contentSize=CGSizeMake(936.0/2, 294.0);
        lieCat.anchorPoint=ccp(0.5, 0.5);
        lieCat.scale=0.8;
        CCSprite *lieRightEar=[CCSprite spriteWithFile:@"lieEarLeft.png"];
        lieRightEar.position=ccp(114.0/2 - 25, 147.0);
        [lieCat addChild:lieRightEar z:0 tag:56];
        CCSprite *lieBody=[CCSprite spriteWithFile:@"lieBody.png"];
        lieBody.position=ccp(512.0/2, 147.0);
        [lieCat addChild:lieBody z:0 tag:53];
        CCSprite *lieHead=[CCSprite spriteWithFile:@"lieHead.png"];
        lieHead.position=ccpAdd(lieBody.position, ccp(-256+130, -105+63));
        [lieCat addChild:lieHead z:0 tag:54];
        CCSprite *lieTail=[CCSprite spriteWithFile:@"lieTail.png"];
        lieTail.position=ccpAdd(lieBody.position, ccp(94-45, -160+65));
        [lieCat addChild:lieTail z:0 tag:57];
        CCSprite *lieLeftEar=[CCSprite spriteWithFile:@"lieEarRight.png"];
        lieLeftEar.position=ccp(361.0/2 - 25, 218.0);
        [lieCat addChild:lieLeftEar z:0 tag:55];
        lieCat.position=positions[0][2];
        [self addChild:lieCat];
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"StayLieCatScene deallocing.");
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnter{
    //[self schedule:@selector(randomizeCats) interval:4.0];
    [super onEnter];
    [Flurry logEvent:@"CatGame5" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_5, YES);
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [self playQuestion];
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allow_touch = YES;
    });
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [self unscheduleAllSelectors];
    [super onExit];
    [Flurry endTimedEvent:@"CatGame5" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_5);
}

-(void)tapSitting{
    CCSprite *head=(CCSprite*)[sitCat getChildByTag:50];
    CCAction *spin=[CCRotateBy actionWithDuration:0.2 angle:15.0];
    CCAction *backSpin=[CCRotateBy actionWithDuration:0.2 angle:-15.0];
    CCAction *move=[CCMoveBy actionWithDuration:0.2 position:ccp(12.0, -10.0)];
    CCAction *backMove=[CCMoveBy actionWithDuration:0.2 position:ccp(-12.0, 10.0)];
    [head runAction:spin];
    [head runAction:move];
    [head performSelector:@selector(runAction:) withObject:backSpin afterDelay:0.25];
    [head performSelector:@selector(runAction:) withObject:backMove afterDelay:0.25];
    actRun[0]=1;
    [self performSelector:@selector(resetActRun:) withObject:@(0) afterDelay:0.5];
}

-(void)tapStaying{
    CCSprite *tail=(CCSprite*)[stayCat getChildByTag:50];
    CCAction *rot=[CCRotateBy actionWithDuration:0.2 angle:15.0];
    CCAction *backRot=[CCRotateBy actionWithDuration:0.2 angle:-15.0];
    [tail runAction:rot];
    [tail performSelector:@selector(runAction:) withObject:backRot afterDelay:0.25];
    actRun[1]=1;
    [self performSelector:@selector(resetActRun:) withObject:@(1) afterDelay:0.5];
}

-(void)tapLying{
    CCSprite *body=(CCSprite*)[lieCat getChildByTag:53];
    CCSprite *head=(CCSprite*)[lieCat getChildByTag:54];
    CCSprite *tail=(CCSprite*)[lieCat getChildByTag:57];
    CCSprite *left=(CCSprite*)[lieCat getChildByTag:55];
    CCSprite *right=(CCSprite*)[lieCat getChildByTag:56];
    actRun[2]=1;
    id scaling=[CCScaleBy actionWithDuration:0.8 scaleX:1.0 scaleY:1.025];
    id moving=[CCMoveBy actionWithDuration:0.8 position:ccp(0, 8.0)];
    id halfMove=[CCMoveBy actionWithDuration:0.8 position:ccp(0, 6.0)];
    [body runAction:scaling];
    [body runAction:moving];
    [head runAction:halfMove];
    [tail runAction:[moving copy]];
    [left runAction:[halfMove copy]];
    [right runAction:[halfMove copy]];
    id revMove=[moving reverse];
    id revMove2=[halfMove reverse];
    [body performSelector:@selector(runAction:) withObject:[scaling reverse] afterDelay:0.85];
    [body performSelector:@selector(runAction:) withObject:revMove afterDelay:0.85];
    [head performSelector:@selector(runAction:) withObject:revMove2 afterDelay:0.85];
    [tail performSelector:@selector(runAction:) withObject:[revMove copy] afterDelay:0.85];
    [left performSelector:@selector(runAction:) withObject:[revMove2 copy] afterDelay:0.85];
    [right performSelector:@selector(runAction:) withObject:[revMove2 copy] afterDelay:0.85];
    [self performSelector:@selector(resetActRun:) withObject:@(2) afterDelay:1.7];
}

-(void)resetLying{
    //    CCSprite *bodyUp=(CCSprite*)[lieCat getChildByTag:54];
    //    CCSprite *body=(CCSprite*)[lieCat getChildByTag:53];
    //    CCSprite *left=(CCSprite*)[lieCat getChildByTag:55];
    //    CCSprite *right=(CCSprite*)[lieCat getChildByTag:56];
    //    bodyUp.visible=NO;
    //    body.visible=YES;
    //    left.position=ccpAdd(left.position, ccp(-5, -5));
    //    right.position=ccpAdd(right.position, ccp(-5, -5));
}

-(void)resetActRun:(NSNumber*)num{
    actRun[[num integerValue]]=0;
}

-(void)randomizeCats{
    int rand=nowPos;
    while (rand==nowPos) {
        rand=arc4random_uniform(5);
    }
    CCAction *moveSit=[CCMoveTo actionWithDuration:1.0 position:positions[rand][0]];
    CCAction *moveStay=[CCMoveTo actionWithDuration:1.0 position:positions[rand][1]];
    CCAction *moveLie=[CCMoveTo actionWithDuration:1.0 position:positions[rand][2]];
    [sitCat runAction:moveSit];
    [stayCat runAction:moveStay];
    [lieCat runAction:moveLie];
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!allow_touch)
        return;
    allow_touch = NO;
    
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(sitCat.boundingBox, loc)&&!actRun[0]){
        if (question==0){
            [self tapSitting];
            [self playRight];
            question++;
        }
        else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
        }
    }else if (CGRectContainsPoint(stayCat.boundingBox, loc)&&!actRun[1]){
        if (question==1){
            [self tapStaying];
            [self playRight];
            question++;
        }
        else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
        }
    }else if (CGRectContainsPoint(lieCat.boundingBox, loc)&&!actRun[2]){
        if (question==2){
            [self tapLying];
            [self playRight];
            question++;
        }
        else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
        }
    }
    if (question == 3){
        question = 0;
        [self randomizeCats];
    }
    [self scheduleOnce:@selector(playQuestion) delay:2];
}


-(void)playRight{
    int change = rand()%2;
    switch (change) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"5.5 Pravilno.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.5 Molodec.wav"];
            break;
        default:
            break;
    }
}
-(void)playQuestion{
    switch (question) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"6.1 Kakoi1.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"6.2 Kakoi2.wav"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"6.3 Kakoi3.wav"];
            break;
        default:
            break;
    }
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allow_touch = YES;
    });
}
@end
