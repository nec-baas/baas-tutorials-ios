//
//  LoginViewController.h
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

/**
 * ログインチェックを行う。未ログイン状態の場合はログイン画面を表示する。
 * @param viewController 表示元の View Controller
 * @return ログイン中なら YES、未ログインなら NO
 */
+ (BOOL)loginCheck:(UIViewController *)viewController;

+ (void)logout:(UIViewController *)viewController;

+ (void)showAlert:(NSString *)text withTitle:(NSString *)title;
+ (void)showError:(NSError *)error;

@end
