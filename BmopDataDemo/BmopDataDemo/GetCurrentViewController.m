//
//  GetCurrentViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/14.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "GetCurrentViewController.h"

@interface GetCurrentViewController ()

@end

@implementation GetCurrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"获取当前用户";
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"获取当前用户" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    BmobUser *user = [BmobUser currentUser];
    if (user) {
        //进行操作
        NSString *result = [NSString stringWithFormat:@"当前\n用户名:%@\n用户ID:%@\n去试试更新用户吧",user.username,user.objectId];
        [self showResultInfo:result];
    }else{
        //对象为空时，可打开用户注册界面
        [self showResultInfo:@"当前没有用户"];
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
