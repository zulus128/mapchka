//
//  STStoreKit.m
//  7Steps
//
//  Created by Oleg Kokhtenko on 2/18/13.
//  Copyright (c) 2013 Oleg Kokhtenko. All rights reserved.
//

#import "STStoreKit.h"
#import "ASIFormDataRequest.h"


@interface STStoreKit()
@property (nonatomic, strong) SKProductsRequest *curRequest;
@property (nonatomic, strong) NSString *curProductId;
@property (nonatomic, strong) SKPayment *curPayment;
@property (nonatomic, strong) NSMutableArray *restoredPurchaseIds,*uncheckedTransactions;
@property (nonatomic) BOOL hasObserver;

@end

static STStoreKit *storeManagerInstance;
@implementation STStoreKit

- (id)init{
    if (self = [super init]) {
		storeManagerInstance=self;
    }
    return self;
}


+(STStoreKit*)getInstance
{
    if(!storeManagerInstance)
        [STStoreKit new];
	return storeManagerInstance;
}

- (void)addTransactionObserver{
    if(self.hasObserver)
        return;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.hasObserver = YES;
}

- (BOOL)isItemPurchased:(NSString*)featureId{
    return YES;
#ifdef DEBUG
    return YES;
#endif
    return [[NSUserDefaults standardUserDefaults] boolForKey:featureId];
    
}

-(void)buyFeature:(NSString*)featureId
{
    [self addTransactionObserver];
	self.curProductId=featureId;
	if (![SKPaymentQueue canMakePayments])
	{
		[self transactionFinishedWithSuccess:false];
		return;
	}
	if(!featureId || [featureId isEqualToString:@""])
	{
		NSLog(@"StoreManager: attempt to buy %@ productId",featureId?@"empty":@"nil");
		[self showNotCompletedMessage];
		[self transactionFinishedWithSuccess:false];
		return;
	}
	self.curRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:featureId]];
	self.curRequest.delegate = self;
	[self.curRequest start];
}

-(void)showNotCompletedMessage
{
	[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"purchaseNotFinished", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
}



#pragma mark - Payments

-(void)transactionFinishedWithSuccess:(bool)success
{
    
	SEL action=success?@selector(paymentDidCompleteWithId:):@selector(paymentDidFailWithId:);
	if (self.delegate && [self.delegate respondsToSelector:action])
		[self.delegate performSelector:action withObject:self.curProductId afterDelay:0];
    if(success){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.curProductId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	self.curRequest=nil;
	self.curProductId=nil;
}


-(void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	if (!response)
	{
		NSLog(@"StoreManager: SKProductsResponse received with response==nil; ignoring response");
		return;
	}
	if (request!=self.curRequest)
	{
		NSLog(@"StoreManager: SKProductsResponse received for request==%@, while curRequest==%@; ignoring response",request,self.curRequest);
		return;
	}
	NSArray *products=response.products;
	SKProduct *myProduct=nil;
	if (products)
	{
		//ищем нужный id в products
		int i;
		SKProduct *product;
		for (i=products.count-1; i>=0 && ![((product=[products objectAtIndex:i])).productIdentifier isEqualToString:self.curProductId]; i--);
		if (i>=0)
			myProduct=product;
	}
	self.curRequest=nil;
	if (myProduct)
	{
		NSLog(@"StoreManager: SKProductResponse received correctly for productId==%@, buying product...",self.curProductId);
		SKPayment *payment=[SKPayment paymentWithProduct:myProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		NSLog(@"StoreManager: SKProductResponce received without curProductId in products; payment is failed for curProductId==%@",self.curProductId);
		[self showNotCompletedMessage];
		[self transactionFinishedWithSuccess:false];
	}
}

-(void)restorationFinishedWithSuccess:(bool)success
{
    if(self.uncheckedTransactions.count > 0)
        return;
	SEL action=success?@selector(restorationDidCompleteWithNewIds:):@selector(restorationDidFailWithNewIds:);
	if (self.delegate && [self.delegate respondsToSelector:action])
		[self.delegate performSelector:action withObject:self.restoredPurchaseIds afterDelay:0];
	self.restoredPurchaseIds=nil;
	self.uncheckedTransactions=nil;
}


-(void)restorePayments
{
    [self addTransactionObserver];
	self.restoredPurchaseIds=[NSMutableArray array];
	self.uncheckedTransactions=[NSMutableArray array];
	if (![SKPaymentQueue canMakePayments])
	{
		[self restorationFinishedWithSuccess:NO];
		return;
	}
//	[self.uncheckedTransactions addObject:[NSNull null]]; //фейковый объект, который не даст очереди транзакций опустеть
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
//
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [self restorationFinishedWithSuccess:NO];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
#ifdef DEBUG
		NSString *stateStr = nil;
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchasing:
				stateStr=@"purchasing";
				break;
			case SKPaymentTransactionStatePurchased:
				stateStr=@"purchased";
				break;
			case SKPaymentTransactionStateFailed:
				stateStr=@"failed";
				break;
			case SKPaymentTransactionStateRestored:
				stateStr=@"restored";
				break;
		}
		NSLog(@"StoreManager: transactionUpdate received with productId==%@, state==%@",transaction.payment.productIdentifier,stateStr);
#endif
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchasing:
				break;
				
			case SKPaymentTransactionStatePurchased:
			{
				NSLog(@"StoreManager: Product with id==%@ purchased, verifying...",transaction.payment.productIdentifier);
				[self sendRequestForTransaction: transaction isRestore:NO];
				break;
			}
				
			case SKPaymentTransactionStateFailed:
				NSLog(@"Transaction==%@ with receipt==%@ failed with error==%@",transaction,
					  [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding],transaction.error);
				if (transaction.error.code!=SKErrorPaymentCancelled)
					[self showNotCompletedMessage];
                
				[self transactionFinishedWithSuccess:false];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
			{
				[self.uncheckedTransactions addObject:transaction];
				[self sendRequestForTransaction: transaction isRestore:YES];
				break;
			}
				
			default:
				break;
		}
	}
    if(self.uncheckedTransactions.count > 0){
        if([self.delegate respondsToSelector:@selector(willCheckPurchases:)])
            [self.delegate willCheckPurchases:self.uncheckedTransactions.count];
    }
}

-(void)sendRequestForTransaction:(SKPaymentTransaction*)transaction isRestore:(BOOL)isRestore{
	NSString *url;
	
#ifdef USE_SANDBOX
	url = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
	url = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	NSString *jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    NSMutableData *data = [[NSJSONSerialization dataWithJSONObject:@{@"receipt-data":jsonObjectString}
                                                           options:0
                                                             error:nil] mutableCopy];
	[request setPostBody:data];
	request.delegate = self;
	request.didFinishSelector = @selector(transactionVerified:);
	request.didFailSelector = @selector(transactionCantBeVerified:);
	
	request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction",
						transaction.payment.productIdentifier, @"productIdentifier",
                        [NSNumber numberWithBool: isRestore], @"isRestore", nil];
    request.queuePriority = NSOperationQueuePriorityVeryHigh;
	[request startAsynchronous];
}



-(void)transactionVerified:(ASIHTTPRequest*)request{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:0 error:nil];
    int status = [[dict objectForKey:@"status"] intValue];
    BOOL success = status == 0;
    SKPaymentTransaction *transaction=[request.userInfo objectForKey:@"transaction"];
    [self.uncheckedTransactions removeObject:transaction];
    if(success){
        bool isRestore=[[request.userInfo objectForKey:@"isRestore"] boolValue];
        if (isRestore)
        {
            if (success){
                [self restorationFinishedWithSuccess:YES];
                if([self.delegate respondsToSelector:@selector(restoredInApp:)])
                    [self.delegate restoredInApp:transaction.payment.productIdentifier];
            }
        }
        else
            [self transactionFinishedWithSuccess:success];
    }else{
        [self showNotCompletedMessage];
        
        [self transactionFinishedWithSuccess:success];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)transactionCantBeVerified:(ASIHTTPRequest*)request{
    [self showNotCompletedMessage];
    SKPaymentTransaction *transaction=[request.userInfo objectForKey:@"transaction"];
    [self.uncheckedTransactions removeObject:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
	static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
	uint8_t *output = (uint8_t *)data.mutableBytes;
	for (NSInteger i = 0; i < length; i += 3) {
		NSInteger value = 0;
		for (NSInteger j = i; j < (i + 3); j++) {
			value <<= 8;
			
			if (j < length) {
				value |= (0xFF & input[j]);
			}
		}
		NSInteger index = (i / 3) * 4;
		output[index + 0] =						table[(value >> 18) & 0x3F];
		output[index + 1] =						table[(value >> 12) & 0x3F];
		output[index + 2] = (i + 1) < length ?	table[(value >> 6)  & 0x3F] : '=';
		output[index + 3] = (i + 2) < length ?	table[(value >> 0)  & 0x3F] : '=';
	}
	return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


@end
