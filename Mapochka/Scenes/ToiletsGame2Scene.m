//
//  ToiletsGame2Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/10/13.
//
//

#import "ToiletsGame2Scene.h"
#import "SimpleAudioEngine.h"
#define GIRLDRESSRECT1 CGRectMake(704,195,250,161)
#define GIRLDRESSRECT2 CGRectMake(783,356,103,95)
#define BOYBODYRECT1 CGRectMake(251/2,105,257/2,279)
#define BOYBODYRECT2 CGRectMake(298/2,384,81,54)

static int gameId = LOG_GAME_TOILET_2;

@interface ToiletsGame2Scene (){
    CCSprite *clrGreen,*clrBlue,*clrDBlue,*clrRed,*clrPink,*clrPurple,*clrYellow;
    CCSprite *girlPants,*boyPants,*girlShirt,*boyShirt,*boyBoots,*girlBoots,*girlDress;
    CCSprite *boyToilet,*girlToilet;
    kChosenColor colour;
    BOOL allowToPlay;
    int lastPlayedEffect;
}
@property (nonatomic, copy) NSString *selectedColor;
-(void)createGame;
-(void)performEntry;
@end

@implementation ToiletsGame2Scene

-(void)performEntry{
    id show=[CCFadeOut actionWithDuration:1];
    [girlPants runAction:show];
    [boyPants runAction:[show copy]];
    [girlShirt runAction:[show copy]];
    [boyShirt runAction:[show copy]];
    [girlDress runAction:[show copy]];
    [boyBoots runAction:[show copy]];
    [girlBoots runAction:[show copy]];
    [boyToilet runAction:[show copy]];
    [girlToilet runAction:[show copy]];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allowToPlay=YES;
    });
}

-(void)createGame{
    CCSprite *contBoy=[CCSprite spriteWithFile:@"tGame2ContourBoy.png"];
    contBoy.position=ccp(187, 277);
    [self addChild:contBoy z:1];
    CCSprite *contGirl=[CCSprite spriteWithFile:@"tGame2ContourGirl.png"];
    contGirl.position=ccp(836, 277);
    [self addChild:contGirl z:1];
    CCSprite *contTB=[CCSprite spriteWithFile:@"tGame2ToiletBoy.png"];
    contTB.position=ccp(397, 155);
    [self addChild:contTB z:1];
    CCSprite *contTG=[CCSprite spriteWithFile:@"tGame2ToiletGirl.png"];
    contTG.position=ccp(626, 127);
    [self addChild:contTG z:1];
    CCSprite *brush=[CCSprite spriteWithFile:@"tGame2Brush.png"];
    brush.position=ccp(512, 567);
    [self addChild:brush];
    ////////
    clrBlue=[CCSprite spriteWithFile:@"tGame2ColourBlue.png"];
    clrBlue.position=ccp(408, 768-201);
    clrRed=[CCSprite spriteWithFile:@"tGame2ColourRed.png"];
    clrRed.position=ccp(617, 768-242);
    clrPink=[CCSprite spriteWithFile:@"tGame2ColourPink.png"];
    clrPink.position=ccp(628, 768-110);
    clrPurple=[CCSprite spriteWithFile:@"tGame2ColourPurple.png"];
    clrPurple.position=ccp(421, 768-280);
    clrDBlue=[CCSprite spriteWithFile:@"tGame2ColourDBlue.png"];
    clrDBlue.position=ccp(542, 768-321);
    clrGreen=[CCSprite spriteWithFile:@"tGame2ColourGreen.png"];
    clrGreen.position=ccp(457, 768-107);
    clrYellow=[CCSprite spriteWithFile:@"tGame2ColourYellow.png"];
    clrYellow.position=ccp(579, 768-186);
    [self addChild:clrBlue];
    [self addChild:clrRed];
    [self addChild:clrPink];
    [self addChild:clrPurple];
    [self addChild:clrDBlue];
    [self addChild:clrGreen];
    [self addChild:clrYellow];
    ////////
    girlPants=[CCSprite spriteWithFile:@"tGame2PantsGirl_Green.png"];
    girlPants.position=ccp(835, 145+6);
//    girlPants.visible=NO;
    boyPants=[CCSprite spriteWithFile:@"tGame2BodyBoy_Green.png"];
    boyPants.position=ccp(182, 296);
//    boyPants.visible=NO;
    girlShirt=[CCSprite spriteWithFile:@"tGame2ShirtGirl_Green.png"];
    girlShirt.position=ccp(835-1, 429+2);
//    girlShirt.visible=NO;
    boyShirt=[CCSprite spriteWithFile:@"tGame2ShirtBoy_Green.png"];
    boyShirt.position=ccp(187, 423);
//    boyShirt.visible=NO;
    girlDress=[CCSprite spriteWithFile:@"tGame2DressGirl_Green.png"];
    girlDress.position=ccp(836, 339+2);
//    girlDress.visible=NO;
    boyBoots=[CCSprite spriteWithFile:@"tGame2ShoesBoy_Green.png"];
    boyBoots.position=ccp(195, 82);
//    boyBoots.visible=NO;
    girlBoots=[CCSprite spriteWithFile:@"tGame2ShoesGirl_Green.png"];
    girlBoots.position=ccp(835, 89+3);
//    girlBoots.visible=NO;
    boyToilet=[CCSprite spriteWithFile:@"tGame2ToiletBoyOk_Green.png"];
    boyToilet.position=ccp(397, 156-1);
//    boyToilet.visible=NO;
    girlToilet=[CCSprite spriteWithFile:@"tGame2ToiletGirlOk_Green.png"];
    girlToilet.position=ccp(626, 129-2);
//    girlToilet.visible=NO;
    [self addChild:girlPants];
    [self addChild:boyPants];
    [self addChild:girlShirt];
    [self addChild:boyShirt];
    [self addChild:girlDress];
    [self addChild:boyBoots];
    [self addChild:girlBoots];
    [self addChild:boyToilet];
    [self addChild:girlToilet];
    id show=[CCFadeOut actionWithDuration:0.00];
    [girlPants runAction:show];
    [boyPants runAction:[show copy]];
    [girlShirt runAction:[show copy]];
    [boyShirt runAction:[show copy]];
    [girlDress runAction:[show copy]];
    [boyBoots runAction:[show copy]];
    [girlBoots runAction:[show copy]];
    [boyToilet runAction:[show copy]];
    [girlToilet runAction:[show copy]];
    allowToPlay=YES;

}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletsGame2Scene *layer=[ToiletsGame2Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        allowToPlay=NO;
        //
        CCSprite *bg=[CCSprite spriteWithFile:@"tGame2Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:2];
        
        [self createGame];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    
    [super dealloc];
}

-(void)onEnter{
//    [self scheduleOnce:@selector(performEntry) delay:1.5];
    [super onEnter];
    
    [Flurry logEvent:@"ToiletGame2" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_TOILET_2, YES);
}


-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"3.1 Raskras.wav"];
    [self schedule:@selector(playRandomSound) interval:30];
}
-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"ToiletGame2" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_TOILET_2);
    [self unscheduleAllSelectors];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return allowToPlay;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    //colours
    
    self.selectedColor = CGRectContainsPoint(clrRed.boundingBox, loc)?@"Red":
    CGRectContainsPoint(clrBlue.boundingBox, loc)?@"Lightblue":
    CGRectContainsPoint(clrGreen.boundingBox, loc)?@"Green":
    CGRectContainsPoint(clrYellow.boundingBox, loc)?@"Yellow":
    CGRectContainsPoint(clrDBlue.boundingBox, loc)?@"Blue":
    CGRectContainsPoint(clrPink.boundingBox, loc)?@"Pink":
    CGRectContainsPoint(clrPurple.boundingBox, loc)?@"Purple" : self.selectedColor;
    
    
    if (!self.selectedColor)
        self.selectedColor = @"Red";
    //
    id show=[CCFadeIn actionWithDuration:0.4];
    if (CGRectContainsPoint(GIRLDRESSRECT1, loc)){
        [girlDress setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2DressGirl_%@.png", self.selectedColor]]];
        [girlDress runAction:[show copy]];
    }else if (CGRectContainsPoint(GIRLDRESSRECT2, loc)){
        [girlDress setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2DressGirl_%@.png", self.selectedColor]]];
        [girlDress runAction:[show copy]];
    }else if ((CGRectContainsPoint(girlShirt.boundingBox, loc))&&!(CGRectContainsPoint(GIRLDRESSRECT2, loc)||CGRectContainsPoint(GIRLDRESSRECT1, loc))){
        [girlShirt setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ShirtGirl_%@.png", self.selectedColor]]];
        [girlShirt runAction:[show copy]];
    }else if (CGRectContainsPoint(girlBoots.boundingBox, loc)){
        [girlBoots setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ShoesGirl_%@.png", self.selectedColor]]];
        [girlBoots runAction:[show copy]];
    }
    else if (CGRectContainsPoint(girlPants.boundingBox, loc)){
        [girlPants setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2PantsGirl_%@.png", self.selectedColor]]];
        [girlPants runAction:[show copy]];
    }
    else if (CGRectContainsPoint(boyToilet.boundingBox, loc)){
        [boyToilet setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ToiletBoyOk_%@.png", self.selectedColor]]];
        [boyToilet runAction:[show copy]];
    }
    else if (CGRectContainsPoint(girlToilet.boundingBox, loc)){
        [girlToilet setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ToiletGirlOk_%@.png", self.selectedColor]]];
        [girlToilet runAction:[show copy]];
    }
    else if (CGRectContainsPoint(boyBoots.boundingBox, loc)){
        [boyBoots setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ShoesBoy_%@.png", self.selectedColor]]];
        [boyBoots runAction:[show copy]];
    }
    else if (CGRectContainsPoint(BOYBODYRECT1, loc)){
        [boyPants setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2BodyBoy_%@.png", self.selectedColor]]];
        [boyPants runAction:[show copy]];
    }
    else if (CGRectContainsPoint(BOYBODYRECT2, loc)){
        [boyPants setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2BodyBoy_%@.png", self.selectedColor]]];
        [boyPants runAction:[show copy]];
    }
    else if (CGRectContainsPoint(boyShirt.boundingBox, loc)&&!(CGRectContainsPoint(BOYBODYRECT1, loc)||CGRectContainsPoint(BOYBODYRECT2, loc))){
        [boyShirt setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tGame2ShirtBoy_%@.png", self.selectedColor]]];
        [boyShirt runAction:[show copy]];
    }
}

-(void)playRandomSound{
    int change = rand()%3;
    while (change == lastPlayedEffect) {
        change = rand()%3;
    }
    lastPlayedEffect = change;
    switch (change) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"3.2 KakKrasivo.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"3.3 Otlychnyi.wav"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"3.4 UTebya.wav"];
            break;
        default:
            break;
    }
}

@end
