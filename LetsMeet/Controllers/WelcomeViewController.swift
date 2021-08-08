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
            FUser.resetPasswordFor(email: emailTextField.text!) { (error) in
                if let err = error{
                    ProgressHUD.showError(err.localizedDescription)
                }else{
                    ProgressHUD.showSuccess("Please check your email")                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            if emailTextField.text == "" || passwordTextField.text == ""{
                ProgressHUD.showError("All fields are required")
            }else{
                //do login
                FUser.loginWith(email: email, password: password) { (loginError, isEmailVerified) in
                    if let loginError = loginError{
                        ProgressHUD.showError(loginError.localizedDescription)
                    }else{
                        if isEmailVerified{
                            //enter the application
                            print("Go to app")
                            self.goToApp()
                        }else{
                            ProgressHUD.showError("Email is not verified")
                        }
                    }
                }
            }
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
    
    func goToApp(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

}
