//
//  Kot.m
//  Mapochka
//
//  Created by Nikita Anisimov on 2/7/13.
//
//

#import "Kot.h"

#define LOGANCHOR(obj) CCLOG(@"Anchor: %f,%f", obj.anchorPoint.x, obj.anchorPoint.y)
#define LOGPOS(obj) CCLOG(@"Pos: %f,%f", obj.position.x, obj.position.y)

#define BASEROTH -30.0
#define BASEROTL -24.0

#define MIN_STEP 170.0

#define SWIPE_LEN 50.0

@interface Kot (){
    CCSprite *tongue;
    CCSprite *body;
    CCSprite *head;
    CCSprite *headThx;
    CCSprite *leg1;//left back
    CCSprite *leg2;//right back
    CCSprite *hand1;//left front
    CCSprite *hand2;//right front
    CCSprite *tail;
    CCSprite *eyelids;
    //other
    NSUInteger totalSteps;
    NSUInteger steps;
    CGPoint firstTouch;
    CGPoint lastTouch;
    //bools
    
}

@property (nonatomic,readwrite) kRotation orientation;

-(void)rotateForw;
-(void)rotateBackw;

@end

@implementation Kot
@synthesize delegate=_delegate, tail=tail, head=head, frontLeg=hand1, rearLeg=leg1;

-(void)leftFootUp{
    if (!hand1.visible) return;
    hand1.visible=NO;
    CCSprite *handUp=[CCSprite spriteWithFile:@"legFrontUp.png"];
    handUp.position=ccp(145, 150);
    [self addChild:handUp z:0 tag:10];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeChildByTag:10 cleanup:YES];
        hand1.visible=YES;
    });
}

-(void)rightFootUp{
    if (!leg1.visible) return;
    leg1.visible=NO;
    CCSprite *legUp=[CCSprite spriteWithFile:@"legBackUp.png"];
    legUp.position=ccp(450,150);
    [self addChild:legUp z:0 tag:11];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeChildByTag:11 cleanup:YES];
        leg1.visible=YES;
    });
}

-(void)rotateCatTo:(kRotation)rotato{
    switch (rotato) {
        case kRight:
            if (self.scaleX>0)
                self.scaleX*=-1;
            self.orientation=kRight;
            break;
        case kLeft:
            if (self.scaleX<0)
                self.scaleX*=-1;
            self.orientation=kLeft;
            break;
        default:
            CCLOG(@"OHH SHIT!");
            break;
    }
}

//276x251
//567x425

-(void)rotateForw{
    id rotateHand1=[CCRotateTo actionWithDuration:0.5 angle:BASEROTH+30.0];
    id rotateHand2=[CCRotateTo actionWithDuration:0.5 angle:BASEROTH-30.0];
    id rotateLeg1=[CCRotateTo actionWithDuration:0.5 angle:BASEROTL+24.0];
    id rotateLeg2=[CCRotateTo actionWithDuration:0.5 angle:BASEROTL-24.0];
    [hand1 runAction:rotateHand1];
    [hand2 runAction:rotateHand2];
    [leg1 runAction:rotateLeg1];
    [leg2 runAction:rotateLeg2];
    if (steps==totalSteps-1){
        [self scheduleOnce:@selector(beforeBend) delay:0.5];
    }else{
        [self scheduleOnce:@selector(rotateBackw) delay:0.5];
    }
    
    if ([_delegate respondsToSelector:@selector(kotStepnul)]&&[_delegate isKindOfClass:[CCNode class]]){
        [(CCNode*)_delegate scheduleOnce:@selector(kotStepnul) delay:0.25];
    }
}

-(void)rotateBackw{
    id rotateHand1=[CCRotateTo actionWithDuration:0.5 angle:BASEROTH-30.0];
    id rotateHand2=[CCRotateTo actionWithDuration:0.5 angle:BASEROTH+30.0];
    id rotateLeg1=[CCRotateTo actionWithDuration:0.5 angle:BASEROTL-24.0];
    id rotateLeg2=[CCRotateTo actionWithDuration:0.5 angle:BASEROTL+24.0];
    [hand1 runAction:rotateHand1];
    [hand2 runAction:rotateHand2];
    [leg1 runAction:rotateLeg1];
    [leg2 runAction:rotateLeg2];
    steps++;
    if (steps<totalSteps)
        [self scheduleOnce:@selector(rotateForw) delay:0.5];
    else{
        steps=0;
        [self scheduleOnce:@selector(stopTheWalk) delay:0.5];
    }
    
    if ([_delegate respondsToSelector:@selector(kotStepnul)]&&[_delegate isKindOfClass:[CCNode class]]){
        [(CCNode*)_delegate scheduleOnce:@selector(kotStepnul) delay:0.25];
    }
}

-(void)beforeBend{
    id rotateHand1=[CCRotateTo actionWithDuration:0.3 angle:BASEROTH];
    id rotateHand2=[CCRotateTo actionWithDuration:0.3 angle:BASEROTH];
    id rotateLeg1=[CCRotateTo actionWithDuration:0.3 angle:BASEROTL];
    id rotateLeg2=[CCRotateTo actionWithDuration:0.3 angle:BASEROTL];
    [hand1 runAction:rotateHand1];
    [hand2 runAction:rotateHand2];
    [leg1 runAction:rotateLeg1];
    [leg2 runAction:rotateLeg2];
    steps=0;
    [self scheduleOnce:@selector(stopTheWalk) delay:0.3];
    
    if ([_delegate respondsToSelector:@selector(kotStepnul)]&&[_delegate isKindOfClass:[CCNode class]]){
        [(CCNode*)_delegate scheduleOnce:@selector(kotStepnul) delay:0.25];
    }
}

-(void)moveSelf{
    
}

-(void)bend{
    id rotateBody=[CCRotateBy actionWithDuration:.5 angle:-10.5];
    id rotateHead=[CCRotateBy actionWithDuration:.5 angle:-28.3];
    id moveHead=[CCMoveBy actionWithDuration:.5 position:ccp(-24, -80)];
    id rotateHand1=[CCRotateTo actionWithDuration:.5 angle:-9.0];
    id rotateHand2=[CCRotateTo actionWithDuration:.5 angle:-5.0];
    id moveHand1=[CCMoveBy actionWithDuration:.5 position:ccp(25, 0)];
    id moveHand2=[CCMoveBy actionWithDuration:.5 position:ccp(70, 15)];
    id rotateLeg1=[CCRotateTo actionWithDuration:.5 angle:-21.5];
    id rotateLeg2=[CCRotateTo actionWithDuration:.5 angle:-24.0];
    id moveTail=[CCMoveBy actionWithDuration:.5 position:ccp(-10, 30)];
    [body runAction:rotateBody];
    [head runAction:rotateHead];
    [head runAction:moveHead];
    [hand1 runAction:rotateHand1];
    [hand1 runAction:moveHand1];
    [hand2 runAction:rotateHand2];
    [hand2 runAction:moveHand2];
    [leg1 runAction:rotateLeg1];
    [leg2 runAction:rotateLeg2];
    [tail runAction:moveTail];
    //set tongue pos
    [tongue setPosition:ccp(49, 86)];
    [tongue setRotation:-7];
    //send to dele
    if ([_delegate respondsToSelector:@selector(kotBending)])
        [_delegate kotBending];
}

-(void)unbend{
    id rotateBody=[CCRotateBy actionWithDuration:.5 angle:10.5];
    id rotateHead=[CCRotateBy actionWithDuration:.5 angle:28.3];
    id moveHead=[CCMoveBy actionWithDuration:.5 position:ccp(24, 80)];
    id rotateHand1=[CCRotateTo actionWithDuration:.5 angle:BASEROTH];
    id rotateHand2=[CCRotateTo actionWithDuration:.5 angle:BASEROTH];
    id moveHand1=[CCMoveBy actionWithDuration:.5 position:ccp(-25, 0)];
    id moveHand2=[CCMoveBy actionWithDuration:.5 position:ccp(-70, -15)];
    id rotateLeg1=[CCRotateTo actionWithDuration:.5 angle:BASEROTL];
    id rotateLeg2=[CCRotateTo actionWithDuration:.5 angle:BASEROTL];
    id moveTail=[CCMoveBy actionWithDuration:.5 position:ccp(10, -30)];
    [body runAction:rotateBody];
    [head runAction:rotateHead];
    [head runAction:moveHead];
    [hand1 runAction:rotateHand1];
    [hand1 runAction:moveHand1];
    [hand2 runAction:rotateHand2];
    [hand2 runAction:moveHand2];
    [leg1 runAction:rotateLeg1];
    [leg2 runAction:rotateLeg2];
    [tail runAction:moveTail];
    if ([_delegate respondsToSelector:@selector(kotUnBending)])
        [_delegate kotUnBending];
}

-(void)lollipopIt{
    [self schedule:@selector(flickTongue) interval:0.5];
}

-(void)flickTongue{
    [tongue setVisible:YES];
    [self scheduleOnce:@selector(unflick) delay:0.25];
}

-(void)unflick{
    [tongue setVisible:NO];
}

-(void)stopLolli{
    [self unschedule:@selector(flickTongue)];
    [tongue setVisible:NO];
}

-(void)sayThx{
    [head setVisible:NO];
    [headThx setVisible:YES];
    [self schedule:@selector(eyeBlink) interval:2.5];
}

-(void)eatMore{
    [head setVisible:YES];
    [headThx setVisible:NO];
    [self unschedule:@selector(eyeBlink)];
}

-(void)eyeBlink{
    eyelids.visible=YES;
    [self scheduleOnce:@selector(unBlink) delay:0.2];
}

-(void)unBlink{
    eyelids.visible=NO;
}

-(void)walkTo:(CGPoint)pos{
    if (!hand1.visible||!leg1.visible) return;
    CGFloat dist=pos.x-self.position.x;
    if (fabsf(dist)<MIN_STEP/3)
        return;
    dist=fabsf(dist)>MIN_STEP?dist:MIN_STEP;
    totalSteps=roundf(fabsf(dist)/MIN_STEP);
    dist=totalSteps*MIN_STEP*signum(dist);
    ccTime time=fabsf(dist)/MIN_STEP;
    CGFloat resPos=self.position.x+dist;
    CCLOG(@"Should do:\nDistance=%f\nTime=%f\nVelocity=%f\nSteps=%i\nResPos=%f",dist,time,MIN_STEP,totalSteps,resPos);
    steps=0;
    
    [self rotateForw];
    id moves=[CCMoveBy actionWithDuration:time-0.2 position:ccp(dist, 0)];
    [self runAction:moves];
    if ([_delegate respondsToSelector:@selector(kotPoshel)])
        [_delegate kotPoshel];
}

-(void)stopTheWalk{
    if ([_delegate respondsToSelector:@selector(kotPrishel)])
        [_delegate kotPrishel];
}

-(void)tailDance{
    id rot1=[CCRotateBy actionWithDuration:0.2 angle:15.0];
    id rot2=[CCRotateBy actionWithDuration:0.4 angle:-30.0];
    id rotBack=[CCRotateBy actionWithDuration:.2 angle:15.0];
    [tail runAction:rot1];
    [tail performSelector:@selector(runAction:) withObject:rot2 afterDelay:.2];
    [tail performSelector:@selector(runAction:) withObject:rotBack afterDelay:.6];
}

-(void)nod{
    if (!headThx.visible || self.noding.boolValue)
        return;
    if (eyelids.visible)
        eyelids.visible=NO;
    self.noding=@(YES);
    [self unschedule:@selector(eyeBlink)];
    CCAction *spin=[CCRotateBy actionWithDuration:0.2 angle:-15.0];
    CCAction *backSpin=[CCRotateBy actionWithDuration:0.2 angle:15.0];
    CCAction *move=[CCMoveBy actionWithDuration:0.2 position:ccp(-12.0, -10.0)];
    CCAction *backMove=[CCMoveBy actionWithDuration:0.2 position:ccp(12.0, 10.0)];
    [headThx runAction:spin];
    [headThx runAction:move];
    [headThx performSelector:@selector(runAction:) withObject:backSpin afterDelay:0.25];
    [headThx performSelector:@selector(runAction:) withObject:[backMove copy] afterDelay:0.25];
    [self schedule:@selector(eyeBlink) interval:2.5];
//    [self performSelector:@selector(invertBool:) withObject:noding afterDelay:0.6];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.noding=@(NO);
    });
}

-(void)invertBoolNumber:(NSNumber*)toInv{
    toInv=@(!toInv.boolValue);
}

-(id)init{
    if (self=[super init]){
        self.isTouchEnabled=YES;
        steps=0;
        self.noding=@(NO);
        //0.487, 0.590
        //0.474, 0.578
        CGSize s = [[CCDirector sharedDirector] winSize];
        self.contentSize=CGSizeMake(s.width*0.474, s.height*0.578);
        self.anchorPoint=ccp(0.5, 0);
        [self setIgnoreAnchorPointForPosition:NO];
        self.orientation=kLeft;
        //486x444 on 1024x768
        
        tail=[CCSprite spriteWithFile:@"tail.png"];
        //382x115
        tail.position=ccp(self.contentSize.width*0.786 , self.contentSize.height-self.contentSize.height*0.259-tail.contentSize.height*0.4);
        tail.anchorPoint=ccp(0.5, 0.1);
        
        body=[CCSprite spriteWithFile:@"chest.png"];
        //255x257
        body.position=ccp(self.contentSize.width*0.525, self.contentSize.height-self.contentSize.height*0.579);
        
        head=[CCSprite spriteWithFile:@"headKot.png"];
        head.position=ccp(self.contentSize.width*0.212, self.contentSize.height-self.contentSize.height*0.378);
        
        headThx=[CCSprite spriteWithFile:@"headThx.png"];
        headThx.position=ccpAdd(head.position, ccp(-4, 30));
        headThx.visible=NO;
        
        eyelids=[CCSprite spriteWithFile:@"catEyesoff.png"];
        eyelids.position=ccpAdd(headThx.position, ccp(-20.0, -29.0));
        eyelids.visible=NO;
        
//        hand1=[CCSprite spriteWithFile:@"hand1.png"];
        hand1=[CCSprite spriteWithFile:@"handNew.png"];
        //131x342
        hand1.position=ccp(self.contentSize.width*0.39/*+hand1.contentSize.width*0.15*/, self.contentSize.height*0.41/*-hand1.contentSize.height*0.38*/);
        hand1.anchorPoint=ccp(0.72, 0.75);
        hand1.rotation=BASEROTH;
        
        hand2=[CCSprite spriteWithFile:@"handNew.png"];
        //157x320
        hand2.position=ccp(self.contentSize.width*0.31/*-hand2.contentSize.width*0.1*/, self.contentSize.height*0.43/*-hand2.contentSize.height*0.35*/);
        hand2.anchorPoint=ccp(0.72, 0.75);
        hand2.rotation=BASEROTH;
        
        leg1=[CCSprite spriteWithFile:@"legNew.png"];
        //349x346
        leg1.position=ccp(self.contentSize.width*0.706/*+leg1.contentSize.width/2*/+12, self.contentSize.height*0.396/*+leg1.contentSize.height*0.78*/+15);
//        leg1.anchorPoint=ccp(0.58, 0.65);
        leg1.anchorPoint=ccp(0.5, 0.78);
        leg1.rotation=BASEROTL;
        
        leg2=[CCSprite spriteWithFile:@"legNew.png"];
        //399x320
        //0.721
        leg2.position=ccp(self.contentSize.width*0.784-leg2.contentSize.width/2+17, self.contentSize.height*0.432/*+leg2.contentSize.height*0.78*/+17);
//        leg2.anchorPoint=ccp(0.3, 0.9);
        leg2.anchorPoint=ccp(0.5, 0.78);
        leg2.rotation=BASEROTL;
        
        tongue=[CCSprite spriteWithFile:@"tongue.png"];
        tongue.visible=NO;
        //add them in needed order
        [self addChild:hand2];
        [self addChild:leg2];
        [self addChild:tail];
        [self addChild:body];
        [self addChild:leg1];
        [self addChild:hand1];
        [self addChild:head];
        [self addChild:headThx];
        [self addChild:eyelids];
        [self addChild:tongue];
    }
    return self;
}

-(void)informDelegateOf:(SEL)selector{
    if ([_delegate respondsToSelector:selector])
        [_delegate performSelector:selector];
}

#pragma mark - Swiping implementation

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *all=[event allTouches];
    UITouch *touch=[[all allObjects] objectAtIndex:0];
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    firstTouch=loc;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *all=[event allTouches];
    UITouch *touch=[[all allObjects] objectAtIndex:0];
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    
    CGFloat swipeLength=ccpDistance(firstTouch, loc);
    if (swipeLength<SWIPE_LEN||![_delegate respondsToSelector:@selector(swipedToDirection:)])
        return;
    
    if (firstTouch.x>loc.x)
        [_delegate swipedToDirection:kSwipeRight];
    else if (firstTouch.x<loc.x)
        [_delegate swipedToDirection:kSwipeLeft];
    
    firstTouch=loc;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *all=[event allTouches];
    UITouch *touch=[[all allObjects] objectAtIndex:0];
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    lastTouch=loc;
    
    CGFloat swipeLength=ccpDistance(firstTouch, lastTouch);
    
    if (swipeLength<SWIPE_LEN||![_delegate respondsToSelector:@selector(swipedToDirection:)])
        return;
    
    if (firstTouch.x>lastTouch.x)
        [_delegate swipedToDirection:kSwipeRight];
    else if (firstTouch.x<lastTouch.x)
        [_delegate swipedToDirection:kSwipeLeft];
}

@end

inline int signum(int num){
    return (num>0) ? 1 : (num<0) ? -1 : 0;
}
