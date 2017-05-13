//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Alina Costache on 11/15/16.
//  Copyright ©  2017 ThemeDimension.com a Mobile Web America, Inc. venture
//

import UIKit
import MessageUI


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
 
    //Variables
    var backButton = UIButton()
    var titleViewController = UILabel()
    var gradientLayer = CAGradientLayer()
    var backgroundView = UIView()
    var tableView : UITableView!
    var items : [String] = []
    var switchState : Bool!
    var itemsImages : [String] = []
    
    //Modify this variables for custom settings.
    //Send feedback email
    var recipientsArray: [String] = []
    var subjectString : String = ""
    
    //Privacy.
    var privacyString : String = ""
    
    //App store.
    var appStoreUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set ViewController's title.
        self.titleViewController.frame = CGRect(x: 75, y: 5, width: 170, height: 34)
        self.titleViewController.font = UIFont(name: "Roboto-Bold" , size: 23)
        self.titleViewController.textColor = UIColor.black
        self.titleViewController.textAlignment = .left
        self.titleViewController.text = "Settings"
        self.navigationController?.navigationBar.addSubview(self.titleViewController)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color:UIColor(red:119, green: 136, blue: 153, alpha: 1)), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Set icon and action for back button.
        self.backButton.frame = CGRect(x: 0, y: 5, width: 20 , height: 20)
        self.backButton.setImage(UIImage(named: "back_arrow_button"), for: UIControlState())
        self.backButton.addTarget(self, action: #selector(FullArticleViewController.backTopArticles(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red:119, green: 136, blue: 153, alpha: 1)
        
        self.items = ["Feedback","Rate Us","Privacy"]
        self.itemsImages = ["feedback_icon","rate_us_icon","privacy_icon"]
        //Set tableView
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
       
        //Set colors for background.
        let topColor =  UIColor(red:119, green: 136, blue: 153, alpha: 1).cgColor as CGColor
        let bottomColor = UIColor(white: 0.9, alpha: 1).cgColor as CGColor
        self.gradientLayer.colors = [topColor,bottomColor]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.frame = self.view.bounds
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.layer.insertSublayer(self.gradientLayer, at: 0)
       
        self.view.addSubview(backgroundView)
        self.view.addSubview(self.tableView)
    }
    
    //Back button action.
    func backTopArticles(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let topArticles = appDelegate.topArticlesVC! as! TopArticlesViewController
        let nav: UINavigationController = UINavigationController(rootViewController: topArticles)
        topArticles.sideMenu = SideMenuViewController.instantiateFromStoryboard(UIStoryboard(name: "Main", bundle: nil))
        present(nav, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        var textLabel = UILabel()
        var image = UIImageView()
        
        textLabel = UILabel(frame: CGRect(x: 75,y: 25,width: 80,height: 20))
        textLabel.text = self.items[indexPath.row]
        textLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        textLabel.textColor = UIColor.black
        cell.addSubview(textLabel)
        
        image = UIImageView(frame: CGRect(x: 30,y: 25, width: 20 ,height: 20) )
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: self.itemsImages[indexPath.row])
        cell.addSubview(image)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //feedback
        if indexPath.row == 0 {
            //Send email
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 1 {
            //Rate us -  app store page.
            if let url = URL(string: self.appStoreUrl) {
                UIApplication.shared.openURL(url)
            }
        }
            
        else if indexPath.row == 2 {
            //Privacy. Send to privacy page.
            if let url = URL(string: self.privacyString) {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    //MARK: Compose mail.
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(self.recipientsArray)
        mailComposerVC.setSubject(self.subjectString)
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: false, completion: nil)
    }
}

