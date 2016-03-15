//
//  AnketaLayer.m
//  Mapochka
//
//  Created by Nikita Anisimov on 1/30/13.
//
//

#import "AnketaLayer.h"
#import "KotenokLayer.h"

@implementation AnketaLayer

+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    AnketaLayer *layer=[AnketaLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self = [super init];
    if (self){
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [CCMenuItemFont setFontSize:24];
        //items go here
        CCLabelTTF *nameLbl=[CCLabelTTF labelWithString:@"Имя ребенка" fontName:@"Arial" fontSize:22];
        CCMenuItem *nameItem=[CCMenuItemLabel itemWithLabel:nameLbl];
        CCLabelTTF *birthLbl=[CCLabelTTF labelWithString:@"Дата рождения" fontName:@"Arial" fontSize:22];
        CCMenuItem *birthItem=[CCMenuItemLabel itemWithLabel:birthLbl]; 
        
        CCMenu *menu=[CCMenu menuWithItems:nameItem, birthItem, nil];
        [menu alignItemsVerticallyWithPadding:30.0f];
        [menu setPosition:ccp(size.width/2, size.height/2)];
        
        [self addChild:menu];
    }
    return self;
}

-(void)onEnter{
    [super onEnter];
    [self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void)onExit{
    [super onExit];
}

-(void) makeTransition:(ccTime)dt{
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[KotenokLayer scene]]];
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0f scene:[KotenokLayer scene]]];
}

@end
