//
//  GameMenu.h
//  Mapochka
//
//  Created by Nikita Anisimov on 2/20/13.
//
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

typedef enum {
    kMenuWalkingCat=0,
    kMenuSparrow,
    kMenuToilets,
}kMenuTheme;

@interface GameMenu : CCLayer{
    
}

+(CCScene*)sceneWithTheme:(kMenuTheme)theme;

@end
