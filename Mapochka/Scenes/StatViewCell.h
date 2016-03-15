//
//  StatViewCell.h
//  Mapochka
//
//  Created by Alexander on 18.09.13.
//
//

#import <Foundation/Foundation.h>

@interface StatViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *gameImage;
@property (retain, nonatomic) IBOutlet UILabel *count;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (nonatomic) int gameId;

+(StatViewCell *)view;
@end
