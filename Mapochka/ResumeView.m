//
//  ResumeViewController.m
//  Mapochka
//
//  Created by Oleg Kohtenko on 19.02.14.
//
//

#import "ResumeView.h"
#import "ASIHTTPRequest.h"
#import "UIDevice+IdentifierAddition.h"

@interface ResumeView ()
@end

@implementation ResumeView

+ (instancetype)view{
    UIViewController *ctrl = [[[UIViewController alloc] initWithNibName:@"ResumeView" bundle:nil] autorelease];
    ResumeView *view = (ResumeView *)ctrl.view;
    view.dateField.inputView = view.datePicker;
    view.dateField.inputAccessoryView = view.toolBar;
    view.nameField.inputAccessoryView = view.toolBar;
    return view;
}



- (void)setChild:(NSMutableDictionary *)child{
    [_child autorelease];
    _child = [child retain];
    if(!child){
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showCancel) userInfo:nil repeats:NO];
        self.child = [NSMutableDictionary dictionary];
    }else{
        [self showCancel];
        
        self.nameField.text = child[CHILD_NAME];
        if (child[CHILD_BIRTHDAY]){
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:[child[CHILD_BIRTHDAY] doubleValue]];
            
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            formatter.dateFormat = @"dd.MM.YYYY";
            self.dateField.text = [formatter stringFromDate:self.datePicker.date];
        }
        else
            self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365];
        self.datePicker.maximumDate = [NSDate date];
        
        
        int sex = [child[CHILD_SEX] intValue];
        if(sex == 1)
            [self malePressed:nil];
        else if (sex == 2)
            [self femalePressed:nil];
        
    }
}

- (void)showCancel{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.cancelButton.alpha = 1.0;
                     } completion:nil];
}

- (void)dealloc {
    [_nameField release];
    [_dateField release];
    [_datePicker release];
    [_toolBar release];
    [_maleButton release];
    [_femaleButton release];
    [_nameLabel release];
    [_sexLabel release];
    [_dateLabel release];
    [_mostBeFilledLabel release];
    [super dealloc];
}

- (IBAction)malePressed:(id)sender {
    self.maleButton.selected = YES;
    self.femaleButton.selected = NO;
}

- (IBAction)femalePressed:(id)sender {
    self.maleButton.selected = NO;
    self.femaleButton.selected = YES;
}

- (IBAction)savePressed:(id)sender {
    BOOL needReturn = NO;
    if(self.nameField.text.length == 0){
        needReturn = YES;
        self.nameLabel.textColor = [UIColor redColor];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    if(self.dateField.text.length == 0){
        needReturn = YES;
        self.dateLabel.textColor = [UIColor redColor];
    }else{
        self.dateLabel.textColor = [UIColor blackColor];
    }
    
    if(!self.maleButton.selected && !self.femaleButton.selected){
        needReturn = YES;
        self.sexLabel.textColor = [UIColor redColor];
    }else{
        self.sexLabel.textColor = [UIColor blackColor];
    }
    
    if(needReturn){
        self.mostBeFilledLabel.hidden = NO;
        return;
    }else
        self.mostBeFilledLabel.hidden = YES;
    
    [self.child setObject:self.nameField.text forKey:CHILD_NAME];
    [self.child setObject:@([self.datePicker.date timeIntervalSince1970]) forKey:CHILD_BIRTHDAY];
    [self.child setObject:@(self.maleButton.selected ? 1 : self.femaleButton.selected ? 2 : 0 ) forKey:CHILD_SEX];
    
    NSString *url = [NSString stringWithFormat:@"http://portal.moslight.com/mapochka/updateUserInfo.php?id=%@&name=%@&birthday=%0.0f&sex=%d&uid=%d",
                     [[UIDevice currentDevice] uniqueDeviceIdentifier],
                     [self.nameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [self.datePicker.date timeIntervalSince1970],
                     self.maleButton.selected ? 1 : self.femaleButton.selected ? 2 : 0,
                     [self.child[@"uid"] intValue]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startAsynchronousWithcompletion:^(ASIHTTPRequest *requestInstance, NSData *responseData, NSError *error) {
        if(responseData){
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if([dict[@"response"] intValue] > 0)
                self.child[@"uid"] = dict[@"response"];
        }
        [self hide];
        SEL selector = sel_registerName("save:");
        if([self.delegate respondsToSelector:selector])
            [self.delegate performSelector:selector withObject:self.child];
        else{
            [[NSJSONSerialization dataWithJSONObject:@[self.child] options:0 error:nil] writeToFile:documentFullPath(@"childs.json")
                                                                                         atomically:YES];
        }
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [self hide];
}

- (void)hide{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
//                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeView_hiden" object:nil];
                     }];
}

- (IBAction)pickerDonePressed:(id)sender {
    if([self.dateField isFirstResponder]){
        [self.dateField resignFirstResponder];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        formatter.dateFormat = @"dd.MM.YYYY";
        self.dateField.text = [formatter stringFromDate:self.datePicker.date];
    }else{
        [self.nameField resignFirstResponder];
    }
    
}

@end
