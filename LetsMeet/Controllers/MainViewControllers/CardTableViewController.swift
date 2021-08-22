//
//  CardTableViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 18/8/21.
//

import UIKit
import ProgressHUD
import Kingfisher

class CardTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var userTableView: UITableView!
    
    var cards:[UserCardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.estimatedRowHeight = 250
        FirebaseListener.shared.getUserCardsFromFirebase { (error, cards) in
            if let err = error{
                ProgressHUD.showError(err.localizedDescription)
            }
            if let cards = cards{
                self.cards = cards
                self.userTableView.reloadData()
            }
        }
        //createUsers()
    }
    
    //MARK:- TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userCell") as! MyUserTableViewCell
        
        let imageLink = cards[indexPath.row].avatarLink ?? ""
        print("imageLink: \(imageLink)")
//        FileStorage.downloadUserImage(imageURL: imageLink) { (image) in
//            if let image = image{
//                DispatchQueue.main.async {
//                    print("image:\(image)")
//                    cell.userImageView.image = image
//                }
//            }
//        }
        let url = URL(string: imageLink)
        cell.userImageView.kf.setImage(with: url)
        cell.ageLabel.text = "\(cards[indexPath.row].dateOfBirth.interval(ofComponent: .year, fromDate: Date()))"
        cell.nameLabel.text = cards[indexPath.row].username
        cell.professionLabel.text = cards[indexPath.row].profession
        cell.likeButton.tag = indexPath.row
        cell.dislikeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        cell.dislikeButton.addTarget(self, action: #selector(disLikeButtonPressed), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Trigger pagination when scrolled to last cell
            // Feel free to adjust when you want pagination to be triggered
            if (indexPath.row == cards.count - 1) {
                
                FirebaseListener.shared.paginate(lastObjectId: cards[indexPath.row].objectId) { (err, cards) in
                    if let err = err{
                        ProgressHUD.showError(err.localizedDescription)
                    }
                    if let newCards = cards{
                        self.cards.append(contentsOf: newCards)
                        self.userTableView.reloadData()
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = cards[indexPath.row].objectId
        showUserProfileFor(userId: userId)
    }
    //MARK:- Navigation
    private func showUserProfileFor(userId:String){
        ProgressHUD.show()
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as!UserProfileTableViewController
        FirebaseListener.shared.downloadUserWith(userId: userId) { (error, user) in
            if let err = error{
                ProgressHUD.showError(err.localizedDescription)
            }
            if let user = user{
                ProgressHUD.dismiss()
                profileView.userObject = user
                self.present(profileView, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK:- Like and DislikeButton Pressed
    @objc func likeButtonPressed(sender:UIButton){
        print(sender.tag)
    }
    @objc func disLikeButtonPressed(sender:UIButton){
        print(sender.tag)
    }
    
    
    
    
    //MARK:- CreateUsers
    private func createUsers(){
        let names = ["Ifa","Shuvo","Rodoshi","Shumi","Mim","Safat","Nishat","Misti","Rita","Ruma","Mithun"]
        var imageIndex = 1
        var userIndex = 1
        
        for i in 0..<11{
            let id = UUID().uuidString
            
            let fileDirectory = "Avatars/_" + id + ".jpg"
            
            FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
                let user = FUser(_objectId: id, _email: "user\(userIndex)", _userName: names[i], _dateOfBirth: Date(), _isMale: false, _city: "No City", _avatarLink: avatarLink ?? "")
                userIndex += 1
                
                user.saveUserToFireStore()
                
            }
            imageIndex += 1
            if imageIndex == 16{
                imageIndex = 1
            }
        }
    }
}
