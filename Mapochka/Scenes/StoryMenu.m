//
//  StoryMenu.m
//  Mapochka
//
//  Created by Nikita Anisimov on 3/9/13.
//
//

#import "StoryMenu.h"
#import "ScalingMenuItemSprite.h"
#import "GameMenu.h"
#import "KotenokLayer.h"
#import "BirdStoryScene.h"
#import "ToiletStoryScene.h"
#import "MainMenu.h"
#import "STStoreKit.h"
#define LOADING_VIEW_TAG 1

@interface StoryMenu ()<StoreManagerDelegate>{
    
}
@property (nonatomic, assign) CCSprite *buy1;
@property (nonatomic, assign) CCSprite *buy2;
@end

@implementation StoryMenu

- (void)showLoadingView{
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"loading.png"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:0 tag:LOADING_VIEW_TAG];
    
}

- (void)hideLoadingView{
    [self removeChildByTag:LOADING_VIEW_TAG cleanup:YES];
}

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    StoryMenu *layer=[StoryMenu node];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"storyBg.jpg"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg];
        
        CCSprite *month=[CCSprite spriteWithFile:@"story6mon.png"];
        month.position=ccp(128, 512);
        [self addChild:month];
        CCSprite *year=[CCSprite spriteWithFile:@"story1year.png"];
        year.position=ccp(128, 262);
        [self addChild:year];
        
        CCSprite *back=[CCSprite spriteWithFile:@"homeButton.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]]];
        }];
        //        [backItem setPosition:ccp(60, 700)];
        CCMenu *menu2=[CCMenu menuWithItems:backItem, nil];
        [menu2 setPosition:ccp(60, 700)];
        [self addChild:menu2 z:0];
        //        [self addChild:backItem];
        
        CCSprite *bird=[CCSprite spriteWithFile:@"storyBird.png"];
        CCSprite *birdS=[CCSprite spriteWithFile:@"storyBird.png"];
        CCSprite *cat=[CCSprite spriteWithFile:@"storyCat.png"];
        CCSprite *catS=[CCSprite spriteWithFile:@"storyCat.png"];
        CCSprite *poop=[CCSprite spriteWithFile:@"storyPoop.png"];
        CCSprite *poopS=[CCSprite spriteWithFile:@"storyPoop.png"];
        CCSprite *squirrel=[CCSprite spriteWithFile:@"storySquirrel.png"];
        CCSprite *squirrelS=[CCSprite spriteWithFile:@"storySquirrel.png"];
        ScalingMenuItemSprite *birdItem=[ScalingMenuItemSprite itemWithNormalSprite:bird selectedSprite:birdS block:^(id sender){
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BirdStoryScene scene]]];
        }];
        ScalingMenuItemSprite *catItem=[ScalingMenuItemSprite itemWithNormalSprite:cat selectedSprite:catS block:^(id sender){
            if(![[STStoreKit getInstance] isItemPurchased:@"com.moslight.mapochka.cats"]){
                [self showLoadingView];
                [STStoreKit getInstance].delegate = self;
                [[STStoreKit getInstance] buyFeature:@"com.moslight.mapochka.cats"];
            }else
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[KotenokLayer scene]]];
        }];
        ScalingMenuItemSprite *squirrelItem=[ScalingMenuItemSprite itemWithNormalSprite:squirrel selectedSprite:squirrelS block:^(id sender){
        }];
        squirrelItem.isEnabled = NO;
        ScalingMenuItemSprite *poopItem=[ScalingMenuItemSprite itemWithNormalSprite:poop selectedSprite:poopS block:^(id sender){
            if(![[STStoreKit getInstance] isItemPurchased:@"com.moslight.mapochka.toilet"]){
                [self showLoadingView];
                [STStoreKit getInstance].delegate = self;
                [[STStoreKit getInstance] buyFeature:@"com.moslight.mapochka.toilet"];
            }else
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ToiletStoryScene scene]]];
        }];
        
        CCMenu *mMenu1=[CCMenu menuWithItems:birdItem, poopItem, nil];
        mMenu1.position=ccp(346, 330);
        [mMenu1 alignItemsVerticallyWithPadding:16.0];
        [self addChild:mMenu1];
        CCMenu *mMenu2=[CCMenu menuWithItems:catItem, squirrelItem, nil];
        mMenu2.position=ccp(713, 330);
        [mMenu2 alignItemsVerticallyWithPadding:16.0];
        [self addChild:mMenu2];
        if(![[STStoreKit getInstance] isItemPurchased:@"com.moslight.mapochka.cats"]){
            cat.opacity = 128;
            //soon_button
            //33_button
            ScalingMenuItemSprite *purchaseButton = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"33_button.png"]
                                                                                 selectedSprite:nil
                                                                                          block:^(id sender) {
                                                                                          }];
            purchaseButton.position = ccp(200,280);
            [cat addChild:purchaseButton z:0 tag:1];
            self.buy1 = cat;
        }
        if(![[STStoreKit getInstance] isItemPurchased:@"com.moslight.mapochka.toilet"]){
            poop.opacity = 128;
            ScalingMenuItemSprite *purchaseButton = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"33_button.png"]
                                                                                 selectedSprite:nil
                                                                                          block:^(id sender) {
                                                                                          }];
            purchaseButton.position = ccp(200,280);
            [poop addChild:purchaseButton z:0 tag:1];
            self.buy2 = poop;
        }
        
        
        squirrel.opacity = 128;
        squirrelS.opacity = 128;
        ScalingMenuItemSprite *purchaseButton = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"soon_button.png"]
                                                                             selectedSprite:nil
                                                                                      block:^(id sender) {
                                                                                      }];
        purchaseButton.position = ccp(200,280);
//        [squirrel addChild:purchaseButton z:0 tag:1];
    }
    return self;
}

- (void)paymentDidCompleteWithId:(NSString *)inAppId{
    [self hideLoadingView];
    
    if([inAppId isEqualToString:@"com.moslight.mapochka.cats"]){
        [self.buy1 removeChildByTag:1 cleanup:YES];
        self.buy1.opacity = 255;
        self.buy1 = nil;
    }
    if([inAppId isEqualToString:@"com.moslight.mapochka.toilet"]){
        [self.buy2 removeChildByTag:1 cleanup:YES];
        self.buy2.opacity = 255;
        self.buy2 = nil;
    }
}

- (void)paymentDidFailWithId:(NSString *)inAppId{
    [self hideLoadingView];
}


-(void)onEnter{
    [super onEnter];
}

-(void)onExit{
    [super onExit];
}

-(void)onEnterTransitionDidFinish{
    [Flurry logEvent:@"EnterStoryMenu"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menus.mp3"];
}

-(void)onExitTransitionDidStart{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

@end
