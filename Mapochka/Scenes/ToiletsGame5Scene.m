//
//  ToiletsGame5Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/23/13.
//
//

#import "ToiletsGame5Scene.h"
#import "SimpleAudioEngine.h"

#define RECT1 CGRectMake(232.0,768-570,244-232,570-509)
#define RECT2 CGRectMake(348.0,768-460,418-348,460-445)
#define RECT3 CGRectMake(524.0,768-620,586-524,620-548)
#define RECT4 CGRectMake(452.0,384,512-452,384-242)
#define RECT5 CGRectMake(400.0,384,452-400,384-300)
#define RECT6 CGRectMake(368.0,405-368,768-560,560-535)

#define ROW1Y (768.0-70.0)
#define ROWDELTAY 98.0
#define COL1X 715.0
#define COLDELTAX 113.0

static int gameId = LOG_GAME_TOILET_5;

@interface ToiletsGame5Scene (){
    //colours
    //in array they go like : [*colYellow, *colGreen, *colRed, *colCyan, *colBlue, *colViolet, *colPink];
    NSArray *colours;
    kChosenColour chosenColour;
    //toilets
    CCSprite *toilContour;
    //in array they go like : [*toilWhite, *toilYellow, *toilGreen, *toilRed, *toilCyan, *toilBlue, *toilViolet, *toilPink];
    NSArray *toilets;
    NSUInteger shownToilet;
    BOOL canPaint;
    //Others
    NSArray *stickRects;
    NSArray *stickers;
    NSInteger movingSticker;
    NSInteger playEffectsIndex;
    NSInteger lastPlayedEffect;
}

@end

@implementation ToiletsGame5Scene

-(void)createGame{
    canPaint=YES;
    CCSprite *colYellow=[CCSprite spriteWithFile:@"tGame2ColourYellow.png"];
    CCSprite *colGreen=[CCSprite spriteWithFile:@"tGame2ColourGreen.png"];
    CCSprite *colRed=[CCSprite spriteWithFile:@"tGame2ColourRed.png"];
    CCSprite *colCyan=[CCSprite spriteWithFile:@"tGame2ColourBlue.png"];
    CCSprite *colBlue=[CCSprite spriteWithFile:@"tGame2ColourDBlue.png"];
    CCSprite *colViolet=[CCSprite spriteWithFile:@"tGame2ColourPurple.png"];
    CCSprite *colPink=[CCSprite spriteWithFile:@"tGame2ColourPink.png"];
//    colours=@[colYellow,colGreen,colRed,colCyan,colBlue,colViolet,colPink];
    colours=[[NSArray alloc] initWithObjects:colYellow, colGreen, colRed, colCyan,colBlue,colViolet,colPink, nil];
    chosenColour=kColourNone;
    int dist=109;
    for (int i=0;i<7;i++){
        int curDist=i*dist + 13 + 41;
        [(CCSprite*)[colours objectAtIndex:i] setPosition:ccp(48+25, curDist)];
        [self addChild:[colours objectAtIndex:i]];
    }
    //stickers
    stickers=[[NSArray alloc] initWithObjects:
              [CCSprite spriteWithFile:@"tGame5Flower2.png"], [CCSprite spriteWithFile:@"tGame5Dolphin.png"], [CCSprite spriteWithFile:@"tGame5Heart3.png"],
              [CCSprite spriteWithFile:@"tGame5Circle1.png"], [CCSprite spriteWithFile:@"tGame5Moto.png"], [CCSprite spriteWithFile:@"tGame5Car.png"],
              [CCSprite spriteWithFile:@"tGame5Romb2.png"], [CCSprite spriteWithFile:@"tGame5Bear.png"], [CCSprite spriteWithFile:@"tGame5StarPink.png"],
              [CCSprite spriteWithFile:@"tGame5Rabbit.png"], [CCSprite spriteWithFile:@"tGame5StarGreen.png"], [CCSprite spriteWithFile:@"tGame5Doll.png"],
              [CCSprite spriteWithFile:@"tGame5StarCyan.png"], [CCSprite spriteWithFile:@"tGame5Duck.png"], [CCSprite spriteWithFile:@"tGame5Heart1.png"],
              [CCSprite spriteWithFile:@"tGame5Circle2.png"], [CCSprite spriteWithFile:@"tGame5Heart2.png"], [CCSprite spriteWithFile:@"tGame5Dinger.png"],
              [CCSprite spriteWithFile:@"tGame5Subma.png"], [CCSprite spriteWithFile:@"tGame5Romb.png"], [CCSprite spriteWithFile:@"tGame5Flower1.png"],
              nil];
    for (int i=0;i<stickers.count;i++){
        CCSprite *sticker=[stickers objectAtIndex:i];
        int row=i/3;
        int col=i%3;
        sticker.position=ccp(COL1X+col*COLDELTAX, ROW1Y-row*ROWDELTAY);
        [self addChild:sticker z:2];
    }
    stickRects=[[NSArray alloc] initWithObjects:
                [NSValue valueWithCGRect:CGRectMake(232.0,768-570,244-232,570-509)],
                [NSValue valueWithCGRect:CGRectMake(348.0,768-460,418-348,460-445)],
                [NSValue valueWithCGRect:CGRectMake(524.0,768-620,586-524,620-548)],
                [NSValue valueWithCGRect:CGRectMake(452.0,384,512-452,384-242)],
                [NSValue valueWithCGRect:CGRectMake(400.0,384,452-400,384-300)],
                [NSValue valueWithCGRect:CGRectMake(368.0,405-368,768-560,560-535)],
                nil];
    //toilets
    CCSprite *toilWhite=[CCSprite spriteWithFile:@"tGame5ToilWhite.png"];
    CCSprite *toilYellow=[CCSprite spriteWithFile:@"tGame5ToilYellow.png"];
    CCSprite *toilGreen=[CCSprite spriteWithFile:@"tGame5ToilGreen.png"];
    CCSprite *toilCyan=[CCSprite spriteWithFile:@"tGame5ToilCyan.png"];
    CCSprite *toilBlue=[CCSprite spriteWithFile:@"tGame5ToilBlue.png"];
    CCSprite *toilRed=[CCSprite spriteWithFile:@"tGame5ToilRed.png"];
    CCSprite *toilPink=[CCSprite spriteWithFile:@"tGame5ToilPink.png"];
    CCSprite *toilViolet=[CCSprite spriteWithFile:@"tGame5ToilViolet.png"];
    toilWhite.position=toilYellow.position=toilRed.position=toilBlue.position=toilCyan.position=toilGreen.position=toilPink.position=toilViolet.position=ccp(440, 330);
    toilYellow.opacity=toilRed.opacity=toilBlue.opacity=toilCyan.opacity=toilGreen.opacity=toilPink.opacity=toilViolet.opacity=1;
    shownToilet=0;
    toilets=[[NSArray alloc] initWithObjects:toilWhite, toilYellow, toilGreen, toilRed, toilCyan, toilBlue, toilViolet, toilPink, nil];
//    for (CCSprite *each in toilets) [self addChild:each];
    [self addChild:toilWhite];
    toilContour=[CCSprite spriteWithFile:@"tGame5ToilCont.png"];
    toilContour.position=ccp(440, 768-438);
    [self addChild:toilContour z:1];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletsGame5Scene *layer=[ToiletsGame5Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"tGame5Bg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(210, s.height-70)];
        [self addChild:menu z:1];
        
        [self createGame];
    }
    return self;
}

-(void)dealloc{
    [colours release];
    [toilets release];
    [stickers release];
    [stickRects release];
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"1.1 Ukras.wav"];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"ToiletGame5" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_TOILET_5, YES);
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"ToiletGame5" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_TOILET_5);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(void)hideShownToilet{
    CCFadeOut *fader=[CCFadeOut actionWithDuration:0.6];
    [[toilets objectAtIndex:shownToilet] runAction:fader];
}

-(NSUInteger)checkColourTouch:(CGPoint)loc{
    for (NSInteger i=0;i<[colours count];i++){
        CCSprite *colour=[colours objectAtIndex:i];
        if (CGRectContainsPoint(colour.boundingBox, loc))
            return i;
    }
    return -1;
}

-(void)deScaleColour{
    if (chosenColour==kColourNone)
        return;
    CCScaleTo *deScaler=[CCScaleTo actionWithDuration:0.3 scale:1.0];
    [[colours objectAtIndex:chosenColour] runAction:deScaler];
}

-(void)scaleColour{
    CCScaleTo *scaler=[CCScaleTo actionWithDuration:0.3 scale:1.2];
    [[colours objectAtIndex:chosenColour] runAction:scaler];
}

-(NSInteger)checkStickerTouch:(CGPoint)loc{
    for (NSInteger i=[stickers count]-1;i>=0;i--){
        CCSprite *sticker=[stickers objectAtIndex:i];
        if (CGRectContainsPoint(sticker.boundingBox, loc))
            return i;
    }
    return -1;
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    NSInteger sticker=-1;
    if ((sticker=[self checkStickerTouch:loc])>=0) movingSticker=sticker;
    return canPaint;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (movingSticker>=0){
        CGPoint loc=[self convertTouchToNodeSpace:touch];
        CCSprite *sticker=[stickers objectAtIndex:movingSticker];
        sticker.position=loc;
    }
}

-(void)playRandomEffect{
    int change = rand()%3;
    while (change == lastPlayedEffect) {
        change = rand()%3;
    }
    lastPlayedEffect = change;
    switch (change) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.2 KakKrasivo.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.3 Otlychnyi.wav"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.4 UTebya.wav"];
            break;
        default:
            break;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    kChosenColour touchedColour=-1;
    if (CGRectContainsPoint(toilContour.boundingBox, loc) && movingSticker==-1){
        canPaint=NO;
        if (chosenColour==kColourNone || chosenColour+1==shownToilet){
            canPaint=YES;
            return;
        }
        CCFadeIn *fader=[CCFadeIn actionWithDuration:0.8];
        [self addChild:[toilets objectAtIndex:chosenColour+1]];
        [[toilets objectAtIndex:chosenColour+1] runAction:fader];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CCSprite *toilet=[toilets objectAtIndex:shownToilet];
            [toilet setOpacity:1];
            [toilet removeFromParentAndCleanup:YES];
            shownToilet=chosenColour+1;
            canPaint=YES;
            
            if (playEffectsIndex==0)
                [self playRandomEffect];
            playEffectsIndex = playEffectsIndex == 3 ? 0 : playEffectsIndex + 1;
        });
    }else if ((touchedColour=[self checkColourTouch:loc])!=kColourNone){
        [self deScaleColour];
        chosenColour=touchedColour;
        [self scaleColour];
    }
    //check sticker movement
    if (movingSticker>=0){
        CCSprite *sticker=[stickers objectAtIndex:movingSticker];
        for (NSValue *value in stickRects){
            CGRect rect=[value CGRectValue];
            CGRect intersection=CGRectIntersection(rect, sticker.boundingBox);
            if (intersection.size.width>=15 || intersection.size.height>=15){
                movingSticker=-1;
                
                if (playEffectsIndex==0)
                    [self playRandomEffect];
                playEffectsIndex = playEffectsIndex == 3 ? 0 : playEffectsIndex + 1;
                
                return;
            }
        }
        int row=movingSticker/3;
        int col=movingSticker%3;
        id moveBack=[CCMoveTo actionWithDuration:0.5 position:ccp(COL1X+col*COLDELTAX, ROW1Y-row*ROWDELTAY)];
        [sticker runAction:moveBack];
    }
    movingSticker=-1;
}

@end
