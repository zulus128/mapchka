//
//  BigSmallScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "BigSmallScene.h"
#import "SimpleAudioEngine.h"
#define CATRECTLEFT CGRectMake(63,116,425,575)
#define CATRECTRIGHT CGRectMake(0,0,0,0)

static int gameId = LOG_GAME_CAT_1;

@interface BigSmallScene (){
    BOOL catNoding;
    BOOL allow_touch;
    int step;
}

-(void)catNod;
-(void)swapCats;

@end

@implementation BigSmallScene

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    BigSmallScene *layer=[BigSmallScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        allow_touch = YES;
        self.isTouchEnabled=YES;
        catNoding=NO;
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bgWithBodies=[CCSprite spriteWithFile:@"mom&catNew.png"];
        [bgWithBodies setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bgWithBodies];
        //make her head
        herHead=[CCSprite spriteWithFile:@"head.png"];
        [herHead setPosition:ccp(356.0, 547.0)];
        [self addChild:herHead];
        
        eyesup=[CCSprite spriteWithFile:@"eyesup.png"];
//        [eyesup setPosition:ccp(349.0, 513)];
//        [self addChild:eyesup];
        [eyesup setPosition:ccpAdd(ccp(herHead.position.x+herHead.contentSize.width/2, herHead.position.y+herHead.contentSize.height/2), ccp(-352-10, -513-69))];
        [herHead addChild:eyesup];
        
        eyesdown=[CCSprite spriteWithFile:@"eyesdown.png"];
        [eyesdown setPosition:eyesup.position];
        [eyesdown setVisible:NO];
        [herHead addChild:eyesdown];
//        [self addChild:eyesdown];
        
        veki=[CCSprite spriteWithFile:@"veki.png"];
        [veki setPosition:ccpAdd(eyesup.position, ccp(0, 8))];
        [veki setVisible:YES];
//        [self addChild:veki];
        [herHead addChild:veki];
        
        eyesoff=[CCSprite spriteWithFile:@"eyesoff.png"];
        [eyesoff setPosition:eyesup.position];
        [eyesoff setVisible:NO];
//        [self addChild:eyesoff];
        [herHead addChild:eyesoff];
        
        //598 , 429
        catty=[Kot node];
        catty.position=ccp(755, 768-656);
        catty.scale=0.8;
        [catty sayThx];
        [self addChild:catty];
        
//        CCSprite *hisHead=[CCSprite spriteWithFile:@"headThx.png"];
//        [hisHead setPosition:ccp(598, 429)];
//        [self addChild:hisHead];
//        
//        hisVeki=[CCSprite spriteWithFile:@"catEyesoff.png"];
//        [hisVeki setPosition:ccp(578, 401)];
//        [hisVeki setVisible:NO];
//        [self addChild:hisVeki];
//        
//        CCSprite *tail=[CCSprite spriteWithFile:@"tailey.png"];
//        [tail setPosition:ccp(893, 457)];
//        [self addChild:tail];
        
        //menu
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
    }
    return self;
}

-(void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)dealloc{
    CCLOG(@"BigSmallScene deallocing.");
    [super dealloc];
}

-(void)onEnter{
//    [self schedule:@selector(hisVekiOn) interval:2];
    [self schedule:@selector(herVekiOn) interval:3];
    [super onEnter];
    [Flurry logEvent:@"CatGame1" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_1, YES);
    
}



//-(void)hisVekiOn{
//    hisVeki.visible=YES;
//    [self scheduleOnce:@selector(hisVekiInvert) delay:0.25];
//}

-(void)herVekiOn{
    eyesoff.visible=YES;
    [self scheduleOnce:@selector(herVekiInvert) delay:0.25];
}

//-(void)hisVekiInvert{
//    hisVeki.visible=NO;
//}

-(void)herVekiInvert{
    eyesoff.visible=NO;
}

-(void)catNod{
    CCLOG(@"CatNod");
    if (catNoding) return;
    catNoding=YES;
    id move=[CCMoveBy actionWithDuration:0.3 position:ccp(12, -20)];
    id spin=[CCRotateBy actionWithDuration:0.3 angle:9.0];
    [herHead runAction:move];
    [herHead runAction:spin];
    [herHead performSelector:@selector(runAction:) withObject:[move reverse] afterDelay:0.35];
    [herHead performSelector:@selector(runAction:) withObject:[spin reverse] afterDelay:0.35];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        catNoding=NO;
    });
}

-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleAllSelectors];
    [super onExit];
    [Flurry endTimedEvent:@"CatGame1" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_1);
}


//action

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [self playAction];
}




-(void)playAction{
    switch (step) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.1 Kto1.wav"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.2 Kto2.wav"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.3 Kto3.wav"];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1.4 Kto4.wav"];
            break;
        default:
            break;
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        allow_touch = YES;
    });
}


-(void)playRight{
    [[SimpleAudioEngine sharedEngine] playEffect:@"1.5 Molodec.wav"];
}


#pragma mark - Touches



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}



-(void)swapCats{
    self.isTouchEnabled=NO;
    catNoding=NO;
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bgWithBodies=[CCSprite spriteWithFile:@"mom&catNew.png"];
    [bgWithBodies setPosition:ccp(s.width/2, s.height/2)];
    [self addChild:bgWithBodies];
    //make her head
    herHead=[CCSprite spriteWithFile:@"head.png"];
    [herHead setPosition:ccp(356.0, 547.0)];
    [self addChild:herHead];
    
    eyesup=[CCSprite spriteWithFile:@"eyesup.png"];
    //        [eyesup setPosition:ccp(349.0, 513)];
    //        [self addChild:eyesup];
    [eyesup setPosition:ccpAdd(ccp(herHead.position.x+herHead.contentSize.width/2, herHead.position.y+herHead.contentSize.height/2), ccp(-352-10, -513-69))];
    [herHead addChild:eyesup];
    
    eyesdown=[CCSprite spriteWithFile:@"eyesdown.png"];
    [eyesdown setPosition:eyesup.position];
    [eyesdown setVisible:NO];
    [herHead addChild:eyesdown];
    //        [self addChild:eyesdown];
    
    veki=[CCSprite spriteWithFile:@"veki.png"];
    [veki setPosition:ccpAdd(eyesup.position, ccp(0, 8))];
    [veki setVisible:YES];
    //        [self addChild:veki];
    [herHead addChild:veki];
    
    eyesoff=[CCSprite spriteWithFile:@"eyesoff.png"];
    [eyesoff setPosition:eyesup.position];
    [eyesoff setVisible:NO];
    //        [self addChild:eyesoff];
    [herHead addChild:eyesoff];
    
    //598 , 429
    catty=[Kot node];
    catty.position=ccp(755, 768-656);
    catty.scale=0.8;
    [catty sayThx];
    [self addChild:catty];
    
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!allow_touch)
        return;
    allow_touch = NO;
    CCLOG(@"%f,%f,%f,%f", CATRECTLEFT.origin.x,CATRECTLEFT.origin.y,CATRECTLEFT.size.width,CATRECTLEFT.size.height);
    CGPoint loc=[self convertTouchToNodeSpace:touch];
    if (!catNoding && !catty.noding.boolValue){
        if (CGRectContainsPoint(catty.boundingBox, loc)){
            if (step == 1 || step == 3){
                step++;
                [self playRight];
                [catty nod];
            }else{
                [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
            }
        }else if (CGRectContainsPoint(CATRECTLEFT, loc)){
            if (step == 0 || step == 2){
                step++;
                [self playRight];
                [self catNod];
            }else{
                [[SimpleAudioEngine sharedEngine] playEffect:@"2.3 NeNe.wav"];
            }
        }
    }
    step = step == 4 ? 0: step;
    [self schedule:@selector(playAction) interval:0 repeat:NO delay:1.5];
}

@end
