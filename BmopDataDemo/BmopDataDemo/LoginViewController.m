//
//  LoginViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/14.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;
@property (nonatomic,strong)  UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录操作";

    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入姓名";
    [self.view addSubview:_nameTextField];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 200, 44)];
    _passwordTextField.textColor = [UIColor blackColor];
    _passwordTextField.placeholder = @"请输入密码";
    [self.view addSubview:_passwordTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"登 录" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{

    //登录方式一
//    [BmobUser loginWithUsernameInBackground:self.nameTextField.text password:self.passwordTextField.text];
    //登录方式二
    [BmobUser loginWithUsernameInBackground:self.nameTextField.text password:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSString *result = [NSString stringWithFormat:@"登录成功\n用户名:%@\n密码:%@\n去试试获取当前用户吧",user.username,user.password];
                        [self showResultInfo:result];
        }else{
            NSLog(@"%@",error);
              [self showResultInfo:@"登录失败，查看可控制台消息"];
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
