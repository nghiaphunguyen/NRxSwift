//
//  ViewController.swift
//  NRxSwiftDemo
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift
import RxSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func a() -> NKObservable {
        return NKObservable.nk_just(10)
    }
    
    func b() -> NKObservable {
        return NKObservable.nk_error(NSError(domain: "", code: 1, userInfo: nil))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

