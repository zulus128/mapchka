//
//  WalkingCat.h
//  Mapochka
//
//  Created by Nikita Anisimov on 2/20/13.
//
//

#import "cocos2d.h"
#import "Kot.h"

@interface WalkingCat : CCLayer<KotoProtocol>{
    Kot *catty;
    CCSprite *backBtn;
}


@property (nonatomic) NSTimeInterval time;


+(CCScene*)scene;

@end
