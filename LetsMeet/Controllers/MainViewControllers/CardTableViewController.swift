//
//  CardTableViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 18/8/21.
//

import UIKit
import ProgressHUD

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
        cell.userImageView.image = UIImage(named: "user1")
        cell.ageLabel.text = "26"
        cell.nameLabel.text = cards[indexPath.row].username
        cell.professionLabel.text = cards[indexPath.row].profession
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Trigger pagination when scrolled to last cell
            // Feel free to adjust when you want pagination to be triggered
            if (indexPath.row == cards.count - 1) {
                FirebaseListener.shared.paginate { (err, cards) in
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
    
    //MARK:- IBActions
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
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
            if imageIndex == 16{
                imageIndex = 1
            }
        }
    }
}
