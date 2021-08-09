//
//  RegisterViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 5/8/21.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var genderSegmentedControll: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK:- Vars
    var isMale = true
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundTouch()
        overrideUserInterfaceStyle = .dark
        //datePicker.datePickerMode = .date
    }
    
    //MARK:- IBActions
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if isTextDataImputed(){
            if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text{
                if password == confirmPassword{
                    registerUser()
                }else{
                    ProgressHUD.showError("Passwords do not match")
                }
            }
            
        }else{
            ProgressHUD.showError("All Fields are Required")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genderSegmentedControlChanged(_ sender: UISegmentedControl) {
        isMale = sender.selectedSegmentIndex == 0 ? true : false
        print(isMale)
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
    
    private func isTextDataImputed()->Bool{
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
    
    private func registerUser(){
        //print(datePicker.date)
        ProgressHUD.show()
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let city = cityTextField.text{
            FUser.registerUserWith(email: email, password: password, username: username, city: city, isMale: isMale, dateOfBirth: datePicker.date) { error in

                if let error = error{
                    ProgressHUD.showError(error.localizedDescription)
                }else{
                    ProgressHUD.showSuccess("Verification email sent!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
