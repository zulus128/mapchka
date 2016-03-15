//
//  KotenokLayer.h
//  Mapochka
//
//  Created by Nikita Anisimov on 2/6/13.
//
//

#import "cocos2d.h"
#import "Kot.h"
#import <AVFoundation/AVFoundation.h>

@interface KotenokLayer : CCLayer<KotoProtocol, AVAudioPlayerDelegate>{
    //audiotrack
    AVAudioPlayer *track;
    //sprites
//    CCSprite *backBtn;
//    CCSprite *nextBtn;
    CCSprite *milky;
    //catmom
    CCSprite *veki;
    CCSprite *eyesup;
    CCSprite *eyesdown;
    CCSprite *eyesoff;
    //kot
    Kot *catty;
    //other vars
    CGRect bowleyRect;
    BOOL enableMoreMilk;
    BOOL finita;
    BOOL bendedHim;
    BOOL nearBowley;
    BOOL cameToPause;
    BOOL asksMore;
}

+(CCScene*)scene;

@end
