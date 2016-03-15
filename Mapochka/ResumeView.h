//
//  ResumeViewController.h
//  Mapochka
//
//  Created by Oleg Kohtenko on 19.02.14.
//
//

#import <UIKit/UIKit.h>

@interface ResumeView : UIView
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *dateField;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIButton *maleButton;
@property (retain, nonatomic) IBOutlet UIButton *femaleButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *sexLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *mostBeFilledLabel;

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) NSMutableDictionary *child;

+ (instancetype)view;

@end
