//
//  GetBackPasswordViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/15.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "GetBackPasswordViewController.h"

@interface GetBackPasswordViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;

@end

@implementation GetBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找回密码操作";
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入邮箱地址";
    [self.view addSubview:_nameTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"找回" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    [BmobUser requestPasswordResetInBackgroundWithEmail:self.nameTextField.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self showResultInfo:@"发送成功，请去邮箱内查看邮件"];
        }else{
            NSLog(@"%@",error);
            [self showResultInfo:@"发送失败，请查看控制台信息"];
        }
        
    }];

}
-(void)showResultInfo:(NSString *)result{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
