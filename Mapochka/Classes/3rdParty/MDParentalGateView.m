//
//  MDParentalGateView.m
//  Mapochka
//
//  Created by ALEXANDER GLADYSHEV on 05/05/14.
//
//

#import "MDParentalGateView.h"

@implementation MDParentalGateView


+ (MDParentalGateView *)view{
    UIViewController * ctrl = [[UIViewController alloc] initWithNibName:@"MDParentalGateView" bundle:nil];
    return (MDParentalGateView *)ctrl.view;
}



- (void)showQuestion{
    if (!self.qBase){
        
        self.qBase = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ParentalBase"
                                                                                                                            ofType:@"json"]]
                                                     options:0
                                                       error:nil];
    }
    if (self.qBase.count > 0){
        self.currentQuestion = [self.qBase objectAtIndex:rand()%self.qBase.count];
        
        self.quesLabel.text = [self.currentQuestion objectForKey:@"question"];
        self.answerTextField.text = @"";
    }
}

+ (void)showParentalGateInView:(UIView *)parentView withHandler:(MDParentalGateBlock)handler{
    MDParentalGateView * pView = [[self class] view];
    [[NSNotificationCenter defaultCenter] addObserver:pView
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:pView
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    pView.handler = handler;
    pView.alpha = 0;
    pView.center = CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height/2);
    [parentView addSubview:pView];
    [pView showQuestion];
    [UIView animateWithDuration:0.3 animations:^{
        pView.alpha = 1;
    }];
}
-(void)keyboardWillShow{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.contentView.frame.size.height);
    } completion:nil];
}


-(void)keyboardWillHide{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    } completion:nil];
}

- (void)dealloc {
    [_quesLabel release];
    [_answerTextField release];
    [_qBase release];
    [_handler release];
    [_currentQuestion release];
    [super dealloc];
}
- (IBAction)checkAnswer:(id)sender {
    if ([self.answerTextField.text isEqualToString:[self.currentQuestion objectForKey:@"answer"]]){
        if (self.handler){
            self.handler(self,YES);
            [self.answerTextField resignFirstResponder];
        }
    }else{
        if (self.handler)
            self.handler(self,NO);
    }
}

-(void)removeFromSuperview{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

-(void)initBase{
    NSMutableArray * array = [NSMutableArray array];
    NSString * actions = @"+-";
    for (int i = 0; i<2000; i++){
        NSMutableDictionary * ques = [NSMutableDictionary dictionary];
        int a = 0;
        int b = 0;
        while (a == 0 || b == 0) {
            a = rand()%10 + 1;
            b = rand()%10 + 1;
        }
        int ans = 0;
        NSString * action = [actions substringWithRange:NSMakeRange(rand()%actions.length, 1)];
        if ([action isEqualToString:@"+"]){
            ans = a + b;
        }else if ([action isEqualToString:@"-"]){
            if (a<b){
                a = a+b;
                b = a-b;
                a  = a-b;
            }
            ans = a - b;
        }else if ([action isEqualToString:@"/"]){
            if (a<b){
                a = a+b;
                b = a-b;
                a  = a-b;
            }
            a = a - (a % b);
            ans = a / b;
        }else if ([action isEqualToString:@"*"]){
            ans = a * b;
        }
        NSString * q = [NSString stringWithFormat:@"Решите пример:\n%d %@ %d",a,action,b];
        [ques setObject:q forKey:@"question"];
        [ques setObject:[NSString stringWithFormat:@"%d",ans] forKey:@"answer"];
        [array addObject:ques];
    }
    [[NSJSONSerialization dataWithJSONObject:array
                                     options:0
                                       error:nil] writeToFile:cachesFullPath(@"ParentalBase.json")
     atomically:YES];
}

- (IBAction)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self)
            [self removeFromSuperview];
    }];
}
@end
