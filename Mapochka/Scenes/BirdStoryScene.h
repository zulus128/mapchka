//
//  BirdStoryScene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 4/18/13.
//
//

#import "cocos2d.h"
#import "Bird.h"
#import "Sun.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface BirdStoryScene : CCLayer <BirdProtokol,AVAudioPlayerDelegate>

+(CCScene*)scene;

@end
