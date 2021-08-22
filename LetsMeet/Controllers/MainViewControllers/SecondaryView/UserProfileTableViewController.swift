//
//  UserProfileTableViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 21/8/21.
//

import UIKit
import Kingfisher

class UserProfileTableViewController: UITableViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var sectionOneCollectionView: UICollectionView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    //MARK:- vars
    var userObject:FUser?
    var allImages : [UIImage] = []
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
    
    //MARK:- lifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageControl.hidesForSinglePage = true
        if let user = userObject{
            showUserDetailes(of: user)
            loadImages(of: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGrounds()
        hideActivityIndicator()
        print("showing User", userObject?.userName)
    }
    //MARK:- IBActions
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
    }
    
    //MARK:- TableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    //MARK:- setup UI
    private func setupBackGrounds(){
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
    }
    
    private func showUserDetailes(of user:FUser){
        aboutTextView.text = user.about
        professionLabel.text = user.profession
        jobLabel.text = user.jobTitle
        genderLabel.text = user.isMale ? "Male":"Female"
        heightLabel.text = String(format: "%.2f", user.height)
        lookingForLabel.text = user.lookingfor
    }
    //MARK:- LoadImages
    private func loadImages(of user:FUser){
        var avatarDownLoadDone = false
        var allImagesDownLoadDone = false
        let placeHolder = user.isMale ? "mPlaceholder":"fPlaceholder"
        showActivityIndicator()
        print("activity indicator started 1")
        if user.avatarLink == ""{
            avatarDownLoadDone = true
        }else{
            FileStorage.downloadImageFromURL(with:user.avatarLink){image in
                guard let image  = image else { return}
                self.allImages += [image]
                avatarDownLoadDone = true
                
                
                DispatchQueue.main.async {
                    //show page control
                    self.setPageControlPages()
                    if avatarDownLoadDone && allImagesDownLoadDone{
                        self.hideActivityIndicator()
                        print("activity indicator stopped 1")
                    }
                    
                    self.sectionOneCollectionView.reloadData()
                }
                
             }
        }
        showActivityIndicator()
        print("activity indicator started 2")
        if let imageLinks = user.imageLinks{
            var imageNo = 0
            if imageLinks.count > 0{
                for link in imageLinks{
                    FileStorage.downloadImageFromURL(with: link) { (image) in
                        if let image = image{
                            self.allImages += [image]
                            //show page control
                            self.setPageControlPages()
                            imageNo += 1
                            if imageNo == imageLinks.count{
                                allImagesDownLoadDone = true
                                DispatchQueue.main.async {
                                    if allImagesDownLoadDone && avatarDownLoadDone{
                                        self.hideActivityIndicator()
                                        print("activity indicator stopped 2")
                                        self.sectionOneCollectionView.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }else{
                print("In the first else")
                allImagesDownLoadDone = true
                if allImagesDownLoadDone && avatarDownLoadDone{
                    hideActivityIndicator()
                    print("activity indicator stopped 3")
                }
            }
        }else{
            print("In the Second else")
            allImagesDownLoadDone = true
            if allImagesDownLoadDone && avatarDownLoadDone{
                hideActivityIndicator()
                print("activity indicator stopped 4")
            }
        }
    }
    //MARK:- PageControl
    private func setPageControlPages(){
        self.pageControl.numberOfPages = self.allImages.count
    }
    private func setSelectedPageTo(pageNo:Int){
        self.pageControl.currentPage = pageNo
    }
    
    //MARK:- Activity indicator
    private func showActivityIndicator(){
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    private func hideActivityIndicator(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
}

//MARK:- CollectionView Datasource and Delegate

extension UserProfileTableViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        
        guard let user = userObject else {
            return cell
        }
        
        let countryCity = user.country + ", " + user.city
        let nameAge = user.userName + ", " + "\(user.dateOfBirth.interval(ofComponent: .year, fromDate: Date()))"
        
        cell.setUpcell(image: allImages[indexPath.row], countryCity: countryCity, nameAge: nameAge, indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image tap")
    }
    
}

extension UserProfileTableViewController : UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 437.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setSelectedPageTo(pageNo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
    
}

