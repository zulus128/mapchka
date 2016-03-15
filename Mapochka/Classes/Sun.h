//
//  Sun.h
//  Mapochka
//
//  Created by Nikita Anisimov on 3/20/13.
//
//

#import "cocos2d.h"

@interface Sun : CCLayer{
    
}

@property (nonatomic,readonly) CCSprite *body;

-(void)blink;
-(void)smile;
-(void)shutMouth;
-(void)animateSunlights;

@end
