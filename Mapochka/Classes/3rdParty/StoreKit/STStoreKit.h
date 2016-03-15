//
//  STStoreKit.h
//  7Steps
//
//  Created by Oleg Kokhtenko on 2/18/13.
//  Copyright (c) 2013 Oleg Kokhtenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol StoreManagerDelegate <NSObject>
@optional
-(void)restoredInApp:(NSString *)inapp;
-(void)willCheckPurchases:(int)count;
-(void)paymentDidCompleteWithId:(NSString*)inAppId;
-(void)paymentDidFailWithId:(NSString*)inAppId;
-(void)restorationDidCompleteWithNewIds:(NSArray*)purchaseIds;
-(void)restorationDidFailWithNewIds:(NSArray*)purchaseIds;
@end


@interface STStoreKit : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,assign,readwrite) NSObject<StoreManagerDelegate> *delegate;

- (BOOL)isItemPurchased:(NSString*)featureId;
+ (STStoreKit*) getInstance;
- (void)buyFeature:(NSString*)featureId;
- (void)restorePayments;

@end
