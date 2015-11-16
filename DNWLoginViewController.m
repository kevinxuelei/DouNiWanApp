//
//  DNWLoginViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-16.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWLoginViewController.h"
#import "MBProgressHUD.h"


@interface DNWLoginViewController (){

    MBProgressHUD * _HUD;
}

@end

@implementation DNWLoginViewController

- (void)dealloc{

    Block_release(_passShareTypeBlock);
    [super dealloc];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"第三方账号登录";
    
    //  添加导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarButtonAction:)] autorelease];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    //添加背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginback"]];
    
    //  添加新浪登录按钮
    UIImageView *sinaImage = [[UIImageView alloc]initWithFrame:CGRectMake(60,280, 40, 40)];
    sinaImage.image = [UIImage imageNamed:@"denglu_xin"];
    sinaImage.layer.cornerRadius = 20.0;
    sinaImage.userInteractionEnabled = YES;
    sinaImage.clipsToBounds = YES;                              //  图片自适应View
    [self.view addSubview:sinaImage];
    
    UIButton *loginSinaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginSinaBtn setTitle:@"微博账号登陆" forState:UIControlStateNormal];
    loginSinaBtn.frame = CGRectMake(60, 350, 200, 30.0);
    [loginSinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginSinaBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [loginSinaBtn addTarget:self action:@selector(loginSinaBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginSinaBtn];
    
    //添加腾讯QQ登录按钮
    UIImageView *qqImage = [[UIImageView alloc]initWithFrame:CGRectMake(60,330, 40, 40)];
    qqImage.image = [UIImage imageNamed:@"denglu_qq"];
    qqImage.layer.cornerRadius = 20.0;
    qqImage.userInteractionEnabled = YES;
    qqImage.clipsToBounds = YES;                              //  图片自适应View
    [self.view addSubview:qqImage];
    
    UIButton *loginQQBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //[loginQQBtn setBackgroundImage:[UIImage imageNamed:@"LoginButton.png"] forState:UIControlStateNormal];
    [loginQQBtn setTitle:@"QQ账号登录" forState:UIControlStateNormal];
    loginQQBtn.frame = CGRectMake(60, 400, 200, 32.0);
    [loginQQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginQQBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [loginQQBtn addTarget:self action:@selector(loginQQBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginQQBtn];


}

#pragma mark - 新浪登录按钮
- (void)loginSinaBtnClickHandler:(id)sender
{
    /**
    * 其整个实现的流程如下所示：
    * 使用ShareSDK中的hasAuthorizedWithType方法来判断用户是否已经登录。如果尚未登录则进入步骤2，否则进入步骤4。
    * 使用ShareSDK中的authWithType方法来对用户进行授权。
    * 授权成功后，调用ShareSDK中的getUserInfoWithType方法来获取用户信息，并将取到的用户信息与服务器中本地帐号信息进行关联。
    * 登录应用主界面。
    * 在注销登录时可以使用ShareSDK中的cancelAuthWithType方法来实现。如果需要重新登录跳转回步骤1重新执行。
    */
    /**
     *需要注意的是这里没有调用authWithType这个方法，而是直接调用了getUserInfoWithType，由于getUserInfoWithType方法中已经包含了是否
      授权的检测，在没有授权时会自动弹出授权界面，因此可以直接使用此方法就能够一步到位取到用户信息了。
     */
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               //  登录成功
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       // 向Parse服务器注册信息
                                       if ([objects count] == 0) {
                                           
                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
                                           [newUser saveInBackground];

                                       }
                                   }];
                                   
                                   [self dismissViewControllerAnimated:YES completion:^{
                                   }];
                               }
                               
                           }];
}

- (void)loginQQBtnClickHandler:(id)sender{

    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               //  登录成功
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       // 向Parse服务器注册信息
                                       if ([objects count] == 0) {
                                           
                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
                                           [newUser saveInBackground];
                                           
                                       }
                                   }];
                                   
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }
                               
                           }];


}



- (void)didClickLeftBarButtonAction:(UIBarButtonItem *)leftButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
