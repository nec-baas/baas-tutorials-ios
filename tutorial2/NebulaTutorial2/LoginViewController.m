//
//  LoginViewController.m
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import <NecBaas/Nebula.h>

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

+ (void)logout:(UIViewController *)viewController
{
    if ([NBUser loggedIn]) {
        [NBUser logOutInBackgroundWithBlock:^(NBUser *user, NSError *error) {
            [self loginCheck:viewController];
        }];
    }
}

+ (BOOL)loginCheck:(UIViewController *)viewController
{
    // ログイン状態チェック
    if ([NBUser loggedIn]) {
        return YES;
    }
    
    // 未ログイン状態の場合は、ログイン画面を表示させる
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:nil];
    id firstViewControler = [storyboard instantiateInitialViewController];
    [viewController presentViewController:firstViewControler animated:NO completion:nil];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * ログイン処理
 */
- (IBAction)doLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *email = nil;
    
    NSRange range = [username rangeOfString:@"@"];
    if (range.length != 0) {
        email = username;
        username = nil;
    }
    
    // ログイン処理実行
    [NBUser logInInBackgroundWithUsername:username email:email password:password block:^(NBUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login success");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Login error : %@", error);
            [self.class showError:error];
            self.usernameField.text = @"";
            self.passwordField.text = @"";
        }
    }];
}

+ (void)showError:(NSError *)error
{
    [self.class showAlert:error.localizedDescription withTitle:@"Error"];
}

+ (void)showAlert:(NSString *)text withTitle:(NSString *)title
{
    if (title == nil) {
        title = @"Error";
    }
    
    UIAlertView *view = [[UIAlertView alloc]
                         initWithTitle:title
                         message:text
                         delegate:self
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
    [view show];
}

#pragma mark - Navigation

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    // do nothing
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
