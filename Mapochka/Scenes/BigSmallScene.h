//
//  BigSmallScene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "cocos2d.h"
#import "Kot.h"

@interface BigSmallScene : CCLayer{
    //catmom
    CCSprite *herHead;
    CCSprite *veki;
    CCSprite *eyesup;
    CCSprite *eyesdown;
    CCSprite *eyesoff;
    //him
//    CCSprite *hisVeki;
    Kot *catty;
}

@property (nonatomic) NSTimeInterval time;

+(CCScene*)scene;

@end
