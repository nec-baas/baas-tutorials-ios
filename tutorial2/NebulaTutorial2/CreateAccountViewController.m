//
//  CreateAccountViewController.m
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import "nebulaIosSdk/Nebula.h"

#import "CreateAccountViewController.h"
#import "LoginViewController.h"

@interface CreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationField;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * アカウントの作成処理
 */
- (IBAction)createAccount:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0 || email.length == 0) {
        [LoginViewController showAlert:@"username / email は必須です" withTitle:nil];
        return;
    }

    if (![password isEqualToString:self.passwordConfirmationField.text]) {
        [LoginViewController showAlert:@"パスワードが一致しません" withTitle:nil];
        return;
    }

    // 登録処理
    NBUser *user = [NBUser new];
    user.username = username;
    user.email = email;
    [user signUpInBackgroundWithPassword:password block:^(NBUser *user, NSError *error) {
        if (!error) {
            [LoginViewController showAlert:@"正常にアカウント登録しました" withTitle:@"Success"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [LoginViewController showError:error];
        }
    }];
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
