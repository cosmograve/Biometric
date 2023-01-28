//
//  ViewController.swift
//  Biometric
//
//  Created by Алексей Авер on 28.01.2023.
//

import UIKit
import LocalAuthentication
 
class ViewController: UIViewController {

    let authButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }
    
    private func addButton() {
        view.addSubview(authButton)
        authButton.center = view.center
        authButton.setTitle("Authorize", for: .normal)
        authButton.layer.cornerRadius = 8
        authButton.backgroundColor = .blue
        authButton.addTarget(self, action: #selector(authTapped), for: .touchUpInside)
    }
    
    @objc private func authTapped() {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     error: &error) {
            let reason = "Авторизуйтесь с помощью Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        self?.showAlert()
                        return
                        
                    }
                    let vc = UIViewController()
                    vc.title = "Привет"
                    vc.view.backgroundColor = UIColor(hex: "c4c4d7")
                    self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }
            }
            
        } else {
            showAlert()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Недоступно", message: "Попробуйте еще раз", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
