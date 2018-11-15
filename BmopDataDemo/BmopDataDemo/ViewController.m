//
//  ViewController.m
//  BmopDataDemo
//
//  Created by chuzhaozhi on 2018/11/13.
//  Copyright © 2018 JackerooChu. All rights reserved.
//



#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *showInfo;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bmob后端云基本操作";
    [self initTableView];
    self.dataSource =@[@"注册",@"登录",@"获取当前用户",@"更新用户",@"查询用户",@"修改密码",@"找回密码"];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH-NaviH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }
    _tableView.showsVerticalScrollIndicator = NO;
    /// 自动关闭估算高度，不想估算那个，就设置那个即可
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier =@"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }

      cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",indexPath);
   if(indexPath.row==0) {
       [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
   }else if (indexPath.row==1){
       [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
   }else if (indexPath.row==2){
       [self.navigationController pushViewController:[[GetCurrentViewController alloc] init] animated:YES];
   }else if (indexPath.row==3){
       [self.navigationController pushViewController:[[UpdateViewController alloc] init] animated:YES];
   }else if (indexPath.row==4){
       [self.navigationController pushViewController:[[SearchViewController alloc] init] animated:YES];
   }else if (indexPath.row==5){
       [self.navigationController pushViewController:[[UpdatePasswordViewController alloc] init]animated:YES];
   }else {
      [self.navigationController pushViewController:[[GetBackPasswordViewController alloc] init] animated:YES];
   }
}
#pragma mark - 查删改增操作
-(void)takeDataBase{
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 44)];
    [add setTitle:@"add" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [add addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 44)];
    [search setTitle:@"search" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
    [delete setTitle:@"delete" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
    self.showInfo = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 200, 100)];
    self.showInfo.textColor = [UIColor blackColor];
    self.showInfo.text =@"显示信息";
    [self.view addSubview:self.showInfo];
}
#pragma mark - 添加一条数据
-(void)addAction:(UIButton *)add{
    BmobObject *gameScore = [BmobObject objectWithClassName:@"Customer"];
    [gameScore setObject:@"小明" forKey:@"UserName"];
    [gameScore setObject:@"1993-07-22" forKey:@"UserBirthDay"];
    [gameScore setObject:@YES forKey:@"Sex"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        if (isSuccessful) {
            self.userId = gameScore.objectId;
            self.showInfo.text =@"添加成功";
        }else{
            self.showInfo.text =@"添加失败";
        }
    }];
}
#pragma mark - 查询一条数据
-(void)searchAction:(UIButton *)search{
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Customer"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:self.userId block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *playerName = [object objectForKey:@"UserName"];
                BOOL cheatMode = [[object objectForKey:@"cheatMode"] boolValue];
                NSLog(@"%@----%i",playerName,cheatMode);
                 self.showInfo.text =playerName;
            }
        }
    }];
}
#pragma mark - 删除一条数据
-(void)deleteAction:(UIButton *)delete{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Customer"];
    [bquery getObjectInBackgroundWithId:self.userId block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
                self.showInfo.text =@"删除成功";
            }
        }
    }];
}


@end
