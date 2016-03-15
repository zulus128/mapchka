//
//  StudyCattyScene.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "StudyCattyScene.h"
#import "SimpleAudioEngine.h"

static int gameId = LOG_GAME_CAT_3;

@interface StudyCattyScene (){
    CCSprite *lyingCat;
    Kot *catty;
    BOOL tailActing;
    BOOL headActing;
    BOOL catWalking;
    BOOL earsActing;
    NSUInteger swipesCount;
}

@end

@implementation StudyCattyScene

+(CCScene*)scene{
    CCScene *scene=[CCScene node];
    StudyCattyScene *layer=[StudyCattyScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        catWalking=NO;
        tailActing=NO;
        headActing=NO;
        earsActing=NO;
        CGSize s=[CCDirector sharedDirector].winSize;
        CCSprite *bg=[CCSprite spriteWithFile:@"bg.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg];
        CCSprite *backSprite=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        CCMenuItemSprite *back=[CCMenuItemSprite itemWithNormalSprite:backSprite selectedSprite:nil block:^(id sender){
//            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5];
            [[CCDirector sharedDirector] popScene];

        }];
        CCMenu *menu=[CCMenu menuWithItems:back, nil];
        [menu setPosition:ccp(70, s.height-70)];
        [self addChild:menu];
        catty=[Kot node];
        [catty setPosition:ccp(s.width/2, s.height/4)];
        [catty setDelegate:self];
        [self addChild:catty];
        
        lyingCat=[CCLayer node];
        lyingCat.contentSize=CGSizeMake(936.0/2, 294.0);
        lyingCat.anchorPoint=ccp(0.5, 0);
        lyingCat.ignoreAnchorPointForPosition=NO;
        CCSprite *lieRightEar=[CCSprite spriteWithFile:@"lieEarLeft.png"];
        lieRightEar.position=ccp(114.0/2 - 25, 147.0);
        [lyingCat addChild:lieRightEar z:0 tag:56];
        CCSprite *lieBody=[CCSprite spriteWithFile:@"lieBody.png"];
        lieBody.position=ccp(512.0/2, 147.0);
        [lyingCat addChild:lieBody z:0 tag:53];
        CCSprite *lieHead=[CCSprite spriteWithFile:@"lieHead.png"];
        lieHead.position=ccpAdd(lieBody.position, ccp(-256+130, -105+63));
        [lyingCat addChild:lieHead z:0 tag:54];
        CCSprite *lieTail=[CCSprite spriteWithFile:@"lieTail.png"];
        lieTail.position=ccpAdd(lieBody.position, ccp(94-45, -160+65));
        [lyingCat addChild:lieTail z:0 tag:57];
        CCSprite *lieLeftEar=[CCSprite spriteWithFile:@"lieEarRight.png"];
        lieLeftEar.position=ccp(361.0/2 - 25, 218.0);
        [lyingCat addChild:lieLeftEar z:0 tag:55];
        lyingCat.position=ccp(0, 0);
        lyingCat.visible=NO;
        [self addChild:lyingCat];
    }
    return self;
}

-(void)dealloc{
    CCLOG(@"StudyCattyScene deallocing.");
    [super dealloc];
}

-(void)onEnter{
    [catty sayThx];
    [super onEnter];
    [Flurry logEvent:@"CatGame3" timed:YES];
    MDLogEvent(LOG_TYPE_STORY, LOG_GAME_CAT_3, YES);
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    self.time = [[NSDate date] timeIntervalSince1970];
    [self playWithMe];
    [self schedule:@selector(playPerfect) interval:rand()%20+ 10];
}


-(void)playPerfect{
    [self unschedule:@selector(playWithMe)];
    [self scheduleOnce:@selector(playWithMe) delay:10];
    [[SimpleAudioEngine sharedEngine] playEffect:@"1.2 SToboyTakInteresnoIgrat.wav"];
    [self unschedule:@selector(playPerfect)];
    [self schedule:@selector(playPerfect) interval:rand()%20 + 10];
}


-(void)playWithMe{
    [self unschedule:@selector(playPerfect)];
    [self schedule:@selector(playPerfect) interval:rand()%20 + 10];
    [[SimpleAudioEngine sharedEngine] playEffect:@"3.1 Poigray.wav"];
    [self unschedule:@selector(playWithMe)];
    [self schedule:@selector(playWithMe) interval:10];
}
-(void)onExit{
    self.time = [[NSDate date] timeIntervalSince1970] - self.time;
    NSMutableDictionary * stat = [[[AppController appController].gameStatistics objectAtIndex:gameId] mutableCopy];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"count"] integerValue]+1] forKey:@"count"];
    [stat setObject:[NSNumber numberWithInt:[[stat objectForKey:@"time"] integerValue]+self.time] forKey:@"time"];
    [[AppController appController].gameStatistics replaceObjectAtIndex:gameId withObject:stat];
    [[AppController appController] saveStat];
    [self unscheduleAllSelectors];
    [super onExit];
    [Flurry endTimedEvent:@"CatGame3" withParameters:nil];
    MDLogEndTimedEvent(LOG_GAME_CAT_3);
}

-(void)catBreath{
    CCSprite *body=(CCSprite*)[lyingCat getChildByTag:53];
    CCSprite *head=(CCSprite*)[lyingCat getChildByTag:54];
    CCSprite *tail=(CCSprite*)[lyingCat getChildByTag:57];
    CCSprite *left=(CCSprite*)[lyingCat getChildByTag:55];
    CCSprite *right=(CCSprite*)[lyingCat getChildByTag:56];
    id scaling=[CCScaleBy actionWithDuration:0.8 scaleX:1.0 scaleY:1.025];
    id moving=[CCMoveBy actionWithDuration:0.8 position:ccp(0, 8.0)];
    id halfMove=[CCMoveBy actionWithDuration:0.8 position:ccp(0, 6.0)];
    [body runAction:scaling];
    [body runAction:moving];
    [head runAction:halfMove];
    [tail runAction:[moving copy]];
    [left runAction:[halfMove copy]];
    [right runAction:[halfMove copy]];
    id revMove=[moving reverse];
    id revMove2=[halfMove reverse];
    [body performSelector:@selector(runAction:) withObject:[scaling reverse] afterDelay:0.85];
    [body performSelector:@selector(runAction:) withObject:revMove afterDelay:0.85];
    [head performSelector:@selector(runAction:) withObject:revMove2 afterDelay:0.85];
    [tail performSelector:@selector(runAction:) withObject:[revMove copy] afterDelay:0.85];
    [left performSelector:@selector(runAction:) withObject:[revMove2 copy] afterDelay:0.85];
    [right performSelector:@selector(runAction:) withObject:[revMove2 copy] afterDelay:0.85];
//    id scaling=[CCScaleBy actionWithDuration:0.8 scaleX:1.0 scaleY:1.025];
//    id moving=[CCMoveBy actionWithDuration:0.8 position:ccp(0, 8.0)];
//    [lyingCat runAction:scaling];
//    [lyingCat runAction:moving];
//    [lyingCat performSelector:@selector(runAction:) withObject:[scaling reverse] afterDelay:0.85];
//    [lyingCat performSelector:@selector(runAction:) withObject:[moving reverse] afterDelay:0.85];
}

#pragma mark - touches

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self unschedule:@selector(playWithMe)];
    [self schedule:@selector(playWithMe) interval:10];
    
    UITouch *touch=[[touches allObjects] objectAtIndex:0];
    CGPoint locUp=[self convertTouchToNodeSpace:touch];
    if (catty.visible){
        CGPoint loc=[catty convertToNodeSpace:locUp];
        if (CGRectContainsPoint(catty.tail.boundingBox, loc)&&!tailActing){
            [catty tailDance];
            tailActing=YES;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                tailActing=NO;
            });
        }else if(CGRectContainsPoint(catty.head.boundingBox, loc)&&!headActing){
            [catty nod];
            headActing=YES;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                headActing=NO;
            });
        }else if(!CGRectContainsPoint(catty.boundingBox, locUp)&&!catWalking&&catty.frontLeg.visible&&catty.rearLeg.visible){
            if (locUp.x<catty.position.x){
                [catty rotateCatTo:kLeft];
            }else{
                [catty rotateCatTo:kRight];
            }
            [catty walkTo:locUp];
        }else if(CGRectContainsPoint(catty.frontLeg.boundingBox, loc)&&!catWalking){
            [catty leftFootUp];
        }else if (CGRectContainsPoint(catty.rearLeg.boundingBox, loc)&&!catWalking){
            [catty rightFootUp];
        }
    }else{
        CGPoint loc=[lyingCat convertToNodeSpace:locUp];
        CCSprite *earLeft=(CCSprite*)[lyingCat getChildByTag:55];
        CCSprite *earRight=(CCSprite*)[lyingCat getChildByTag:56];
        CCSprite *body=(CCSprite*)[lyingCat getChildByTag:53];
        if ((CGRectContainsPoint(earLeft.boundingBox, loc)||CGRectContainsPoint(earRight.boundingBox, loc))&&!earsActing){
            earsActing=YES;
            id leftRot=[CCRotateBy actionWithDuration:0.25 angle:13.0];
            id leftMove=[CCMoveBy actionWithDuration:0.25 position:ccp(8.0, -5.0)];
            id rightRot=[CCRotateBy actionWithDuration:0.25 angle:-13.0];
            id rightMove=[CCMoveBy actionWithDuration:0.25 position:ccp(-2.0, -6.0)];
            [earLeft runAction:leftRot];
            [earLeft runAction:leftMove];
            [earRight runAction:rightRot];
            [earRight runAction:rightMove];
            [earLeft performSelector:@selector(runAction:) withObject:[leftRot reverse] afterDelay:0.3];
            [earLeft performSelector:@selector(runAction:) withObject:[leftMove reverse] afterDelay:0.3];
            [earRight performSelector:@selector(runAction:) withObject:[rightRot reverse] afterDelay:0.3];
            [earRight performSelector:@selector(runAction:) withObject:[rightMove reverse] afterDelay:0.3];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                earsActing=NO;
            });
        }else if (CGRectContainsPoint(body.boundingBox, loc)){
            catty.position=lyingCat.position;
            catty.visible=YES;
            lyingCat.visible=NO;
            [self unschedule:@selector(catBreath)];
        }
    }
}

//-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//    return YES;
//}
//
//-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
//    CGPoint locUp=[self convertTouchToNodeSpace:touch];
//    CGPoint loc=[catty convertToNodeSpace:locUp];
//    if (catty.visible){
//        if (CGRectContainsPoint(catty.tail.boundingBox, loc)&&!tailActing){
//            [catty tailDance];
//            tailActing=YES;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                tailActing=NO;
//            });
//        }else if(CGRectContainsPoint(catty.head.boundingBox, loc)&&!headActing){
//            [catty nod];
//            headActing=YES;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                headActing=NO;
//            });        
//        }else if(!CGRectContainsPoint(catty.boundingBox, locUp)&&!catWalking){
//            if (locUp.x<catty.position.x){
//                [catty rotateCatTo:kLeft];
//            }else{
//                [catty rotateCatTo:kRight];
//            }
//            [catty walkTo:locUp];
//        }
//    }else{
//        
//    }
//}

#pragma mark - Kot delegate

-(void)kotPoshel{
    catWalking=YES;
    [catty eatMore];
}

-(void)kotPrishel{
    catWalking=NO;
    [catty sayThx];
}

-(void)swipedToDirection:(kSwipeDirection)dir{
    if (!catty.visible){
//        swipesCount++;
//        [self scheduleOnce:@selector(resetSwipes) delay:2.5];
//        if (swipesCount>5){
//            catty.position=lyingCat.position;
//            lyingCat.visible=NO;
//            catty.visible=YES;
//            [self unschedule:@selector(catBreath)];
//            [self unschedule:@selector(resetSwipes)];
//            swipesCount=0;
//        }
        return;
    }
    swipesCount++;
    [self scheduleOnce:@selector(resetSwipes) delay:2.5];
    if (swipesCount>5){
        lyingCat.position=catty.position;
        catty.visible=NO;
        lyingCat.visible=YES;
        [self schedule:@selector(catBreath) interval:3];
        [self unschedule:@selector(resetSwipes)];
        swipesCount=0;
    }
}

-(void)resetSwipes{
    swipesCount=0;
}

@end
