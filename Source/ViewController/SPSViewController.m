//
//  SPSViewController.m
//  superSet
//
//  Created by yao on 16/5/19.
//  Copyright © 2016年 yao. All rights reserved.
//

#import "SPSViewController.h"
#import "SPSApplePay.h"

@interface SPSViewController ()

@end

@implementation SPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[SPSApplePay alloc] init] startApplePayWithController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
