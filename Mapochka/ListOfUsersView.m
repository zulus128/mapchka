//
//  ListOfUsersView.m
//  Mapochka
//
//  Created by oleg Kohtenko on 3/20/14.
//
//

#import "ListOfUsersView.h"
#import "ResumeView.h"
#import "UIAlertView+Blocks.h"

@interface UserCell : UITableViewCell
+ (instancetype)cell;
@property (nonatomic, retain) NSDictionary *user;
@property (nonatomic, assign) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) IBOutlet UIButton *removeButton;
@property (nonatomic, assign) id delegate;
@end

@implementation UserCell

+ (instancetype)cell{
    UIViewController *ctrl = [[[UIViewController alloc] initWithNibName:@"UserCell" bundle:nil] autorelease];
    UserCell *view = (UserCell *)ctrl.view;
    [view setBackgroundView:nil];
    [view setBackgroundView:[[[UIView alloc] init] autorelease]];
    [view setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    return view;
}

- (NSString *)reuseIdentifier{
    return @"UserCell";
}

- (void)setUser:(NSDictionary *)user{
    [_user autorelease];
    _user = [user retain];
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, 1000, self.nameLabel.frame.size.height);
    self.nameLabel.text = user[CHILD_NAME];
    [self.nameLabel sizeToFit];
    self.removeButton.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 30,
                                         self.removeButton.frame.origin.y,
                                         self.removeButton.frame.size.width,
                                         self.removeButton.frame.size.height);
}

- (IBAction)removePressed:(id)sender{
    SEL selector = sel_registerName("removeUser:");
    if([self.delegate respondsToSelector:selector])
        [self.delegate performSelector:selector withObject:self.user];
}

- (IBAction)editPressed:(id)sender{
    SEL selector = sel_registerName("editUser:");
    if([self.delegate respondsToSelector:selector])
        [self.delegate performSelector:selector withObject:self.user];
}

@end

@interface ListOfUsersView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *users;
@end

@implementation ListOfUsersView

- (void)removeUser:(NSDictionary *)user{
    [UIAlertView displayAlertWithTitle:@"Внимание"
                               message:@"Вы действительно хотите удалить эту запись?"
                       leftButtonTitle:@"Да"
                      leftButtonAction:^{
                          [self.users removeObject:user];
                          [[NSJSONSerialization dataWithJSONObject:self.users options:0 error:nil] writeToFile:documentFullPath(@"childs.json") atomically:YES];
                          [self.table reloadData];
                      }
                      rightButtonTitle:@"Нет"
                     rightButtonAction:^{
                         
                     }];
}

+ (instancetype)view{
    UIViewController *ctrl = [[[UIViewController alloc] initWithNibName:@"ListOfUsersView" bundle:nil] autorelease];
    ListOfUsersView *view = (ListOfUsersView *)ctrl.view;
    NSData *data = [NSData dataWithContentsOfFile:documentFullPath(@"childs.json")];
    if(data)
        view.users = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    else
        view.users = [NSMutableArray array];
    return view;
}

- (void)save:(NSMutableDictionary *)user{
    BOOL found = NO;
    for (NSDictionary *u in self.users) {
        if(u == user){
            found = YES;
            break;
        }
    }
    if(!found)
        [self.users addObject:user];
    [[NSJSONSerialization dataWithJSONObject:self.users options:0 error:nil] writeToFile:documentFullPath(@"childs.json") atomically:YES];
    [self.table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if(!cell) cell = [UserCell cell];
    cell.delegate = self;
    cell.user = self.users[indexPath.row];
    return cell;
}

- (IBAction)addPressed:(id)sender{
    [self editUser:nil];
}

- (void)editUser:(NSMutableDictionary *)dict{
    ResumeView *v = [ResumeView view];
    v.cancelButton.alpha = 1.0;
    v.child = dict;
    v.delegate = self;
    [self addSubview:v];
}

- (IBAction)hide{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeView_hiden" object:nil];
                     }];
}

@end
