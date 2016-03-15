//
//  Bird.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/15/13.
//
//

#import "Bird.h"

#define LOGANCHOR(obj) CCLOG(@"Anchor: %f,%f", obj.anchorPoint.x, obj.anchorPoint.y)
#define LOGPOS(obj) CCLOG(@"Pos: %f,%f", obj.position.x, obj.position.y)

#define WINGS_ROT 18.0
#define TAIL_ROT 14.0

#define HEAD_ROT 20.0

#define VELOCITY 500.0

@interface Bird (){
    CCSprite *head;
    CCSprite *body;
    CCSprite *legs;
    CCSprite *lLeg;
    CCSprite *rLeg;
    CCSprite *tail;
    //eyes
    CCSprite *eyesStraight;
    CCSprite *eyesLeft;
    CCSprite *eyesClosed;
    //wings
    CCSprite *wingRight;
    CCSprite *wingLeft;
    //
    CCSprite *mouthOpen;
    CCSprite *mouthClose;
    //
    BOOL headBobling;
}

@end

@implementation Bird
@synthesize delegate=_delegate, body=body, wingLeft=wingLeft, wingRight=wingRight, mouth=mouthOpen, tail=tail, head=head, lLeg=lLeg, rLeg=rLeg;

- (void)rightLegUp{
    if (!rLeg.visible) return;
    rLeg.visible=NO;
    CCSprite *legUp=[CCSprite spriteWithFile:@"birdLegRUp.png"];
    legUp.position=ccp(324, 52);
    [self addChild:legUp z:0 tag:11];
    [self scheduleOnce:@selector(restoreRightLeg) delay:1.0];
}

-(void)restoreRightLeg{
    [self removeChildByTag:11 cleanup:YES];
    rLeg.visible=YES;
}

-(void)leftLegUp{
    if (!lLeg.visible) return;
    lLeg.visible=NO;
    CCSprite *legUp=[CCSprite spriteWithFile:@"birdLegLUp.png"];
    legUp.position=ccp(244, 74);
    [self addChild:legUp z:0 tag:10];
    [self scheduleOnce:@selector(restoreLeftLeg) delay:1.0];
}

-(void)restoreLeftLeg{
    [self removeChildByTag:10 cleanup:YES];
    lLeg.visible=YES;
}

- (void)lookLeft{
    eyesLeft.visible=YES;
    eyesStraight.visible=NO;
}

-(void)lookStraight{
    eyesLeft.visible=NO;
    eyesStraight.visible=YES;
}

-(void)headSwipe{
    if (headBobling) return;
    headBobling=YES;
    id spin=[CCRotateBy actionWithDuration:0.2 angle:HEAD_ROT];
    id dSpin=[CCRotateBy actionWithDuration:0.4 angle:HEAD_ROT*2];
    [head runAction:[spin reverse]];
    [head performSelector:@selector(runAction:) withObject:dSpin afterDelay:0.25];
    [head performSelector:@selector(runAction:) withObject:[spin reverse] afterDelay:0.7];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        headBobling=NO;
    });
}

-(void)jump{
    id move=[CCMoveBy actionWithDuration:0.5 position:ccp(0, 70)];
    id revMove=[move reverse];
    [self runAction:move];
    [self wingsOne];
    [self performSelector:@selector(runAction:) withObject:revMove afterDelay:.5];
    
    if ([_delegate respondsToSelector:@selector(birdStartJump)])
        [_delegate birdStartJump];
    if ([_delegate respondsToSelector:@selector(birdEndJump)])
        [(CCNode*)_delegate scheduleOnce:@selector(birdEndJump) delay:1.2];
}

-(void)jumpAndMoveTo:(CGPoint)loc{
    float dist=loc.x-self.position.x;
    if (dist>0)
        self.scaleX=-1;
    else if (dist<0)
        self.scaleX=1;
    id move=[CCMoveBy actionWithDuration:0.5 position:ccp(dist/2, 70)];
    id revMove=[CCMoveBy actionWithDuration:.5 position:ccp(dist/2, -70)];
    [self runAction:move];
    [self wingsOne];
    [self scheduleOnce:@selector(wingsOne) delay:0.7];
    [self performSelector:@selector(runAction:) withObject:revMove afterDelay:.5];
    
    if ([_delegate respondsToSelector:@selector(birdFlyingAndMoving)])
        [_delegate birdFlyingAndMoving];
    if ([_delegate respondsToSelector:@selector(birdFlewAndMoved)])
        [(CCNode*)_delegate scheduleOnce:@selector(birdFlewAndMoved) delay:1.4];
}

-(void)wingsOne{
    id downRight=[CCRotateBy actionWithDuration:0.3 angle:-WINGS_ROT*3/2];
    id downLeft=[CCRotateBy actionWithDuration:0.3 angle:WINGS_ROT*3/2];
    id revRight=[downRight reverse];
    id revLeft=[downLeft reverse];
    [wingRight runAction:downRight];
    [wingLeft runAction:downLeft];
    [wingRight performSelector:@selector(runAction:) withObject:revRight afterDelay:0.3];
    [wingLeft performSelector:@selector(runAction:) withObject:revLeft afterDelay:0.3];
}

-(void)wingsAnimate{
    id downRight=[CCRotateBy actionWithDuration:0.3 angle:-WINGS_ROT];
    id downLeft=[CCRotateBy actionWithDuration:0.3 angle:WINGS_ROT];
    id doubleUpRight=[CCRotateBy actionWithDuration:0.8 angle:2*WINGS_ROT];
    id doubleUpLeft=[CCRotateBy actionWithDuration:0.8 angle:-2*WINGS_ROT];
    id revDoubleRight=[doubleUpRight reverse];
    id revDoubleLeft=[doubleUpLeft reverse];
    id revRight=[downRight reverse];
    id revLeft=[downLeft reverse];
    [wingRight runAction:downRight];
    [wingLeft runAction:downLeft];
    [wingRight performSelector:@selector(runAction:) withObject:doubleUpRight afterDelay:0.3];
    [wingLeft performSelector:@selector(runAction:) withObject:doubleUpLeft afterDelay:0.3];
    [wingRight performSelector:@selector(runAction:) withObject:revDoubleRight afterDelay:1.1];
    [wingLeft performSelector:@selector(runAction:) withObject:revDoubleLeft afterDelay:1.1];
    [wingRight performSelector:@selector(runAction:) withObject:revRight afterDelay:1.9];
    [wingLeft performSelector:@selector(runAction:) withObject:revLeft afterDelay:1.9];
    if ([_delegate respondsToSelector:@selector(birdStartWingFly)])
        [_delegate birdStartWingFly];
    if ([_delegate respondsToSelector:@selector(birdEndWingFly)])
        [(CCNode*)_delegate scheduleOnce:@selector(birdEndWingFly) delay:3];
}

-(void)blinkEyes{
    [self schedule:@selector(blink) interval:2.5];
}

-(void)stopBlinking{
    [self unschedule:@selector(blinkEyes)];
}

-(void)blink{
    eyesStraight.visible=NO;
    eyesLeft.visible=NO;
    eyesClosed.visible=YES;
    [self scheduleOnce:@selector(unblink) delay:0.25];
}

-(void)unblink{
    eyesStraight.visible=YES;
    eyesLeft.visible=NO;
    eyesClosed.visible=NO;
}

-(void)chickChirick{
    [self chickIt];
    [self schedule:@selector(chickIt) interval:0.8];
    [self scheduleOnce:@selector(globalUnchick) delay:3.0];
    
    if ([_delegate respondsToSelector:@selector(birdStartChirick)])
        [_delegate birdStartChirick];
    if ([_delegate respondsToSelector:@selector(birdEndChirick)])
        [(CCNode*)_delegate scheduleOnce:@selector(birdEndChirick) delay:3.5];
}

-(void)globalUnchick{
    [self unschedule:@selector(chickIt)];
}

-(void)chickIt{
    mouthClose.visible=NO;
    mouthOpen.visible=YES;
    [self scheduleOnce:@selector(unchickIt) delay:0.4];
}

-(void)unchickIt{
    mouthOpen.visible=NO;
    mouthClose.visible=YES;
}

-(void)swipeTail{
    id rot=[CCRotateBy actionWithDuration:0.4 angle:TAIL_ROT];
    id revRot=[rot reverse];
    [tail runAction:rot];
    [tail performSelector:@selector(runAction:) withObject:revRot afterDelay:0.4];
    if ([_delegate respondsToSelector:@selector(birdStartTail)])
        [_delegate birdStartTail];
    if ([_delegate respondsToSelector:@selector(birdEndTail)])
        [(CCNode*)_delegate scheduleOnce:@selector(birdEndTail) delay:0.8];
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        headBobling=NO;
        //bird size (486,575);
        self.contentSize=CGSizeMake(486,575);
        self.anchorPoint=ccp(0.5, 0);
        self.ignoreAnchorPointForPosition=NO;
        
        head=[CCSprite spriteWithFile:@"birdHead.png"];
        head.anchorPoint=ccp(0.5, 0.05);
        head.position=ccp(237, 575-(226-81) - head.contentSize.height*0.45);
        
        body=[CCSprite spriteWithFile:@"birdBody.png"];
        body.position=ccp(267, 575-367);
        
//        legs=[CCSprite spriteWithFile:@"birdLegs.png"];
//        legs.position=ccp(280, 66);
//        legs.anchorPoint=ccp(0.5, 0.5);
//        legs.visible=NO;
        lLeg=[CCSprite spriteWithFile:@"birdLegL.png"];
        lLeg.position=ccp(251, 61);
        lLeg.anchorPoint=ccp(.5, .5);
        CCLOG(@"BIRD LLEG X=%f", lLeg.position.x);
        rLeg=[CCSprite spriteWithFile:@"birdLegR.png"];
        rLeg.position=ccp(343, 54);
        rLeg.anchorPoint=ccp(.5, .5);
        CCLOG(@"BIRD RLEG X=%f", rLeg.position.x);
        
        tail=[CCSprite spriteWithFile:@"birdTail.png"];
        tail.position=ccp(420-tail.contentSize.width*0.45, 575-447 + tail.contentSize.height*0.05);
        tail.anchorPoint=ccp(0.05, 0.55);
        
        eyesStraight=[CCSprite spriteWithFile:@"birdEyesStraight.png"];
        eyesStraight.position=ccp(head.position.x-183+32, 575-177 - head.position.y + 17);
        eyesStraight.visible=YES;
        eyesLeft=[CCSprite spriteWithFile:@"birdEyesLeft.png"];
        eyesLeft.position=ccp(head.position.x-183+41, 575-177 - head.position.y + 17);
        eyesLeft.visible=NO;
        eyesClosed=[CCSprite spriteWithFile:@"birdEyesClose.png"];
        eyesClosed.position=ccp(head.position.x-182+30, 575-182-head.position.y + 15);
        eyesClosed.visible=NO;
        
        wingRight=[CCSprite spriteWithFile:@"birdWingRight.png"];
        wingRight.position=ccp(105+wingRight.contentSize.width*0.3, 575-368+wingRight.contentSize.height*0.4+22);
        wingRight.anchorPoint=ccp(0.8, 0.9);
        
        wingLeft=[CCSprite spriteWithFile:@"birdWingLeft.png"];
        wingLeft.position=ccp(375-wingLeft.contentSize.width*0.4, 575-346+wingLeft.contentSize.height*0.4+5);
        wingLeft.anchorPoint=ccp(0.1, 0.9);
        
        mouthOpen=[CCSprite spriteWithFile:@"birdMouthOpen.png"];
        mouthOpen.position=ccp(head.position.x-173+11, 575-212-head.position.y+14);
        mouthOpen.visible=NO;
        mouthClose=[CCSprite spriteWithFile:@"birdMouthClose.png"];
        mouthClose.position=ccp(head.position.x-173+11, 575-205-head.position.y+14);
        mouthClose.visible=YES;
        
        [self addChild:wingRight];
        [self addChild:tail];
        [self addChild:body];
        [self addChild:wingLeft];
        [self addChild:head];
        [head addChild:mouthOpen];
        [head addChild:mouthClose];
//        [self addChild:legs];
        [self addChild:lLeg];
        [self addChild:rLeg];
        [head addChild:eyesStraight];
        [head addChild:eyesLeft];
        [head addChild:eyesClosed];
    }
    return self;
}

-(void)informDelegateOf:(SEL)selector{
    if ([_delegate respondsToSelector:selector])
        [_delegate performSelector:selector];
}

@end
