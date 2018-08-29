//
//  TodoEditViewController.swift
//  Copyright (c) 2014-2018, NEC Corporation. All rights reserved.
//

import UIKit

class TodoEditViewController : UIViewController {
    var todoText : String = ""
    
    @IBOutlet weak var textView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.textView!.text = self.todoText;
        self.textView!.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        self.todoText = self.textView!.text;
    }
}
