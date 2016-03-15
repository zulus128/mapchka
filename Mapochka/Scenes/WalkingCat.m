//
//  WalkingCat.m
//  Mapochka
//
//  Created by Nikita Anisimov on 2/20/13.
//
//

#import "WalkingCat.h"
#import "SimpleAudioEngine.h"
#define CAT_SCALE 0.75
#define FPRINT_SCALE 0.60


static int gameId = LOG_GAME_CAT_4;


@interface WalkingCat (){
    NSMutableArray *footPrints;
    BOOL catWalking;
    BOOL okToFootprint;
}

-(void)spawnFootprintAtPosition:(CGPoint)pos;

@end

@implementation WalkingCat

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    WalkingCat *layer=[WalkingCat node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        catWalking=NO;
        okToFootprint=YES;
        footPrints=[[NSMutableArray alloc] init];
        //add bg
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg];
        
        backBtn=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        [backBtn setPosition:ccp(s.width*0.08, s.height*0.9)];
        [self addChild:backBtn];
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"WalkingCat game deallocing.");
    [footPrints removeAllObjects];
    [footPrints release];
    [super dealloc];
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)onEnter{
    CGSize s=[CCDirector sharedDirector].winSize;
    catty=[Kot node];
    [catty setScale:CAT_SCALE];
    [catty setPosition:ccp(s.width, s.height*0.1)];
    [catty setDelegate:self];
    [catty setJustWalker:YES];
    [self addChild:catty z:1];
    [catty walkTo:ccp(s.width/2, s.height*0.1)];
    //
    [super onEnter];
    [Flurry logEvent:@"CatGame4" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_4, YES);
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"4.1 Uberi.wav"];
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    //
    [super onExit];
    [Flurry endTimedEvent:@"CatGame4" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_4);
}

-(void)spawnFootprintAtPosition:(CGPoint)pos{
    if (pos.x<0||pos.x>1024)
        return;
    CCSprite *fPrint=[CCSprite spriteWithFile:@"footprint.png"];
    fPrint.position=pos;
    fPrint.scale=FPRINT_SCALE;
    switch (catty.orientation) {
        case kRight:
            if (fPrint.scaleX>0)
                fPrint.scaleX*=-1;
            break;
            if (fPrint.scaleX<0)
                fPrint.scaleX*=-1;
        default:
            break;
    }
    [self addChild:fPrint z:0];
    [footPrints addObject:fPrint];
    if (footPrints.count>=20)
        okToFootprint=NO;
}

#pragma mark - Touches

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(backBtn.boundingBox, loc))
//        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
        [[CCDirector sharedDirector] popScene];

    else{
        BOOL printFound=NO;
        for (CCSprite *fPrint in footPrints){
            if (CGRectContainsPoint(fPrint.boundingBox, loc)){
                [fPrint removeFromParentAndCleanup:YES];
                [footPrints removeObject:fPrint];
                printFound=YES;
                if (footPrints.count==0){
                    [[SimpleAudioEngine sharedEngine] playEffect:@"4.2 KakChisto.wav"];
                    okToFootprint=YES;
                }
                break;
            }
        }
        if (!printFound&&!catWalking&&!CGRectContainsPoint(catty.boundingBox, loc)){
            CGPoint pos=ccp(loc.x, catty.position.y);
            if (pos.x>catty.position.x){
                [catty rotateCatTo:kRight];
                CCLOG(@"Rotating cat to right");
            }
            else if (pos.x<catty.position.x){
                [catty rotateCatTo:kLeft];
                CCLOG(@"Rotating cat to left");
            }
            [catty walkTo:pos];
        }
    }
}

#pragma mark - KotoProtocol

-(void)kotPoshel{
    CCLOG(@"Yer ima comin'!");
    catWalking=YES;
}

-(void)kotPrishel{
    catWalking=NO;
}

-(void)kotStepnul{
    CGFloat one=-80;
    CGFloat two=-55;
    if (catty.orientation==kRight){
        one*=-1;
        two*=-1;
    }
    if (okToFootprint){
        [self spawnFootprintAtPosition:ccpAdd(catty.position, ccp(one, 40))];
        [self spawnFootprintAtPosition:ccpAdd(catty.position, ccp(two, 10))];
    }
    CCLOG(@"%i footprints on screen", footPrints.count);
}

@end
