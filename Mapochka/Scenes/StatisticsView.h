//
//  StatisticsView.h
//  Mapochka
//
//  Created by Alexander on 18.09.13.
//
//

#import <Foundation/Foundation.h>

@interface StatisticsView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSArray * imagesNameArray;
@property (nonatomic, strong) IBOutlet UITableViewCell *separatorCell;

- (IBAction)exit:(id)sender;
+(StatisticsView *)view;
@end
