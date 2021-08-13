//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 10/8/21.
//

import UIKit
import Gallery
import ProgressHUD

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
    var uploadingAvatar = true
    var avatarImage:UIImage?
    var gallery:GalleryController!
    
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
    
    //MARK:- SaveEditedData
    @objc func editUserData(){
        if let user = FUser.currentUser(){
            user.about = aboutMeTextField.text
            user.jobTitle = jobTextField.text ?? ""
            user.profession = professionTextField.text ?? ""
            user.isMale = gendrTextField.text == "Male"
            user.city = cityTextField.text ?? ""
            user.country = countryTextField.text ?? ""
            user.height = Double(heightTextField.text ?? "0") ?? 0.0
            user.lookingfor = lookingForTextField.text ?? ""
            
            if let avatarImage = avatarImage{
                // Upload new Avatar
                uploadAvatar(avatarImage) { (avatarLink) in
                    user.avatarLink = avatarLink ?? ""
                    user.avatar = self.avatarImage
                    self.saveUserData(withUser: user)
                    self.loadUserData()
                    ProgressHUD.dismiss()
                }
                // Save User
                
            }else{
                //save
                saveUserData(withUser: user)
                self.loadUserData()
            }
        }
        
        self.editingMode = false
        self.updatEditingMode()
        self.showSaveButton()
    }
    
    private func saveUserData(withUser user:FUser){
        user.saveUserLocally()
        user.saveUserToFireStore()
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
            avatarImageView.image = UIImage(named: "avatar")
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
    
    //MARK:- fileStorage
    private func uploadAvatar(_ image:UIImage, completion:@escaping (_ avatarLink:String?)->Void){
        ProgressHUD.show()
        if let userId = FUser.currentUserId(){
            let fileDirectory = "Avatars/_" + userId + ".jpg"
            FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
                completion(avatarLink)
            }
        }else{
            completion(nil)
        }
        
    }
    
    private func upLoadImages(images:[UIImage?]){
        ProgressHUD.show()
        print("Uploading Images")
    }
    
    //MARK:- Gallery
    private func showGallery(forAvatar:Bool){
        uploadingAvatar = forAvatar
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = forAvatar ? 1:10
        Config.initialTab = .imageTab
        self.present(gallery, animated: true, completion: nil)
    }
    
    //MARK:- AlertController
    private func showPictureActions(){
        let alertController = UIAlertController(title: "Upload picture", message: "You can change your avatar or upload more pictures", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            // change avatar
            self.showGallery(forAvatar: true)
        }))
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            self.showGallery(forAvatar: false)
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

extension ProfileTableViewController: GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            if uploadingAvatar{
                images.first?.resolve(completion: { (icon) in
                    if icon != nil{
                        self.editingMode = true
                        self.showSaveButton()
                        self.avatarImageView.image = icon
                        self.avatarImage = icon
                    }
                    else{
                        ProgressHUD.showError("Could not select Image")
                    }
                })
            }else{
                print("We have multiple images")
                Image.resolve(images: images) { (resolvedImages) in
                    self.upLoadImages(images: resolvedImages)
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
