//
//  ListOfUsersView.h
//  Mapochka
//
//  Created by oleg Kohtenko on 3/20/14.
//
//

#import <UIKit/UIKit.h>

@interface ListOfUsersView : UIView
@property (nonatomic, assign) IBOutlet UITableView *table;
+ (instancetype)view;
@end
