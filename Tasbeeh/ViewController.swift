//  ViewController.swift
//  Tasbeeh
//  Created by Ahmed Shaban on 24/07/2022.

import UIKit
class ViewController: UIViewController {
    var zekr = Zekr(text: "", counter: 0)
    // when instantiated, it gets values of azkar[indexPath.row]
    @IBOutlet var viewedZekr: UILabel!
    @IBOutlet var zekrCounter: UILabel!
    @IBOutlet var zekrButton: UIButton!
    @IBAction func makeZekr(_ sender: UIButton) {
        if sender.tag == 0 {
            zekr.counter += 1
            zekrCounter?.text = String(zekr.counter)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        zekrButton.layer.cornerRadius = 40
        viewedZekr.text? = zekr.text
        zekrCounter.text? = String(zekr.counter)
    }
}
