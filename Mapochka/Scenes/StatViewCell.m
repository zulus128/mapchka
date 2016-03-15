//
//  StatViewCell.m
//  Mapochka
//
//  Created by Alexander on 18.09.13.
//
//

#import "StatViewCell.h"
#import "AppDelegate.h"
@implementation StatViewCell

@synthesize gameId=_gameId;
+(StatViewCell *)view{
    return (StatViewCell *)[[[UIViewController alloc] initWithNibName:@"StatViewCell" bundle:nil] autorelease].view;
}

-(void)setGameId:(int)gameId{
    _gameId =gameId;
    NSDictionary * stat = [[AppController appController].gameStatistics objectAtIndex:gameId];
    self.count.text = [NSString stringWithFormat:@"%d",[[stat objectForKey:@"count"] integerValue]];
    int interval = [[stat objectForKey:@"time"] integerValue];
    
    int hours = interval/(60*60);
    int minuts = (interval - hours*60*60)/ 60;
    if (hours<=0){
        self.time.text = [NSString stringWithFormat:@"%d мин.", minuts];
    }else{
        self.time.text = [NSString stringWithFormat:@"%d ч. %d мин.",hours, minuts];
    }
}



- (void)dealloc {
    [_gameImage release];
    [_count release];
    [_time release];
    [super dealloc];
}
@end
