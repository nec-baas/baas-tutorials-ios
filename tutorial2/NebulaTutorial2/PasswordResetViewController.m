//
//  PasswordResetViewController.m
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import <NecBaas/Nebula.h>

#import "PasswordResetViewController.h"
#import "LoginViewController.h"

@interface PasswordResetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation PasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * パスワードリセット処理
 */
- (IBAction)requestPasswordReset:(id)sender {
    NSString *email = self.emailField.text;
    
    [NBUser resetPasswordInBackgroundWithUsername:nil email:email block:^(NSError *error) {
        if (!error) {
            [LoginViewController showAlert:@"パスワードリセットメールを送信しました" withTitle:@"Success"];
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
