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
    
    private lazy var buttonScan: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Scan", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 7.0
        button.backgroundColor = UIColor.systemIndigo
        button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var ocrTextView: UITextView = {
        let ocrTextView = UITextView()
        ocrTextView.translatesAutoresizingMaskIntoConstraints = false
        ocrTextView.layer.cornerRadius = 7.0
        ocrTextView.layer.borderWidth = 1.0
        ocrTextView.layer.borderColor = UIColor.systemTeal.cgColor
        ocrTextView.font = .systemFont(ofSize: 16.0)
        return ocrTextView
    }()
    
    private lazy var scanImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemIndigo.cgColor
        view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureOCR()
    }
    
    // MARK: Private
    
    private func setupConstraints() {
        
        view.addSubview(buttonScan)
        view.addSubview(ocrTextView)
        view.addSubview(scanImageView)
        
        let padding: CGFloat = 16.0
        NSLayoutConstraint.activate([
        buttonScan.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        buttonScan.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        buttonScan.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        buttonScan.heightAnchor.constraint(equalToConstant: 50),
            
        ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ocrTextView.bottomAnchor.constraint(equalTo: buttonScan.topAnchor, constant: -padding),
        ocrTextView.heightAnchor.constraint(equalToConstant: 200),
            
        scanImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        scanImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
        scanImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        scanImageView.bottomAnchor.constraint(equalTo: ocrTextView.topAnchor, constant: -padding)
        ])
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        guard VNDocumentCameraViewController.isSupported else { return }

        let controller = VNDocumentCameraViewController()
        controller.delegate = self

        present(controller, animated: true)
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        ocrTextView.text = ""
        buttonScan.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }
    
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText += topCandidate.string + "\n"
            }
            
            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.buttonScan.isEnabled = true
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
}

// MARK: VisionKit delegate

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        // save scan
        scanImageView.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
}

private enum Layout {
    static let padding: CGFloat = 24.0
}
