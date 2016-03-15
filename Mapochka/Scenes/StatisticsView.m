//
//  StatisticsView.m
//  Mapochka
//
//  Created by Alexander on 18.09.13.
//
//

#import "StatisticsView.h"
#import "StatViewCell.h"
@implementation StatisticsView


- (IBAction)exit:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self retain];
    }];
    
}

+(StatisticsView *)view{
    StatisticsView * view = (StatisticsView *)[[[UIViewController alloc] initWithNibName:@"StatisticsView" bundle:nil]autorelease].view;
    view.imagesNameArray = @[
                             
                             @{ @"name" : @"storyBird-ipad.png", @"index" : @(LOG_STORY_BIRD) },
                             @{ @"name" : @"storyCat-ipad.png", @"index" : @(LOG_STORY_CAT) },
                             @{ @"name" : @"storyPoop-ipad.png", @"index" : @(LOG_STORY_TOILET) },
                             @{ @"name" : @"", @"index" : @(-1) },
                             @{ @"name" : @"birdGame1-ipad.png", @"index" : @(LOG_GAME_BIRD_1) },
                             @{ @"name" : @"birdGame2-ipad.png", @"index" : @(LOG_GAME_BIRD_4) },
                             @{ @"name" : @"birdGame3-ipad.png", @"index" : @(LOG_GAME_BIRD_5) },
                             @{ @"name" : @"birdGame4-ipad.png", @"index" : @(LOG_GAME_BIRD_3) },
                             @{ @"name" : @"birdGame5-ipad.png", @"index" : @(LOG_GAME_BIRD_2) },
                             @{ @"name" : @"birdGame6-ipad.png", @"index" : @(LOG_GAME_BIRD_6) },
                             @{ @"name" : @"catGame1-ipad.png", @"index" : @(LOG_GAME_CAT_1) },
                             @{ @"name" : @"catGame2-ipad.png", @"index" : @(LOG_GAME_CAT_2) },
                             @{ @"name" : @"catGame3-ipad.png", @"index" : @(LOG_GAME_CAT_3) },
                             @{ @"name" : @"catGame5-ipad.png", @"index" : @(LOG_GAME_CAT_4) },
                             @{ @"name" : @"catGame6-ipad.png", @"index" : @(LOG_GAME_CAT_5) },
                             @{ @"name" : @"toiletGame1-ipad.png", @"index" : @(LOG_GAME_TOILET_1) },
                             @{ @"name" : @"toiletGame2-ipad.png", @"index" : @(LOG_GAME_TOILET_2) },
                             @{ @"name" : @"toiletGame3-ipad.png", @"index" : @(LOG_GAME_TOILET_3) },
                             @{ @"name" : @"toiletGame4-ipad.png", @"index" : @(LOG_GAME_TOILET_4) },
                             @{ @"name" : @"toiletGame5-ipad.png", @"index" : @(LOG_GAME_TOILET_5) },
                             ];
    return view;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.imagesNameArray[indexPath.row];
    int index = [dict[@"index"] intValue];
    if(index == -1)
        return self.separatorCell.frame.size.height;

    return 340;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.imagesNameArray[indexPath.row];
    int index = [dict[@"index"] intValue];
    if(index == -1)
        return self.separatorCell;
    StatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StatViewCell"];
    if (!cell) cell = [StatViewCell view];
    
    cell.gameId = index;
    float scale = [[UIScreen mainScreen] scale];
    UIImage * image = nil;
    NSString *name = dict[@"name"];
    if(scale > 1.5){
        name = [name stringByReplacingOccurrencesOfString:@"-ipad" withString:@"-ipadhd"];
    }
    image = [UIImage imageNamed:name];
    image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
    cell.gameImage.image = image;
    return cell;
}

@end
