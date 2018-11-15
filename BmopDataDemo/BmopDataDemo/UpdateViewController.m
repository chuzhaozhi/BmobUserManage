//
//  UpdateViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/14.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"更新用户操作";
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入姓名";
    [self.view addSubview:_nameTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"更 新" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    BmobUser *bUser = [BmobUser currentUser];
    
    if (bUser) {
        [bUser setObject:self.nameTextField.text forKey:@"username"];
        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self showResultInfo:@"更新用户成功，去查看当前用户信息吧"];
            }else{
                NSLog(@"error %@",[error description]);
                [self showResultInfo:@"更新用户失败，控制台查看信息"];
            }
        }];
    }else{
         [self showResultInfo:@"当前未登录"];
    }
   
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
