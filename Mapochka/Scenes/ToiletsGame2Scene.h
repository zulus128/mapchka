//
//  ToiletsGame2Scene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 4/10/13.
//
//

#import "cocos2d.h"

typedef enum{
    kColorBlue=0,
    kColorRed,
    kColorGreen,
    kColorPink,
    kColorPurple,
    kColorYellow,
    kColorDBlue,
}kChosenColor;

@interface ToiletsGame2Scene : CCLayer{
    
}

@property (nonatomic) NSTimeInterval time;

+(CCScene*)scene;

@end
