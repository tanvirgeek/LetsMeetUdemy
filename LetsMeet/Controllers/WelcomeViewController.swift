//
//  WelcomeViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 5/8/21.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK:- IBoutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    //MARK:- LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
    }
    
    //MARK:- IBactions
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        if emailTextField.text == ""{
            ProgressHUD.showError("Please insert your email address.")
        }else{
            // do forgot password
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == ""{
            ProgressHUD.showError("All fields are required")
        }else{
            //do login
        }
    }
    
    //MARK:- setup
    func setupBackgroundTouch(){
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTapped(){
        dismissKeyBoard()
    }
    
    //MARK:- helpers
    func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    

}
