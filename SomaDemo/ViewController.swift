//
//  ViewController.swift
//  SomaDemo
//
//  Created by Calvin Chang on 2018/9/19.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import Soma

class ViewController: UIViewController {

    fileprivate var socketControllable: SomaControllable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let emitInfo = SocketEmitInfo()
        let event = SocketEvent()

        socketControllable = demoSoket.connect(.message(emitInfo, event))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketControllable?.destory()
    }
}

