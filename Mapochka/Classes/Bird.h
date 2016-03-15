//
//  Bird.h
//  Mapochka
//
//  Created by Nikita Anisimov on 3/15/13.
//
//

#import "cocos2d.h"

@protocol BirdProtokol;

@interface Bird : CCLayer{
    
}

@property (nonatomic,readonly) CCSprite *head;
@property (nonatomic,readonly) CCSprite *body;
@property (nonatomic,readonly) CCSprite *wingRight;
@property (nonatomic,readonly) CCSprite *wingLeft;
@property (nonatomic,readonly) CCSprite *mouth;
@property (nonatomic,readonly) CCSprite *tail;
@property (nonatomic,readonly) CCSprite *lLeg;
@property (nonatomic,readonly) CCSprite *rLeg;

@property (nonatomic,assign) id<BirdProtokol> delegate;

-(void)jump;
-(void)jumpAndMoveTo:(CGPoint)loc;
-(void)wingsAnimate;
-(void)blinkEyes;
-(void)stopBlinking;
-(void)chickChirick;
-(void)swipeTail;
-(void)headSwipe;
-(void)lookLeft;
-(void)lookStraight;
-(void)rightLegUp;
-(void)leftLegUp;

@end

@protocol BirdProtokol <NSObject>

@optional
-(void)birdStartJump;
-(void)birdEndJump;
-(void)birdStartChirick;
-(void)birdEndChirick;
-(void)birdStartWingFly;
-(void)birdEndWingFly;
-(void)birdStartTail;
-(void)birdEndTail;
-(void)birdFlyingAndMoving;
-(void)birdFlewAndMoved;
@end