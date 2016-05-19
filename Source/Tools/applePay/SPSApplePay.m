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
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa];
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
        applePayRequest.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV;
        
        // applePayRequest.requiredBillingAddressFields = PKAddressFieldEmail;
        //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
        applePayRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
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



// 交易完成的回调
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"交易完成");
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// 确认交易的回调
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    PKPaymentToken *payToken = payment.token;
    //支付凭据，发给服务端进行验证支付是否真实有效
    PKContact *billingContact = payment.billingContact;            //账单信息
    PKContact *shippingContact = payment.shippingContact;          //送货信息
    PKShippingMethod *shippingMethod = payment.shippingMethod;     //送货方式
    //等待服务器返回结果后再进行系统block调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 最后确认是否支付
        completion(PKPaymentAuthorizationStatusSuccess);
    });
}

// 送货方式的回调
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                 didSelectShippingContact:(PKContact *)contact
                               completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //contact送货地址信息，PKContact类型
    //送货信息选择回调，如果需要根据送货地址调整送货方式，比如普通地区包邮+极速配送，偏远地区只有付费普通配送，进行支付金额重新计算，可以实现该代理，返回给系统：shippingMethods配送方式，summaryItems账单列表，如果不支持该送货信息返回想要的PKPaymentAuthorizationStatus
    
    NSMutableArray * shippingMethods = [NSMutableArray array];
    
    completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, self.summaryItems);
}

//当用户选择了一个新的支付卡的时候会调用。(例如,应用信用卡附加费)
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    
    NSLog(@"%@",paymentMethod);

}

@end
