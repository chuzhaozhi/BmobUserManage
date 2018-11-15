//
//  ReggisterViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/14.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;
@property (nonatomic,strong)  UITextField *passwordTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册操作";
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入姓名";
    [self.view addSubview:_nameTextField];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 200, 44)];
    _passwordTextField.textColor = [UIColor blackColor];
    _passwordTextField.placeholder = @"请输入密码";
    [self.view addSubview:_passwordTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.nameTextField.text];
    [bUser setPassword:self.passwordTextField.text];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
            NSString *result = [NSString stringWithFormat:@"注册成功\n用户名:%@\n密码:%@\n去试试登录吧",self.nameTextField.text,self.passwordTextField.text];
            [self showResultInfo:result];
        } else {
            NSLog(@"%@",error);
            [self showResultInfo:@"注册失败，查看控制台信息"];

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
