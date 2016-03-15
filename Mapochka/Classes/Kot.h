//
//  Kot.h
//  Mapochka
//
//  Created by Nikita Anisimov on 2/7/13.
//
//

#import "cocos2d.h"

typedef enum{
    kHand1=0,
    kHand2,
    kLeg1,
    kLeg2
}kBodyPart;

typedef enum{
    kRight=0,
    kLeft
}kRotation;

typedef enum{
    kSwipeRight=0,
    kSwipeLeft
}kSwipeDirection;

@protocol KotoProtocol;

@interface Kot : CCLayer{
   // NSNumber *noding;
}

@property (nonatomic, readonly) CCSprite *head;
@property (nonatomic, readonly) CCSprite *tail;
@property (nonatomic, readonly) CCSprite *frontLeg;
@property (nonatomic, readonly) CCSprite *rearLeg;
@property (nonatomic, readonly) kRotation orientation;
@property (nonatomic, assign) BOOL justWalker;
@property (nonatomic, assign) id<KotoProtocol> delegate;
@property (nonatomic, strong) NSNumber * noding;

-(void)rotateCatTo:(kRotation)rotato;
-(void)walkTo:(CGPoint)pos;
-(void)bend;
-(void)unbend;
-(void)lollipopIt;
-(void)stopLolli;
-(void)stopTheWalk;
-(void)sayThx;
-(void)eatMore;
-(void)tailDance;
-(void)nod;
-(void)rightFootUp;
-(void)leftFootUp;

@end

@protocol KotoProtocol <NSObject>
@optional
-(void)kotPrishel;
-(void)kotPoshel;
-(void)kotBending;
-(void)kotUnBending;
-(void)kotStepnul;
-(void)swipedToDirection:(kSwipeDirection)dir;
@end

inline int signum(int num);
