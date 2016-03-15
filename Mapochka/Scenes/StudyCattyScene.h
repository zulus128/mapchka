//
//  StudyCattyScene.h
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "cocos2d.h"
#import "Kot.h"

@interface StudyCattyScene : CCLayer<KotoProtocol>{
    
}

@property (nonatomic) NSTimeInterval time;

+(CCScene*)scene;

@end
