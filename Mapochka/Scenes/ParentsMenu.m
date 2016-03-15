//
//  ParentsMenu.m
//  Mapochka
//
//  Created by Oleg Kohtenko on 04.06.13.
//
//

#import "ParentsMenu.h"
#import "MainMenu.h"
#import "ScalingMenuItemSprite.h"
#import "CCMenuItem.h"
#import "STStoreKit.h"
#import "StatisticsView.h"
#import "ListOfUsersView.h"
#import "MDParentalGateView.h"

#define LOADING_VIEW_TAG 1

static int const button1Tag = 1;
static int const button2Tag = 2;
static int const button3Tag = 3;
static int const button4Tag = 4;


static int const butterflyMove1Right = 5;
static int const butterflyMove2Right = 6;
static int const butterflySitRight = 7;

static int const butterflyMove1Left = 8;
static int const butterflyMove2Left = 9;
static int const butterflySitLeft = 10;
static int const buttonsMenuTag = 11;

@interface ParentsMenu () <StoreManagerDelegate>
@property (nonatomic) int lastButtonIndex;
@property (nonatomic) CGPoint currentButterflyPosition;
@property (nonatomic) BOOL flying;
@property (nonatomic) BOOL isMoveDirectionRight;
@property (nonatomic, strong) NSMutableArray *butterflyPoints;
@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) UIButton * exitButton;
@property (nonatomic, strong) UIImageView * imageContent1;
@property (nonatomic, strong) UIImageView * imageContent2;
@end

@implementation ParentsMenu

+(CCScene *)scene{
    CCScene *scene=[CCScene node];
    ParentsMenu *layer=[ParentsMenu node];
    [scene addChild:layer];
    return scene;
}


- (void)showLoadingView{
    CGSize s=[CCDirector sharedDirector].winSize;
    CCSprite *bg=[CCSprite spriteWithFile:@"loading.png"];
    bg.position=ccp(s.width/2, s.height/2);
    [self addChild:bg z:0 tag:LOADING_VIEW_TAG];
    
}

- (void)hideLoadingView{
    [self removeChildByTag:LOADING_VIEW_TAG cleanup:YES];
}

- (int) butterflyTagByIndex:(int)index{
    switch (index) {
        case 1:
            return self.isMoveDirectionRight ? butterflyMove1Right : butterflyMove1Left;
        case 2:
            return self.isMoveDirectionRight ? butterflyMove2Right : butterflyMove2Left;
        case 3:
            return self.isMoveDirectionRight ? butterflySitRight : butterflySitLeft;
    }
    return 0;
}

- (void)hideParentView:(UIButton *)sender{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         sender.alpha = 0;
                         self.scroll.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [sender removeFromSuperview];
                         [self.scroll removeFromSuperview];
                     }];
    self.scroll = nil;
    self.exitButton = nil;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;//self.imageContent;
}


-(id)init{
    self=[super init];
    if (self){
        self.isTouchEnabled=YES;
        CGSize s=[CCDirector sharedDirector].winSize;
        
        CCSprite *bg=[CCSprite spriteWithFile:@"parents_bg.png"];
        bg.position=ccp(s.width/2, s.height/2);
        [self addChild:bg];
        
        ScalingMenuItemSprite *facebook = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"facebook-ipad.png"]
                                                                       selectedSprite:nil
                                                                                block:^(id sender) {
                                                                                    NSURL *url = [NSURL URLWithString:@"http://facebook.com"];
                                                                                    [[UIApplication sharedApplication] openURL:url];
                                                                                }];
        
        ScalingMenuItemSprite *restoreButton = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"restore.png"]
                                                                            selectedSprite:nil
                                                                                     block:^(id sender) {
                                                                                         [self showLoadingView];
                                                                                         [STStoreKit getInstance].delegate = self;
                                                                                         [[STStoreKit getInstance] restorePayments];
                                                                                     }];
        
        
        ScalingMenuItemSprite *vk = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"vk.png"]
                                                                 selectedSprite:nil
                                                                          block:^(id sender) {
                                                                              [MDParentalGateView showParentalGateInView:[[CCDirector sharedDirector] view] withHandler:^(MDParentalGateView *view, BOOL success) {
                                                                                  if (success){
                                                                                      [view removeFromSuperview];
                                                                                      NSURL *url = [NSURL URLWithString:@"http://vk.com/yarazvivaumamu"];
                                                                                      [[UIApplication sharedApplication] openURL:url];
                                                                                      
                                                                                  }
                                                                              }];
                                                                          }];
        
        ScalingMenuItemSprite *mdSite = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"site1.png"]
                                                                     selectedSprite:nil
                                                                              block:^(id sender) {
                                                                                  [MDParentalGateView showParentalGateInView:[[CCDirector sharedDirector] view] withHandler:^(MDParentalGateView *view, BOOL success) {
                                                                                      if (success){
                                                                                          [view removeFromSuperview];
                                                                                          NSURL *url = [NSURL URLWithString:@"http://mdtechnologies.ru"];
                                                                                          [[UIApplication sharedApplication] openURL:url];
                                                                                      }
                                                                                  }];
                                                                              }];
        
        ScalingMenuItemSprite *mapochkaSite = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"site2.png"]
                                                                           selectedSprite:nil
                                                                                    block:^(id sender) {
                                                                                        [MDParentalGateView showParentalGateInView:[[CCDirector sharedDirector] view] withHandler:^(MDParentalGateView *view, BOOL success) {
                                                                                            if (success){
                                                                                                [view removeFromSuperview];
                                                                                                NSURL *url = [NSURL URLWithString:@"http://mapochka-ipad.ru"];
                                                                                                [[UIApplication sharedApplication] openURL:url];
                                                                                            }
                                                                                        }];
                                                                                    }];
        
        ScalingMenuItemSprite *button1 = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"parentsButton1.png"]
                                                                      selectedSprite:nil
                                                                               block:^(id sender) {
                                                                                   if (!self.scroll)
                                                                                       self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
                                                                                   self.scroll.alpha = 0.0;
                                                                                   self.imageContent1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveChild.png"]];
                                                                                   [self.scroll addSubview:self.imageContent1];
                                                                                   self.scroll.contentSize = self.imageContent1.frame.size;
                                                                                   
                                                                                   [[[CCDirector sharedDirector] view] addSubview:self.scroll];
                                                                                   [UIView animateWithDuration:0.4
                                                                                                         delay:0
                                                                                                       options:UIViewAnimationOptionCurveEaseInOut
                                                                                                    animations:^{
                                                                                                        self.scroll.alpha = 1.0;
                                                                                                    } completion:^(BOOL finished) {
                                                                                                        if (!self.exitButton)
                                                                                                            self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                                                        UIImage * image = [UIImage imageNamed:@"close_button.png"];
                                                                                                        [self.exitButton setImage:image forState:UIControlStateNormal];
                                                                                                        
                                                                                                        self.exitButton.frame = CGRectMake(900, 25, image.size.width, image.size.height);
                                                                                                        [self.exitButton addTarget:self action:@selector(hideParentView:) forControlEvents:UIControlEventTouchDown];
                                                                                                        self.exitButton.alpha = 0;
                                                                                                        [[[CCDirector sharedDirector] view] addSubview:self.exitButton];
                                                                                                        [UIView animateWithDuration:0.3 animations:^{
                                                                                                            self.exitButton.alpha = 1;
                                                                                                        }];
                                                                                                        
                                                                                                    }];
                                                                               }];
        button1.position=ccp(134, 200);
        //        [self addChild:button1 z:0 tag:button1Tag];
        ScalingMenuItemSprite *button2 = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"parentsButton2.png"]
                                                                      selectedSprite:nil
                                                                               block:^(id sender) {
                                                                                   if (!self.scroll){
                                                                                       self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
                                                                                   }
                                                                                   self.scroll.alpha = 0.0;
                                                                                   self.imageContent1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parentsText1.png"]];
                                                                                   [self.scroll addSubview:self.imageContent1];
                                                                                   self.scroll.contentSize = self.imageContent1.frame.size;
                                                                                   self.scroll.minimumZoomScale = 1;
                                                                                   self.scroll.maximumZoomScale = 2;
                                                                                   self.scroll.delegate = self;
                                                                                   [[[CCDirector sharedDirector] view] addSubview:self.scroll];
                                                                                   [UIView animateWithDuration:0.4
                                                                                                         delay:0
                                                                                                       options:UIViewAnimationOptionCurveEaseInOut
                                                                                                    animations:^{
                                                                                                        self.scroll.alpha = 1.0;
                                                                                                    } completion:^(BOOL finished) {
                                                                                                        if (!self.exitButton)
                                                                                                            self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                                                        UIImage * image = [UIImage imageNamed:@"close_button.png"];
                                                                                                        [self.exitButton setImage:image forState:UIControlStateNormal];
                                                                                                        
                                                                                                        self.exitButton.frame = CGRectMake(900, 50, image.size.width, image.size.height);
                                                                                                        [self.exitButton addTarget:self action:@selector(hideParentView:) forControlEvents:UIControlEventTouchDown];
                                                                                                        self.exitButton.alpha = 0;
                                                                                                        [[[CCDirector sharedDirector] view] addSubview:self.exitButton];
                                                                                                        [UIView animateWithDuration:0.3 animations:^{
                                                                                                            self.exitButton.alpha = 1;
                                                                                                        }];
                                                                                                    }];
                                                                                   
                                                                               }];
        button2.position=ccp(385, 200);
        //        [self addChild:button2 z:0 tag:button2Tag];
        ScalingMenuItemSprite *button3 = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"parentsButton3.png"]
                                                                      selectedSprite:nil
                                                                               block:^(id sender) {
                                                                                   StatisticsView * statiscticView = [StatisticsView  view];
                                                                                   statiscticView.center = [[CCDirector sharedDirector] view].center;
                                                                                   statiscticView.alpha = 0;
                                                                                   [[[CCDirector sharedDirector] view] addSubview:statiscticView];
                                                                                   [UIView animateWithDuration:0.3 animations:^{
                                                                                       statiscticView.alpha = 1;
                                                                                   }];
                                                                               }];
        button3.position=ccp(636, 200);
        //        [self addChild:button3 z:0 tag:button3Tag];
        ScalingMenuItemSprite *button4 = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"parentsButton4.png"]
                                                                      selectedSprite:nil
                                                                               block:^(id sender) {
                                                                                   if (!self.scroll){
                                                                                       self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
                                                                                   }
                                                                                   self.scroll.alpha = 0.0;
                                                                                   self.imageContent1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback1.png"]];
                                                                                   self.imageContent2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback2.png"]];
                                                                                   [self.imageContent2 setFrame:CGRectMake(0,
                                                                                                                           self.imageContent1.frame.size.height,
                                                                                                                           self.imageContent2.frame.size.width,
                                                                                                                           self.imageContent2.frame.size.height)];
                                                                                   [self.scroll addSubview:self.imageContent1];
                                                                                   [self.scroll addSubview:self.imageContent2];
                                                                                   self.scroll.contentSize = CGSizeMake(self.imageContent1.frame.size.width, self.imageContent1.frame.size.height + self.imageContent2.frame.size.height);
                                                                                   self.scroll.minimumZoomScale = 1;
                                                                                   self.scroll.maximumZoomScale = 2;
                                                                                   self.scroll.delegate = self;
                                                                                   [[[CCDirector sharedDirector] view] addSubview:self.scroll];
                                                                                   [UIView animateWithDuration:0.4
                                                                                                         delay:0
                                                                                                       options:UIViewAnimationOptionCurveEaseInOut
                                                                                                    animations:^{
                                                                                                        self.scroll.alpha = 1.0;
                                                                                                    } completion:^(BOOL finished) {
                                                                                                        if (!self.exitButton)
                                                                                                            self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                                                        UIImage * image = [UIImage imageNamed:@"close_button.png"];
                                                                                                        [self.exitButton setImage:image forState:UIControlStateNormal];
                                                                                                        
                                                                                                        self.exitButton.frame = CGRectMake(900, 50, image.size.width, image.size.height);
                                                                                                        [self.exitButton addTarget:self action:@selector(hideParentView:) forControlEvents:UIControlEventTouchDown];
                                                                                                        self.exitButton.alpha = 0;
                                                                                                        [[[CCDirector sharedDirector] view] addSubview:self.exitButton];
                                                                                                        [UIView animateWithDuration:0.3 animations:^{
                                                                                                            self.exitButton.alpha = 1;
                                                                                                        }];
                                                                                                    }];
                                                                                   
                                                                               }];
        button4.position=ccp(890, 200);
        
        
        button3.position=ccp(636, 200);
        //        [self addChild:button3 z:0 tag:button3Tag];
        ScalingMenuItemSprite *button5 = [ScalingMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"anketa_button.png"]
                                                                      selectedSprite:nil
                                                                               block:^(id sender) {
                                                                                   [MDParentalGateView showParentalGateInView:[[CCDirector sharedDirector] view] withHandler:^(MDParentalGateView *view, BOOL success) {
                                                                                       if (success){
                                                                                           [view removeFromSuperview];
                                                                                           ListOfUsersView *v = [ListOfUsersView view];
                                                                                           v.alpha = 0.0;
                                                                                           [[[CCDirector sharedDirector] view] addSubview:v];
                                                                                           [UIView animateWithDuration:0.4
                                                                                                                 delay:0
                                                                                                               options:UIViewAnimationOptionCurveEaseInOut
                                                                                                            animations:^{
                                                                                                                v.alpha = 1.0;
                                                                                                            } completion:nil];
                                                                                       }
                                                                                   }];
                                                                                   
                                                                               }];
        
        button5.position = ccp(950, 200);
        
        CCMenu *menu=[CCMenu menuWithItems:button1, button2, button3, button4, nil];
        [menu setPosition:ccp(s.width/2.0, 300)];
        [menu alignItemsHorizontallyWithPadding:21];
        [self addChild:menu z:0 tag:buttonsMenuTag];
        
        CCMenu *socialNetwork = [CCMenu menuWithItems:mapochkaSite, mdSite, vk, button5, nil];
        [socialNetwork setPosition:ccp(500, 80)];
        [socialNetwork alignItemsHorizontallyWithPadding:21];
        [self addChild:socialNetwork z:0 tag:buttonsMenuTag];
        
        self.currentButterflyPosition = ccp(890, 500);
        
        CCSprite *back=[CCSprite spriteWithFile:@"storyArrLeft.png"];
        ScalingMenuItemSprite *backItem=[ScalingMenuItemSprite itemWithNormalSprite:back selectedSprite:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]]];
        }];
        CCMenu *navMenu=[CCMenu menuWithItems:backItem, nil];
        [navMenu setPosition:ccp(70, s.height-60)];
        [navMenu alignItemsHorizontallyWithPadding:798.0];
        [self addChild:navMenu];
        
        
        
        CCSprite *swing1 = [CCSprite spriteWithFile:@"butterfly_move1.png"];
        swing1.position= self.currentButterflyPosition;
        swing1.visible = NO;
        [self addChild:swing1 z:1 tag:butterflyMove1Left];
        
        CCSprite *swing2 = [CCSprite spriteWithFile:@"butterfly_move2.png"];
        swing2.position= self.currentButterflyPosition;
        swing2.visible = NO;
        [self addChild:swing2 z:1 tag:butterflyMove2Left];
        
        CCSprite *sit = [CCSprite spriteWithFile:@"butterfly_sit.png"];
        sit.position= self.currentButterflyPosition;
        sit.visible = YES;
        [self addChild:sit z:1 tag:butterflySitLeft];
        
        CCSprite *swing1R = [CCSprite spriteWithFile:@"butterfly_move1_backward.png"];
        swing1R.position= self.currentButterflyPosition;
        swing1R.visible = NO;
        [self addChild:swing1R z:1 tag:butterflyMove1Right];
        
        CCSprite *swing2R = [CCSprite spriteWithFile:@"butterfly_move2_backward.png"];
        swing2R.position= self.currentButterflyPosition;
        swing2R.visible = NO;
        [self addChild:swing2R z:1 tag:butterflyMove2Right];
        
        CCSprite *sitR = [CCSprite spriteWithFile:@"butterfly_sit_backward.png"];
        sitR.position= self.currentButterflyPosition;
        sitR.visible = YES;
        [self addChild:sitR z:1 tag:butterflySitRight];
        
        [self schedule:@selector(flyToRandomButton) interval:10.0];
        [self flyToRandomButton];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

- (void)restorationDidCompleteWithNewIds:(NSArray *)purchaseIds{
    [[[UIAlertView alloc] initWithTitle:@"Восстановлено"
                                message:@"Покупки восстановлены!"
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
    [self hideLoadingView];
}

- (void)restorationDidFailWithNewIds:(NSArray *)purchaseIds{
    [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                                message:@"Не удалось восстановить покупки. Попробуйте снова."
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
    [self hideLoadingView];
}

- (void)flyToPoint:(CGPoint)point thruPoint:(CGPoint)middlePoint{
    self.isMoveDirectionRight = self.currentButterflyPosition.x < point.x;
    
    self.isMoveDirectionRight = !self.isMoveDirectionRight;
    CCNode *sit = [self getChildByTag:[self butterflyTagByIndex:3]];
    sit.visible = NO;
    CCNode *swing2 = [self getChildByTag:[self butterflyTagByIndex:2]];
    swing2.visible = NO;
    CCNode *swing1 = [self getChildByTag:[self butterflyTagByIndex:1]];
    swing1.visible = NO;
    self.isMoveDirectionRight = !self.isMoveDirectionRight;
    
    
    
    middlePoint = middlePoint.x == -100 && middlePoint.y == -100 ? getMiddlePoint(self.currentButterflyPosition, point) : middlePoint;
    [self endFly];
    self.flying = YES;
    [self schedule:@selector(swingFirst) interval:0.4];
    [self moveToPoint:point
            thruPoint:middlePoint];
}

- (void)flyToPoint:(CGPoint)point{
    NSLog(@"self.isMoveDirectionRight = %@ ", self.isMoveDirectionRight ? @"YES" : @"NO");
    [self flyToPoint:point thruPoint:CGPointMake(-100, -100)];
}

- (void)flyToRandomButton{
    int buttonIndex;
    do {
        buttonIndex = rand()%5;
    } while (buttonIndex == self.lastButtonIndex || buttonIndex == 0);
    self.lastButtonIndex = buttonIndex;
    CCNode *menu = [self getChildByTag:buttonsMenuTag];
    CCNode *btn = [[self getChildByTag:buttonsMenuTag ] getChildByTag:buttonIndex];
    CGPoint endPoint = CGPointMake(menu.position.x + btn.position.x, 460);
    CGPoint screenMiddle = ccp(getMiddlePoint(self.currentButterflyPosition, endPoint).x, 500);
    [self flyToPoint:endPoint thruPoint:screenMiddle];
    
}

- (void)endFly{
    self.flying = NO;
    [self unschedule:@selector(swingFirst)];
    [self unschedule:@selector(goToNextPoint)];
    
    CCNode *sit = [self getChildByTag:[self butterflyTagByIndex:3]];
    sit.visible = YES;
    CCNode *swing2 = [self getChildByTag:[self butterflyTagByIndex:2]];
    swing2.visible = NO;
    CCNode *swing1 = [self getChildByTag:[self butterflyTagByIndex:1]];
    swing1.visible = NO;
    
}

double distanceBetween(CGPoint point1, CGPoint point2){
    return sqrt(pow((point1.x - point2.x), 2) + pow((point1.y - point2.y), 2));
}

CGPoint getMiddlePoint(CGPoint point1, CGPoint point2){
    return ccp((point1.x + point2.x)/2.0, (point1.y + point2.y)/2.0);
}

- (void)addPointsTo:(inout NSMutableArray *)array betweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2{
    if(distanceBetween(point1, point2) < 20){
        [array addObject:[NSValue valueWithCGPoint:point1]];
        return;
    }
    CGPoint middle = getMiddlePoint(point1, point2);
    
    [self addPointsTo:array betweenPoint:point1 andPoint:middle];
    [self addPointsTo:array betweenPoint:middle andPoint:point2];
}

- (void)moveToPoint:(CGPoint)point thruPoint:(CGPoint)middlePoint{
    NSMutableArray *points = [NSMutableArray array];
    self.butterflyPoints = points;
    
    
    [self addPointsTo:points betweenPoint:self.currentButterflyPosition andPoint:middlePoint];
    [self addPointsTo:points betweenPoint:middlePoint andPoint:point];
    [points addObject:[NSValue valueWithCGPoint:point]];
    
    [self schedule:@selector(goToNextPoint) interval:2.0/points.count];
    
    [self getChildByTag:[self butterflyTagByIndex:3]].position = self.currentButterflyPosition;
    [self getChildByTag:[self butterflyTagByIndex:2]].position = self.currentButterflyPosition;
    [self getChildByTag:[self butterflyTagByIndex:1]].position = self.currentButterflyPosition;
}


- (void)goToNextPoint{
    if(self.butterflyPoints.count == 0){
        [self endFly];
        return;
    }
    self.currentButterflyPosition = [[self.butterflyPoints objectAtIndex:0] CGPointValue];
    [self.butterflyPoints removeObjectAtIndex:0];
    [self getChildByTag:[self butterflyTagByIndex:3]].position = self.currentButterflyPosition;
    [self getChildByTag:[self butterflyTagByIndex:2]].position = self.currentButterflyPosition;
    [self getChildByTag:[self butterflyTagByIndex:1]].position = self.currentButterflyPosition;
}


- (void)swingFirst{
    CCNode *sit = [self getChildByTag:[self butterflyTagByIndex:3]];
    sit.visible = NO;
    CCNode *swing2 = [self getChildByTag:[self butterflyTagByIndex:2]];
    swing2.visible = NO;
    
    CCNode *swing1 = [self getChildByTag:[self butterflyTagByIndex:1]];
    swing1.visible = YES;
    [self performSelector:@selector(swingSecond) withObject:nil afterDelay:0.2];
}

- (void)swingSecond{
    if(!self.flying)
        return;
    CCNode *swing1 = [self getChildByTag:[self butterflyTagByIndex:1]];
    swing1.visible = NO;
    
    CCNode *swing2 = [self getChildByTag:[self butterflyTagByIndex:2]];
    swing2.visible = YES;
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [self convertTouchToNodeSpace:touch];
    [self unschedule:@selector(flyToRandomButton)];
    [self flyToPoint:loc];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [self schedule:@selector(flyToRandomButton) interval:10.0];
    [self flyToRandomButton];
}


-(void)onEnter{
    [super onEnter];
    [Flurry logEvent:@"ParentsMenu" timed:YES];
    MDLogEvent(LOG_TYPE_OTHER, LOG_STORY_OTHER, YES);
}

-(void)onExit{
    [super onExit];
    [Flurry endTimedEvent:@"ParentsMenu" withParameters:nil];
    MDLogEndTimedEvent(LOG_STORY_OTHER);
}

-(void)onEnterTransitionDidFinish{
    //    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menus.mp3"];
}

-(void)onExitTransitionDidStart{
    //    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}
@end
