//
//  MDParentalGateView.h
//  Mapochka
//
//  Created by ALEXANDER GLADYSHEV on 05/05/14.
//
//

#import <Foundation/Foundation.h>

@class MDParentalGateView;

typedef void (^MDParentalGateBlock) (MDParentalGateView * view,BOOL success);

@interface MDParentalGateView : UIView
@property (retain, nonatomic) IBOutlet UILabel *quesLabel;
@property (retain, nonatomic) IBOutlet UITextField *answerTextField;
@property (nonatomic, retain) NSArray * qBase;
@property (nonatomic, retain) NSDictionary * currentQuestion;
@property (nonatomic, copy) MDParentalGateBlock handler;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *contentView;

- (IBAction)checkAnswer:(id)sender;
- (void)hide;
+ (void)showParentalGateInView:(UIView *)parentView withHandler:(MDParentalGateBlock)handler;
- (IBAction)showQuestion;
@end
