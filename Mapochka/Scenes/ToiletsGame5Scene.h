//
//  ToiletsGame5Scene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 4/23/13.
//
//

#import "cocos2d.h"

typedef enum{
    kColourNone=-1,
    kColourYellow=0,
    kColourGreen,
    kColourRed,
    kColourCyan,
    kColourBlue,
    kColourViolet,
    kColourPink,
}kChosenColour;

@interface ToiletsGame5Scene : CCLayer{
    
}

@property (nonatomic) NSTimeInterval time;

+(CCScene *)scene;

@end
