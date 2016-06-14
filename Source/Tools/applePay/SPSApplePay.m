//
//  SPSApplePay.m
//  superset
//
//  Created by yao on 16/4/21.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "SPSApplePay.h"
#import <PassKit/PassKit.h>

@interface SPSApplePay () <PKPaymentAuthorizationViewControllerDelegate>
// 账单的列表
@property (strong , nonatomic) NSMutableArray * summaryItems;
// 支付时的controller
@property (strong , nonatomic) UIViewController * applePayController;
@end


@implementation SPSApplePay

- (void)startApplePayWithController:(UIViewController *)controller{
    
    if (![PKPaymentAuthorizationViewController class]) {
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    //PKPaymentNetworkChinaUnionPay 中国银联 是9.2新增加
    
    
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return;
    }
    
    // 判断设备是否支持 applePay
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest * applePayRequest = [[PKPaymentRequest alloc] init];
        // Merchant ID
        // ID 的注册方法  http://www.jianshu.com/p/2e5e45afc246
        applePayRequest.merchantIdentifier = @"merchant.com.yao.rytong";
        // 国家代码
        applePayRequest.countryCode = @"CH";
        // 货币的代码
        applePayRequest.currencyCode = @"CNY";
        // 支付的系统
        applePayRequest.supportedNetworks = supportedNetworks;
        // 设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧。
        applePayRequest.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
        
        // applePayRequest.requiredBillingAddressFields = PKAddressFieldEmail;
        //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
//        applePayRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
        //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
        
        //设置两种配送方式
        PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
        freeShipping.identifier = @"freeshipping";
        freeShipping.detail = @"6-8 天 送达";
        
        PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
        expressShipping.identifier = @"expressshipping";
        expressShipping.detail = @"2-3 小时 送达";
        
        applePayRequest.shippingMethods = @[freeShipping, expressShipping];
        
        
        NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];   //12.75
        PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:subtotalAmount];
        
        NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"-12.74"];      //-12.74
        PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"优惠折扣" amount:discountAmount];
        
        NSDecimalNumber *methodsAmount = [NSDecimalNumber zero];
        PKPaymentSummaryItem *methods = [PKPaymentSummaryItem summaryItemWithLabel:@"包邮" amount:methodsAmount];
        
        NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
        totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
        totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
        totalAmount = [totalAmount decimalNumberByAdding:methodsAmount];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Yasin" amount:totalAmount];  //最后这个是支付给谁。
        
        self.summaryItems = [NSMutableArray arrayWithArray:@[subtotal, discount, methods, total]];
        //summaryItems为账单列表，类型是 NSMutableArray，这里#pragma mark - delegate 设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
        applePayRequest.paymentSummaryItems = self.summaryItems;
        
        PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:applePayRequest];
        view.delegate = self;
        
        self.applePayController = controller;
        [controller presentViewController:view animated:YES completion:nil];
    }
}



-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingContact");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingMethod");
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"paymentAuthorizationViewControllerWillAuthorizePayment");
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSLog(@"did authorize payment token: %@, %@", payment.token, payment.token.transactionIdentifier);
    
    completion(PKPaymentAuthorizationStatusSuccess);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"finish");
    [controller dismissViewControllerAnimated:controller completion:NULL];
}

@end
