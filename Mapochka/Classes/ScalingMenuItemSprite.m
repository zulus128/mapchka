//
//  ScalingMenuItemSprite.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/20/13.
//
//

#import "ScalingMenuItemSprite.h"

@implementation ScalingMenuItemSprite

-(void)selected{
    [super selected];
    id scaleUp=[CCScaleTo actionWithDuration:0.2 scale:1.05];
    [self runAction:scaleUp];
}

-(void)unselected{
    [super unselected];
    id scaleDown=[CCScaleTo actionWithDuration:0.2 scale:1.0];
    [self runAction:scaleDown];
}

@end
