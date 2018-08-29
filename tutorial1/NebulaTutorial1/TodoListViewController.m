//
//  ViewController.m
//  NebulaTutorial1
//  Copyright (c) 2014-2018, NEC Corporation. All rights reserved.
//

#import "nebulaIosSdk/Nebula.h"

#import "TodoListViewController.h"
#import "TodoEditViewController.h"

#define BUCKET_NAME @"TodoTutorial1"

@interface TodoListViewController ()
{
    UIActivityIndicatorView *indicatorView;
}
@property(nonatomic) NSArray *todos;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TodoCell"];
    indicatorView = nil;
    
    self.todos = @[]; // initial
    [self reloadTodos:nil];
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
        [self hideIndicator];
        if (!error) {
            self.todos = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"query error: %@", error);
        }
    }];
    [self showIndicator];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.todos).count;
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
        [self hideIndicator];
        if (!error) {
            [self reloadTodos:nil];
        } else {
            NSLog(@"Delete failed: %@", error);
        }
    }];
    [self showIndicator];
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
    [self showIndicator];
    [todo saveInBackgroundWithBlock:^(NSArray *objects, NSUInteger count, NSError *error) {
        [self hideIndicator];
        if (!error) {
            [self reloadTodos:nil];
        } else {
            NSLog(@"save error : %@", error);
        }
    }];
}

- (void)showIndicator
{
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        indicatorView.contentMode = UIViewContentModeCenter;
        indicatorView.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:indicatorView];
        [indicatorView startAnimating];
    }
}

- (void)hideIndicator
{
    if (indicatorView != nil) {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
}

@end
