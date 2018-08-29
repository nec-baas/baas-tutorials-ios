//
//  TodoListViewController.swift
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let BUCKET_NAME = "TodoTutorial1";
    
    var indicatorView: UIActivityIndicatorView? = nil
    
    var todos: [NBObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
        reloadTodos(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Todo 一覧を取得する
    @IBAction func reloadTodos(_ sender: UIButton?) {

        // バケット取得
        let bucket = NBObjectBucket(bucketName: BUCKET_NAME)
        
        // クエリ生成
        let query = NBQuery()
        query.setSortOrder(key: "updatedAt", isAscend: true)

        // クエリ実行
        bucket.queryInBackground(query: query) { objects, count, error in
            self.hideIndicator()
            guard error == nil else {
                print("query error: \(error!)")
                return
            }
            self.todos = objects!
            self.tableView.reloadData()
        }
        showIndicator()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell")!
        
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.object(forKey: "description") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // 削除可能
    }
    
    /**
    * 削除処理
    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let obj = todos[indexPath.row]

    
        // オブジェクト削除
        obj.deleteInBackground() { error in
            self.hideIndicator()
            guard error == nil else {
                print("Delete failed: \(error!)")
                return
            }
            self.reloadTodos(nil)
        }
        showIndicator()
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // pragma mark - Add Todo
    
    @IBAction func firstViewReturnActionForSegue(_ segue: UIStoryboardSegue) {
        if (segue.identifier == "done") {
            let vc = segue.source as! TodoEditViewController
            let todo = vc.todoText
            addTodo(todo)
        }
    }
    
    /**
    * Todo の追加処理
    */
    func addTodo(_ description: String) {
        // オブジェクト作成
        let todo = NBObject(bucketName: BUCKET_NAME)
    
        // オブジェクトに値を設定
        todo.setObject(description, forKey: "description")
    
        // オブジェクト保存
        showIndicator()
        
        todo.saveInBackground() { objects, count, error in
            self.hideIndicator()
            guard error == nil else {
                print("save error : \(error!)")
                return
            }
            self.reloadTodos(nil)
        }
    }

    /**
     * IndicatorView を表示する
     */
    func showIndicator() {
        if (indicatorView != nil) {
            return
        }
        
        let v = UIActivityIndicatorView(frame:
            CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
        
        v.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        v.backgroundColor = UIColor(white:0.0, alpha:0.3)
        v.contentMode = UIViewContentMode.center;
        v.autoresizingMask =
                [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]

        self.view.addSubview(v)
        v.startAnimating()
        
        self.indicatorView = v
    }
    
    /**
     * IndicatorView を消す
     */
    func hideIndicator() {
        if (indicatorView == nil) {
            return
        }

        indicatorView!.stopAnimating()
        indicatorView!.removeFromSuperview()
        indicatorView = nil;
    }
}

