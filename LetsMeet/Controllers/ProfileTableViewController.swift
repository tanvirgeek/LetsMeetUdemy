//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 10/8/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextField: UITextView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var gendrTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    @IBOutlet weak var aboutMeView: UIView!
    
    //MARK:- Vars
    var editingMode = false
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setUpBackground()
        
        if FUser.currentUser() != nil{
            loadUserData()
            updatEditingMode()
        }
        
    }
    
    //MARK:- IBActions
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        showEditOptions()
    }
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        showPictureActions()
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        editingMode.toggle()
        updatEditingMode()
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    
    @objc func editUserData(){
        
    }
    
    //MARK:- SetUp
    private func setUpBackground(){
        profileCellBackgroundView.clipsToBounds = true
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        profileCellBackgroundView.layer.cornerRadius = 100
        
        aboutMeView.layer.cornerRadius = 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    //MARK:- LoadUserData
    func loadUserData(){
        if let currenUser = FUser.currentUser(){
            nameAgeLabel.text = currenUser.userName + " " + "\(currenUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date()))"
            cityCountryLabel.text = currenUser.country + " " + currenUser.city
            aboutMeTextField.text = currenUser.about == "".trimmingCharacters(in: .whitespaces) ? "A little bit about me" : currenUser.about
            jobTextField.text = currenUser.jobTitle
            gendrTextField.text = currenUser.isMale ? "Male" : "Female"
            cityTextField.text = currenUser.city
            countryTextField.text = currenUser.country
            heightTextField.text = "\(currenUser.height)"
            lookingForTextField.text = currenUser.lookingfor
            avatarImageView.image = nil
            professionTextField.text = currenUser.profession
            
        }
    }
    
    //MARK:- EditingMode
    private func updatEditingMode(){
        aboutMeTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        gendrTextField.isUserInteractionEnabled = editingMode
        heightTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
        
    }
    
    //MARK:- helpers
    private func showKeyboard(){
        self.aboutMeTextField.becomeFirstResponder()
        
    }
    
    private func hideKeyboard(){
        self.view.endEditing(false)
    }
    
    private func showSaveButton(){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    //MARK:- AlertController
    private func showPictureActions(){
        let alertController = UIAlertController(title: "Upload picture", message: "You can change your avatar or upload more pictures", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            // change avatar
        }))
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            // Upload Pictures
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showEditOptions(){
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to change sensitive information", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            // change Email
        }))
        alertController.addAction(UIAlertAction(title: "Upload Name", style: .default, handler: { (alert) in
            // change name
        }))
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            // Log Out
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
