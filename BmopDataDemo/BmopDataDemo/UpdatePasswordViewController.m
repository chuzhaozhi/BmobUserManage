//
//  UpdatePasswordViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/15.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;
@property (nonatomic,strong)  UITextField *passwordTextField;
@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码操作";
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入旧密码";
    [self.view addSubview:_nameTextField];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 200, 44)];
    _passwordTextField.textColor = [UIColor blackColor];
    _passwordTextField.placeholder = @"请输入新密码";
    [self.view addSubview:_passwordTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"修 改" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    BmobUser *user = [BmobUser currentUser];
    [user updateCurrentUserPasswordWithOldPassword:self.nameTextField.text newPassword:self.passwordTextField.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
               [self showResultWithLoginInfo:user.username];
          
        } else {
            NSLog(@"change password error:%@",error);
             [self showResultInfo:@"修改失败，查看可控制台消息"];
        }
    }];
    
   
}
-(void)showResultWithLoginInfo:(NSString *)result{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，即将做登录操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //用新密码登录
        [BmobUser loginInbackgroundWithAccount:result andPassword:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
            if (error) {
                NSLog(@"login error:%@",error);
                [self showResultInfo:@"登录失败，查看可控制台消息"];
                
            } else {
                
                
                NSLog(@"user:%@",user);
                NSString *result = [NSString stringWithFormat:@"登录成功\n用户名:%@\n用户ID:%@\n",user.username,user.objectId];
                [self showResultInfo:result];
            }
        }];
    }];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
