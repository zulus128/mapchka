//
//  ToiletsGame1Scene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 4/10/13.
//
//

#import "ToiletsGame1Scene.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

static int gameId = LOG_GAME_TOILET_1;
@interface ToiletsGame1Scene (){
    CCSprite *squirrel;
    CCSprite *frog;
    CCSprite *hedgehog;
    CCSprite *chick;
    CCSprite *toilSq;
    CCSprite *toilFr;
    CCSprite *toilHedge;
    CCSprite *toilChick;
    CCSprite *sqToil;
    CCSprite *frToil;
    CCSprite *heToil;
    CCSprite *chToil;
    //
    NSInteger soundIndex;
    //
    uint movNum;
    BOOL moving;
    uint countDone;
    uint winsCount;
    CGPoint startMovingPos;
    //
    NSMutableArray *toilPlaces;
    BOOL isMoving;
}
-(void)createGame;
-(void)gameWon;
@end

@implementation ToiletsGame1Scene

-(void)gameWon{
    countDone=0;
    movNum=0;
    winsCount++;
    if (winsCount>1){
        //shuffle toilets
        for (uint i=0;i<2;i++){
            int rand=arc4random_uniform(4);
            [toilPlaces exchangeObjectAtIndex:i withObjectAtIndex:rand];
        }
        int i=0;
        for (CCSprite *toil in @[toilSq,toilHedge,toilFr,toilChick]){
            CCSprite *animalOnToilet=(CCSprite*)[self getChildByTag:toil.tag-10];
            CGPoint oldPos=toil.position;
            oldPos.x=[(NSNumber*)[toilPlaces objectAtIndex:i] integerValue];
            [toil setPosition:oldPos];
            [animalOnToilet setPosition:ccp(oldPos.x, animalOnToilet.position.y)];
            i++;
        }
        //shuffle animals
        NSMutableArray *animals=[NSMutableArray arrayWithObjects:squirrel,hedgehog,frog,chick, nil];
        for (int i=0;i<animals.count;i++){
            int rand1=arc4random()%animals.count;
            int rand2=arc4random()%animals.count;
            [animals exchangeObjectAtIndex:rand1 withObjectAtIndex:rand2];
        }
        float pos=10;
        for (int i=0;i<animals.count;i++){
            CCSprite *animal=[animals objectAtIndex:i];
            [animal setPosition:ccp(pos+animal.boundingBox.size.width/2, animal.position.y)];
            pos+=animal.boundingBox.size.width;
        }
    }
    squirrel.visible=YES;
    hedgehog.visible=YES;
    frog.visible=YES;
    chick.visible=YES;
    toilSq.visible=YES;
    toilHedge.visible=YES;
    toilFr.visible=YES;
    toilChick.visible=YES;
    sqToil.visible=NO;
    heToil.visible=NO;
    frToil.visible=NO;
    chToil.visible=NO;
}

-(void)createGame{
    movNum=0;
    countDone=0;
    toilPlaces=[[NSMutableArray alloc] initWithObjects:
                [NSNumber numberWithInteger:173],
                [NSNumber numberWithInteger:435],
                [NSNumber numberWithInteger:659],
                [NSNumber numberWithInteger:878],
                nil];
    squirrel=[CCSprite spriteWithFile:@"tGame1Sq.png"];
    squirrel.position=ccp(195, 551);
    squirrel.tag=10;
    hedgehog=[CCSprite spriteWithFile:@"tGame1He.png"];
    hedgehog.position=ccp(484, 491);
    hedgehog.tag=11;
    frog=[CCSprite spriteWithFile:@"tGame1Fr.png"];
    frog.position=ccp(737, 482);
    frog.tag=12;
    chick=[CCSprite spriteWithFile:@"tGame1Ch.png"];
    chick.position=ccp(925, 486);
    chick.tag=13;
    toilSq=[CCSprite spriteWithFile:@"tGame1ToilSq.png"];
    toilSq.position=ccp(172, 201);
    toilSq.tag=30;
    toilHedge=[CCSprite spriteWithFile:@"tGame1ToilHe.png"];
    toilHedge.position=ccp(437, 193);
    toilHedge.tag=31;
    toilFr=[CCSprite spriteWithFile:@"tGame1ToilFr.png"];
    toilFr.position=ccp(683, 186);
    toilFr.tag=32;
    toilChick=[CCSprite spriteWithFile:@"tGame1ToilCh.png"];
    toilChick.position=ccp(889, 173);
    toilChick.tag=33;
    sqToil=[CCSprite spriteWithFile:@"tGame1SqToil.png"];
    sqToil.position=ccp(173, 302);
    sqToil.tag=20;
    heToil=[CCSprite spriteWithFile:@"tGame1HeToil.png"];
    heToil.position=ccp(435, 287);
    heToil.tag=21;
    frToil=[CCSprite spriteWithFile:@"tGame1FrToil.png"];
    frToil.position=ccp(659, 233);
    frToil.tag=22;
    chToil=[CCSprite spriteWithFile:@"tGame1ChToil.png"];
    chToil.position=ccp(878, 215);
    chToil.tag=23;
    sqToil.visible=NO;
    heToil.visible=NO;
    frToil.visible=NO;
    chToil.visible=NO;
    
    [self addChild:toilSq];
    [self addChild:toilHedge];
    [self addChild:toilFr];
    [self addChild:toilChick];
    [self addChild:squirrel];
    [self addChild:hedgehog];
    [self addChild:frog];
    [self addChild:chick];
    [self addChild:sqToil];
    [self addChild:heToil];
    [self addChild:frToil];
    [self addChild:chToil];
    winsCount = 1;
    [self gameWon];
    winsCount = 1;
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ToiletsGame1Scene *layer=[ToiletsGame1Scene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        winsCount=0;
        CGSize s=[CCDirector sharedDirector].winSize;
        //
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg z:-1];
        
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu z:1];
        
        [self createGame];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    [toilPlaces release];
    [super dealloc];
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [[SimpleAudioEngine sharedEngine] playEffect:@"2.1 Posadi.wav"];
}

-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"ToiletGame1" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_TOILET_1, YES);
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [super onExit];
    [Flurry endTimedEvent:@"ToiletGame1" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_TOILET_1);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (isMoving)
        return NO;
    
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    movNum = 0;
    if (CGRectContainsPoint(squirrel.boundingBox, loc)&&squirrel.visible){
        startMovingPos=squirrel.position;
        movNum=1;
        moving=YES;
    }else if (CGRectContainsPoint(hedgehog.boundingBox, loc)&&hedgehog.visible){
        startMovingPos=hedgehog.position;
        movNum=2;
        moving=YES;
    }else if (CGRectContainsPoint(frog.boundingBox, loc)&&frog.visible){
        startMovingPos=frog.position;
        movNum=3;
        moving=YES;
    }else if (CGRectContainsPoint(chick.boundingBox, loc)&&chick.visible){
        startMovingPos=chick.position;
        movNum=4;
        moving=YES;
    }
    return moving;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (isMoving || movNum == 0)
        return;
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    switch (movNum) {
        case 1:
            squirrel.position=loc;
            break;
        case 2:
            hedgehog.position=loc;
            break;
        case 3:
            frog.position=loc;
            break;
        case 4:
            chick.position=loc;
            break;
        default:
            break;
    }
}

-(void)playErrorSound{
    if (soundIndex==1) soundIndex = 0;
    else soundIndex = 1;
    
    switch (soundIndex) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"2.4 Poprobyi.wav"];
            break;
        default:
            break;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    id move=NULL;
    if (isMoving || movNum == 0)
        return;
    switch (movNum) {
        case 1:
            if (CGRectIntersectsRect(squirrel.boundingBox, toilSq.boundingBox)){
                squirrel.visible=NO;
                toilSq.visible=NO;
                sqToil.visible=YES;
                countDone++;
            }else{
                [self playErrorSound];
            }
            move=[CCMoveTo actionWithDuration:0.6 position:startMovingPos];
            isMoving = YES;
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(movingEnd) userInfo:Nil repeats:NO];
            [squirrel runAction:move];
            break;
        case 2:
            if (CGRectIntersectsRect(hedgehog.boundingBox, toilHedge.boundingBox)){
                hedgehog.visible=NO;
                toilHedge.visible=NO;
                heToil.visible=YES;
                countDone++;
            }else{
                [self playErrorSound];
            }
            move=[CCMoveTo actionWithDuration:0.6 position:startMovingPos];
            isMoving = YES;
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(movingEnd) userInfo:Nil repeats:NO];
            [hedgehog runAction:move];
            break;
        case 3:
            if (CGRectIntersectsRect(frog.boundingBox, toilFr.boundingBox)){
                frog.visible=NO;
                toilFr.visible=NO;
                frToil.visible=YES;
                countDone++;
            }else{
                [self playErrorSound];
            }
            move=[CCMoveTo actionWithDuration:0.6 position:startMovingPos];
            isMoving = YES;
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(movingEnd) userInfo:Nil repeats:NO];
            [frog runAction:move];
            break;
        case 4:
            if (CGRectIntersectsRect(chick.boundingBox, toilChick.boundingBox)){
                chick.visible=NO;
                toilChick.visible=NO;
                chToil.visible=YES;
                countDone++;
            }else{
                [self playErrorSound];
            }
            move=[CCMoveTo actionWithDuration:0.6 position:startMovingPos];
            isMoving = YES;
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(movingEnd) userInfo:Nil repeats:NO];

            [chick runAction:move];
            break;
        default:
            break;
    }

    movNum=0;
    moving=NO;
    if (countDone==4){
        [[SimpleAudioEngine sharedEngine] playEffect:@"2.2 Pravilno.wav"];
        [self scheduleOnce:@selector(gameWon) delay:1.5];
    }
}

-(void)movingEnd{
    isMoving = NO;
}

@end
