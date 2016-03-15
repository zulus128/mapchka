//
//  BirdGame1Scene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 3/18/13.
//
//

#import "cocos2d.h"
#import "Bird.h"

@interface BirdGame1Scene : CCLayer<BirdProtokol>{
    
}

@property (nonatomic) NSTimeInterval time;

+(CCScene *)scene;

@end
