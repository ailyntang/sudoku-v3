//
//  ViewController.swift
//  sudoku-v3
//
//  Created by Ai-Lyn Tang on 8/6/20.
//  Copyright © 2020 Ai-Lyn Tang. All rights reserved.
//

import UIKit
import Vision
import VisionKit

final class ViewController: UIViewController {

    // MARK: Properties
    
    private lazy var titleLabel = UILabel()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Upload screenshot", for: .normal)
//        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "HEEELLLOO"
        
        setupConstraints()
    }
    
    // MARK: Private
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.padding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.padding).isActive = true
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.padding).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.padding).isActive = true
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        print("button tapped")
        guard VNDocumentCameraViewController.isSupported else {
            print("vkit not supported")
            return
        }

        print("vision kit is supported")
        let controller = VNDocumentCameraViewController()
        controller.delegate = self

        present(controller, animated: true)
    }
}

// MARK: VisionKit delegate

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        print("save scan")
        dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
}

private enum Layout {
    static let padding: CGFloat = 24.0
}
