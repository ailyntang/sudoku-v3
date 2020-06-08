//
//  ViewController.swift
//  sudoku-v3
//
//  Created by Ai-Lyn Tang on 8/6/20.
//  Copyright © 2020 Ai-Lyn Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var titleLabel = UILabel()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Upload screenshot", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleLabel.text = "HEEELLLOO"
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        print("pressed")
    }
}

