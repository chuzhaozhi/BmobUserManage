//
//  SearchViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/14.
//  Copyright © 2018 JackerooChu. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (nonatomic,strong)  UITextField *nameTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查询用户操作";
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 44)];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.placeholder = @"请输入姓名";
    [self.view addSubview:_nameTextField];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [registerButton setTitle:@"查 询" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor blueColor];
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // Do any additional setup after loading the view.
}
-(void)registerAction:(UIButton *)sender{
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"username" equalTo:self.nameTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [self showResultInfo:@"查询出错，查看控制台信息"];

            
        }else{
            if (array.count>0) {
                for (BmobUser *user in array) { //  demo中只有一个用户，所以把显示结果的放在循环内了
                    NSLog(@"objectid %@",user.objectId);
                    NSString *result = [NSString stringWithFormat:@"查询成功\n用户名:%@\n用户id:%@",user.username,user.objectId];
                    [self showResultInfo:result];
                    
                }
            }else{
                 [self showResultInfo:@"没有查询到结果，请修改信息后查询"];
            }
            
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
