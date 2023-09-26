//
//  CompactViewController.swift
//  tesetInstall MessagesExtension
//
//  Created by Serhii Molodets on 25.09.2023.
//

import UIKit

protocol CompactViewControllerDelegate: AnyObject {
    func didSelectRecord()
}


class CompactViewController: UIViewController {
    var delegate: CompactViewControllerDelegate?
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    @IBAction func didSelectRecord(_ sender: Any) {
        delegate?.didSelectRecord()
    }
    
}
