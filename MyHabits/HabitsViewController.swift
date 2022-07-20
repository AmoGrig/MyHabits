//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by ARAM on 16.07.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        navigationItem.rightBarButtonItem?.tintColor = .myPurple
    }
    
    @objc func addButton() {
        
    }
}
