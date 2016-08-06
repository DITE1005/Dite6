//
//  RootViewController.m
//  weiBoLogin
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RootViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButn;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getUserInfo:(UIButton *)sender {
    ShareType type = 0;
    switch (sender.tag) {
        case 0:
            type = ShareTypeSinaWeibo;
            break;
            
        default:
            break;
    }
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权登陆成功，已获取用户信息");
            NSString *uid = [userInfo uid];
            NSString *nickname = [userInfo nickname];
            NSString *profileImage = [userInfo profileImage];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权登陆成功" message:[NSString stringWithFormat:@"授权登陆成功，用户ID:%@,昵称:%@,头像:%@",uid,nickname,profileImage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            NSLog(@"source:%@",[userInfo sourceData]);
            NSLog(@"uid:%@",[userInfo uid]);
        }else{
            NSLog(@"分享失败，错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权失败,请看错误描述日记" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}
- (IBAction)cancelLoginIn:(UIButton *)sender {
    NSLog(@"退出登陆");
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    
}
- (IBAction)showShareActionSeet:(UIButton *)sender {
    NSLog(@"哈哈");
    // 1.制定分享的内容
    NSString *path = [[NSBundle mainBundle]pathForResource:@"" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:@"Hello,World!" defaultContent:nil image:[ShareSDK imageWithPath:path] title:@"This is title" url:@"http://mob.com" description:@"This is description" mediaType:SSPublishContentMediaTypeImage];
    //2. 调用分享菜单
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
       // 如果分享成功
        if (state == SSResponseStateSuccess) {
            NSLog(@"分享成功");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        //如果分享失败
        if (state == SSResponseStateFail) {
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if (state == SSResponseStateCancel){
            NSLog(@"分享取消");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享取消" message:@"进入了分享取消状态" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
