//
//  Sun.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/20/13.
//
//

#import "Sun.h"

@interface Sun (){
    CCSprite *body;
    CCSprite *eyesOpen;
    CCSprite *eyesClose;
    CCSprite *smileOpen;
    CCSprite *smileClose;
    CCSprite *mouth;
    //lights
    CCSprite *lightW;
    CCSprite *lightY1;
    CCSprite *lightY2;
    //
    BOOL sunLightsSpin;
}

@end

@implementation Sun

@synthesize body=body;

-(void)animateSunlights{
    if (sunLightsSpin) return;
    sunLightsSpin=YES;
    id spin=[CCRotateBy actionWithDuration:1.0 angle:360.0];
    [lightW runAction:spin];
    [lightY1 runAction:[spin copy]];
    [lightY2 runAction:[spin copy]];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sunLightsSpin=NO;
    });
}

-(void)blink{
    eyesClose.visible=YES;
    eyesOpen.visible=NO;
    [self scheduleOnce:@selector(unblink) delay:0.25];
}

-(void)unblink{
    eyesClose.visible=NO;
    eyesOpen.visible=YES;
    [self scheduleOnce:@selector(blink) delay:1.5];
}

-(void)smile{
    mouth.visible=NO;
    smileOpen.visible=YES;
}

-(void)shutMouth{
    mouth.visible=YES;
    smileOpen.visible=NO;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=NO;
        sunLightsSpin=NO;
        
        self.anchorPoint=ccp(0.5, 0.5);
        self.ignoreAnchorPointForPosition=NO;
        
        lightY2=[CCSprite spriteWithFile:@"sunLightYellow2.png"];
        lightY2.position=ccp(lightY2.contentSize.width/2, lightY2.contentSize.height/2);
        lightY1=[CCSprite spriteWithFile:@"sunLightYellow.png"];
        lightY1.position=lightY2.position;
        lightW=[CCSprite spriteWithFile:@"sunLightWhite.png"];
        lightW.position=lightY2.position;
        [self addChild:lightY2];
        [self addChild:lightY1];
        [self addChild:lightW];
        
        body=[CCSprite spriteWithFile:@"sunBody.png"];
        body.position=ccpAdd(lightY2.position, ccp(0, 0));
        [self addChild:body];
        
        eyesOpen=[CCSprite spriteWithFile:@"sunEyesOpen.png"];
        eyesOpen.position=ccpAdd(body.position, ccp(-6, 18));
        eyesClose=[CCSprite spriteWithFile:@"sunEyesClose.png"];
        eyesClose.position=ccpAdd(eyesOpen.position, ccp(0, -4));
        eyesClose.visible=NO;
        [self addChild:eyesOpen];
        [self addChild:eyesClose];
        
        mouth=[CCSprite spriteWithFile:@"sunMouth.png"];
        mouth.position=ccpAdd(body.position, ccp(20, -25));
        smileOpen=[CCSprite spriteWithFile:@"sunMouthSmileOpen.png"];
        smileOpen.position=ccpAdd(body.position, ccp(15, -34));
        smileOpen.visible=NO;
        smileClose=[CCSprite spriteWithFile:@"sunMouthSmileClose.png"];
        smileClose.position=mouth.position;
        smileClose.visible=NO;
        [self addChild:mouth];
        [self addChild:smileOpen];
        [self addChild:smileClose];
    }
    return self;
}

@end
