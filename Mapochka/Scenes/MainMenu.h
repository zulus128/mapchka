//
//  MainMenu.h
//  Mapochka
//
//  Created by Nikita Anisimov on 4/14/13.
//
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

typedef enum{
    kBodyNormal=0,
    kBodyHand,
    kBodyDrink,
    kBodyPreSleep,
    kBodySleep,
}kBodyPlace;

typedef enum{
    kHeadLaugh=0,
    kHeadSmile,
    kHeadNoLeft,
    kHeadNoRight,
    kHeadDrink,
    kHeadSleep,
}kHeadState;

@interface MainMenu : CCLayer{
    
}

+(CCScene *)scene;

@end
