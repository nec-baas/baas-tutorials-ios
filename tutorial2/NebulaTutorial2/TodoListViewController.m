//
//  ViewController.m
//  NebulaTutorial2
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import "nebulaIosSdk/Nebula.h"

#import "TodoListViewController.h"
#import "TodoEditViewController.h"

#import "LoginViewController.h"

#define BUCKET_NAME @"TodoTutorial2"

@interface TodoListViewController ()
@property(nonatomic) NSArray *todos;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TodoCell"];
    
    self.todos = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // ログインチェック
    if ([LoginViewController loginCheck:self]) {
        // ログイン状態であれば、Todo をリロードする
        if (self.todos == nil) {
            [self reloadTodos:nil];
        }
    }
}

// ログアウト
- (IBAction)logout:(id)sender {
    [LoginViewController logout:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Todo 一覧を取得する
- (IBAction)reloadTodos:(id)sender {
    NBObjectBucket *bucket = [[NBObjectBucket alloc] initWithBucketName:BUCKET_NAME];

    NBQuery *query = [NBQuery new];
    [query setSortOrderWithKey:@"updatedAt" isAscend:YES];
    
    [bucket queryInBackgroundWithQuery:query block:^(NSArray *objects, NSUInteger count, NSError *error) {
        if (!error) {
            self.todos = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"query error: %@", error);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todos == nil ? 0 : self.todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TodoCell"];

    NBObject *todo = (self.todos)[indexPath.row];

    cell.textLabel.text = todo[@"description"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; // 削除可能
}

/**
 * 削除処理
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBObject *obj = (self.todos)[indexPath.row];

    // オブジェクト削除
    [obj deleteInBackgroundWithBlock:^(NSError *error) {
        if (!error) {
            [self reloadTodos:nil];
        } else {
            NSLog(@"Delete failed: %@", error);
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Add Todo

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"done"]) {
        TodoEditViewController *vc = segue.sourceViewController;
        NSString *todo = vc.todoText;
        [self addTodo:todo];
    }
}

/**
 * Todo の追加処理
 */
- (void)addTodo:(NSString *)description {
    // オブジェクト作成
    NBObject *todo = [NBObject objectWithBucketName:BUCKET_NAME];

    // オブジェクトに値を設定
    todo[@"description"] = description;

    // オブジェクト保存
    [todo saveInBackgroundWithBlock:^(NSArray *objects, NSUInteger count, NSError *error) {
        if (!error) {
            [self reloadTodos:nil];
        } else {
            NSLog(@"save error : %@", error);
        }
    }];
}

@end
