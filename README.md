# BmobUserManage iOS独立开发者使用Bmob第三方后台服务之用户管理
Bmob后台云用户信息管理模块，注册、登录、修改密码、找回密码等操作
![](https://upload-images.jianshu.io/upload_images/4905848-460fe21f4b32d1d4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 一、属性
BmobUser除了从BmobObject继承的属性外，还有几个特定的属性：

 - username: 用户的用户名（必需）。
 - password: 用户的密码（必需）。
 - email: 用户的电子邮件地址（可选）。
 
 BmobUser自动处理用户账户管理所需的功能。
```Objective-C
-(void)setUsername:(NSString *)username;//用户名，必需
-(void)setPassword:(NSString*)password;//密码，必需
-(void)setEmail:(NSString *)email;//设置邮箱
-(void)setObject:(id)obj forKey:(id)key;//设置某个属性的值
-(id)objectForKey:(id)key;//得到某个属性的值
```
## 二、注册
应用很常见的一个功能就是，注册用户，使用BmobUser注册用户也不复杂，如下的例子所示：
```Objective-C
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
```
![](https://upload-images.jianshu.io/upload_images/4905848-48f818b2c3f4c855.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>**注意点**：
 - 有些时候你可能需要在用户注册时发送一封邮件，以确认用户邮箱的真实性。这时，你只需要登录自己的应用管理后台，在应用设置->邮件设置（下图）中把“邮箱验证”功能打开，Bmob云后端就会在用户注册时自动发动一封验证给用户。
![](https://upload-images.jianshu.io/upload_images/4905848-574b07e694f3d13e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 - username字段是大小写敏感的字段，如果你希望应用的用户名不区分大小写，请在注册和登录时进行大小写的统一转换。
 
 ## 三、登录
 当用户注册成功后，需要让他们以后能够登录到他们的账户使用应用。要做到这点可以使用
 `方法一`
 ```Objective-C

[BmobUser loginWithUsernameInBackground:self.nameTextField.text password:self.passwordTextField.text];

 ```
 `方法二`

```Objective-C
    [BmobUser loginWithUsernameInBackground:self.nameTextField.text password:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSString *result = [NSString stringWithFormat:@"登录成功\n用户名:%@\n密码:%@\n去试试获取当前用户吧",user.username,user.password];
                        [self showResultInfo:result];
        }else{
            NSLog(@"%@",error);
              [self showResultInfo:@"登录失败，查看可控制台消息"];
        }
    }];
```

> 可以看到Bmob里面提供了很多的方法，根据需要调用

![](https://upload-images.jianshu.io/upload_images/4905848-d277517e93296a66.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/4905848-bc78c4bac6e6e210.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 四、获取当前用户
每次你登录成功，都会在本地磁盘中有一个缓存的用户对象作为当前用户，可以获取这个缓存的用户对象来进行登录：
```Objective-C
 BmobUser *user = [BmobUser currentUser];
    if (user) {
        //进行操作
        NSString *result = [NSString stringWithFormat:@"登录成功\n用户名:%@\n密码:%@\n去试试更新用户吧",user.username,user.password];
        [self showResultInfo:result];
    }else{
        //对象为空时，可打开用户注册界面
        [self showResultInfo:@"当前没有用户"];
    }
```
当然，你也可以用如下的方法清除缓存用户对象：
```Objective-C
[BmobUser logout];
```
![](https://upload-images.jianshu.io/upload_images/4905848-646494f4b64f2961.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 五、更新用户
当用户登录成功后，在本地有个缓存的用户对象，如果开发者希望更改当前用户的某个属性可按如下代码操作:
```Objective-C
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
```
一般来说，使用当前用户对象来进行资料更新可能会遇到一个问题。如果当前用户上次登录的时间距离当前时间过长，存放在本地的Token就有可能会过期，导致用户更新资料失败，这是需要重新登录，登录成功后才能更新资料。

>  在更新用户信息时，如果用户邮箱有变更并且在管理后台打开了邮箱验证选项的话，Bmob云后端同样会自动发动一封邮件验证信息给用户。

![](https://upload-images.jianshu.io/upload_images/4905848-8cc6856664ac769b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 六、查询用户
查询用户和查询普通对象一样，只需指定BmobUser类即可，如下：
```Objective - C
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
```
在Bmob后台查看用户表
![](https://upload-images.jianshu.io/upload_images/4905848-8f211f3973c23449.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 七、修改密码
使用旧密码来重置新密码的接口，示例如下：
`修改`
```Objective-C
 BmobUser *user = [BmobUser currentUser];
    [user updateCurrentUserPasswordWithOldPassword:self.nameTextField.text newPassword:self.passwordTextField.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
               [self showResultWithLoginInfo:user.username];
          
        } else {
            NSLog(@"change password error:%@",error);
             [self showResultInfo:@"修改失败，查看可控制台消息"];
        }
    }];
```
`修改成功之后登录`
```Objective-C
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
```

![](https://upload-images.jianshu.io/upload_images/4905848-9c5cae8a066b23b9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 八、邮箱找回(修改)密码
> **前提是在注册操作的时候有添加过邮箱**

一旦你引入了一个密码系统，那么肯定会有用户忘记密码的情况。对于这种情况，我们提供了一种方法，让用户安全地重置起密码。

重置密码的流程很简单，开发者只需要求用户输入注册的电子邮件地址即可
```Objective-C
  [BmobUser requestPasswordResetInBackgroundWithEmail:self.nameTextField.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self showResultInfo:@"发送成功，请去邮箱内查看邮件"];
        }else{
            NSLog(@"%@",error);
            [self showResultInfo:@"发送失败，请查看控制台信息"];
        }
        
    }];
```
`以下为未开启邮箱验证和注册时未绑定邮箱的`
![](https://upload-images.jianshu.io/upload_images/4905848-5ff77437e684881e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

密码重置流程如下：
 1. 用户输入他们的电子邮件，请求重置自己的密码。
 2. Bmob向他们的邮箱发送一封包含特殊的密码重置连接的电子邮件。
 3. 用户根据向导点击重置密码连接，打开一个特殊的Bmob页面，根据提示，他们可以输入一个新的密码。
 4. 用户的密码已被重置为新输入的密码。
 
 
 ## 九、总结
 ### 注意点：
 > 1. 需要在Bmob后台开启邮箱认证
 > 2. Bmob后台User表里可添加字段来完善用户信息
 > 3. 通过邮箱操作密码等信息的需要在注册是要求用户验证邮箱，否则操作失败

Bmob接入具体操作可查看上一篇文章
[iOS独立开发者使用Bmob第三方后台服务初探](https://www.jianshu.com/p/a9589877b5ad)
本文同步至[个人博客](http://chuzhaozhi.cn)
[代码传送门](https://github.com/chuzhaozhi/BmobUserManage)，欢迎star,感兴趣的可以留言一起探讨。
搜索公众号`JacerooChu`或扫描下方二维码一起讨论和获取更多信息。
![swap.png](https://upload-images.jianshu.io/upload_images/4905848-4032051f9cc2352f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
