//
//  SideMenuViewController.swift
//  NewsApp
//
//  Created by Alina Costache on 10/26/16.
//  Copyright ©  2017 ThemeDimension.com a Mobile Web America, Inc. venture
//

import UIKit
import SwiftyJSON

class sideMenuCell : UITableViewCell {
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
}

class SideMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var itemsLabels : [String] = []
    var itemsImages : [String] = []
    @IBOutlet var tableView1: UITableView!
    var sourcesArray : [JSON] = []
    var categories : [String] = []
    var allArticles : [Article] = []
    var swipeLeft = UISwipeGestureRecognizer()
    var delegate : delegateArticles?
    //This array contains the articles sorted by "latest".
    var latestArticles : [Article] = []
    var topArticles : [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.tableView.separatorStyle = .none
        self.tableView1.separatorStyle = .none
    
        self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SideMenuViewController.swipeLeftAction(_:)))
        self.swipeLeft.direction = .left
        self.tableView.addGestureRecognizer(self.swipeLeft)
        self.tableView1.addGestureRecognizer(self.swipeLeft)
    }
    
    override func viewWillLayoutSubviews() {
        
        if self.delegate != nil {
            self.sourcesArray = (self.delegate?.getSourcesArray())!
            self.categories = (self.delegate?.getAllCategories())!
            self.allArticles = (self.delegate?.getAllArticles())! as! [Article]
            self.latestArticles = (self.delegate?.getLatestArticles())!
            self.topArticles = (self.delegate?.getTopArticles())!
        }
        //Delete categories that have no articles.
        self.cleanCategories()
        //Delete sources that have no articles.
        self.cleanSources()
        
        if (self.numberOfSections(in: self.tableView1) > 0 ) {
            let top = NSIndexPath(row: Foundation.NSNotFound, section: 0)
            self.tableView1.scrollToRow(at: top as IndexPath, at: .top, animated: false)
        }
        self.itemsLabels = ["My Collection","Top Articles","Latest Articles", "Settings"]
        self.itemsImages = ["bookmark_icon_normal","top_articles_icon", "latest_articles_icon", "settings_icon"]
        self.tableView1.alpha = 0
        self.tableView.alpha = 0
        self.tableView.frame = CGRect(x: 0, y: 1, width: 0, height: self.view.frame.height)
        self.tableView1.frame = CGRect(x: 0, y: 1, width: 0, height: self.view.frame.height)
        self.tableView.isScrollEnabled = false
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.tableView.alpha = 1
                self.tableView1.alpha = 1
                self.tableView1.frame = CGRect(x: 0, y: 1, width: window.frame.width - 70, height: window.frame.height)
                self.tableView.frame = CGRect(x: 0, y: 1, width: window.frame.width - 70, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func cleanCategories() {
        for i in 0..<self.categories.count {
            if getArticlesforCategory(category: self.categories[i]) == 0 {
                self.categories.remove(at: i)
            }
        }
    }
    
    func cleanSources() {
        self.sourcesArray = self.sourcesArray.filter({
            (source : JSON) -> Bool in
            if getArticlesForSource(source: source["name"].string!) == 0 {
                return false
            }
            return true
        })
    }
    
    //This function retrieves the number of articles from one category
    func getArticlesforCategory(category: String) -> Int {
        var result : Int = 0
        for article in self.allArticles {
            if category == article.category {
                result += 1
            }
        }
        return result
    }
    
    func getArticlesForSource(source: String) -> Int {
        var result : Int = 0
        for article in self.allArticles {
            if article.source == source {
                result += 1
            }
        }
        return result
    }
    
    //Set delegates.
    func setDelegates() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeLeftAction(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        var result: Int = 0
        if tableView == self.tableView {
            result = 1
        }
        else if tableView == self.tableView1 {
            result = 2
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result: Int = 0
        if tableView == self.tableView {
            result = 4
        }
        else if tableView == self.tableView1 {
            if section == 0 {
                result = self.categories.count
            }
            if section == 1 {
                result = self.sourcesArray.count
            }
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionName = UILabel()
        sectionName.textColor = UIColor(red: 144/255, green: 148/255, blue: 150/255, alpha: 1.0)
        sectionName.font = UIFont(name: "Roboto-Bold", size: 14)
        
        if tableView == self.tableView1 {
            if let window = UIApplication.shared.keyWindow {
                
                if section == 0 {
                    sectionName.text = "Categories"
                }
                if section == 1 {
                    sectionName.text = "Sources"
                }
                headerView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width - 70 , height: 40)
                sectionName.frame = CGRect(x: 16,y: 3, width: window.frame.size.width - 70,height: 40)
                headerView.backgroundColor = UIColor.white
                headerView.addSubview(sectionName)
            }
        }
        if tableView == self.tableView {
            if let window = UIApplication.shared.keyWindow {
                
                let gradient = CAGradientLayer()
                let color33 = UIColor(red: 33/255, green: 209/255, blue: 237/255, alpha: 1.0).cgColor as CGColor
                let color44 = UIColor(red: 85/255, green: 163/255, blue: 237/255, alpha: 1.0).cgColor as CGColor
                gradient.colors = [color44,color33]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.frame = CGRect(x: 0,y: 0,width: window.frame.size.width - 60,height: 8)
                headerView.layer.addSublayer(gradient)
                
            }
        }
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        if tableView == self.tableView {
            footerView.backgroundColor = UIColor(red: 32/255, green: 36/255, blue: 38/255, alpha: 0.1)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if tableView == self.tableView {
            return 2
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.tableView1 {
            return 60
        }
        else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = sideMenuCell()
        cell.selectionStyle = .none
        
        if tableView == self.tableView {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath) as! sideMenuCell
            cell.itemImage.image = UIImage()
            cell.itemLabel.text = ""
            cell.itemLabel.font = UIFont(name: "Roboto-Bold", size: 14)
            cell.itemLabel.textColor = UIColor(red: 113/255, green: 210/255, blue: 231/255, alpha: 1.0)
            cell.itemImage.layer.cornerRadius = 2.0
            cell.itemImage.layer.masksToBounds = true
            cell.itemImage.image = UIImage(named: self.itemsImages[indexPath.row])
            cell.itemImage.contentMode = .scaleAspectFit
            
            let itemText = self.itemsLabels[indexPath.row].replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
            cell.itemLabel.text = itemText
            
        }
        if tableView == self.tableView1 {
            cell = self.tableView1.dequeueReusableCell(withIdentifier: "cellIdentifier2", for: indexPath as IndexPath) as! sideMenuCell
            cell.selectionStyle = .none
            cell.itemImage.image = UIImage()
            cell.itemLabel.text = ""
            if indexPath.section == 0 {
                //Set the icons of the categories.
                cell.itemImage.contentMode = .scaleAspectFit
                switch self.categories[indexPath.row] {
                case  "general" :
                    cell.itemImage.image = UIImage(named:"category_icon_general")!
                case "technology" :
                    cell.itemImage.image = UIImage(named:"category_icon_technology")!
                case "sport" :
                    cell.itemImage.image = UIImage(named:"category_icon_sport")!
                case  "business" :
                    cell.itemImage.image = UIImage(named:"category_icon_business")!
                case "entertainment" :
                    cell.itemImage.image = UIImage(named:"category_icon_entertainment")!
                case "gaming" :
                    cell.itemImage.image = UIImage(named:"category_icon_gaming")!
                case "music" :
                    cell.itemImage.image = UIImage(named:"category_icon_music")!
                case "science-and-nature" :
                    cell.itemImage.image = UIImage(named:"category_icon_science_and_nature")!
                default:
                    cell.itemImage.image = UIImage(named: "category_icon_placeholder")!
                }
                
                cell.itemImage.layer.cornerRadius = 2.0
                cell.itemImage.layer.masksToBounds = true
                let itemText = self.categories[indexPath.row].replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
                
                cell.itemLabel.text = itemText.capitalized
                cell.itemLabel.font = UIFont(name: "Roboto-Bold", size: 14)
            }
            
            if indexPath.section == 1 {
                //Set the logos of the sources.
                if self.sourcesArray[indexPath.row]["urlsToLogos"]["small"].string != nil  {
                    let sourceImageCell = self.sourcesArray[indexPath.row]["urlsToLogos"]["small"].string
                    let sourceLogo : String = sourceImageCell!
                    if let contentUrl = NSURL(string: sourceLogo) {
                        cell.itemImage.image = UIImage()
                        cell.itemImage.contentMode = .scaleAspectFit
                        cell.itemImage.sd_setImage(with: contentUrl as URL!, placeholderImage:UIImage(contentsOfFile:"background_card_big"), options: [.continueInBackground, .progressiveDownload])
                        cell.itemImage.layer.cornerRadius = 2.0
                        cell.itemImage.layer.masksToBounds = true
                    }
                }
                else {
                    cell.itemImage.image = UIImage()
                }
                //Set the name of the Source.
                if self.sourcesArray[indexPath.row]["name"].string != nil {
                    cell.itemLabel.text = self.sourcesArray[indexPath.row]["name"].string?.capitalized
                    cell.itemLabel.font = UIFont(name: "Roboto-Bold", size: 14)
                }
                else {
                    cell.itemLabel.text = ""
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticlesViewController") as! ArticlesViewController
        let nav: UINavigationController = UINavigationController(rootViewController: secondViewController)
        
        //MyCollection
        if tableView == self.tableView && indexPath.row == 0 {
            self.view.alpha = 0
            var articlesToPass = [Article]()
            secondViewController.delegate = self.delegate
            if let data = UserDefaults.standard.object(forKey: "myArticles") as? NSData {
                articlesToPass = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Article]
            }
            else {
                articlesToPass = []
            }
            secondViewController.articlesForDisplay = articlesToPass.reversed()
            secondViewController.titleViewController.text = "My Collection"
            present(nav, animated: false, completion: nil)
        }
        //Top Articles.
        if tableView == self.tableView && indexPath.row == 1 {
            self.view.alpha = 0
          //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // let topArticles = appDelegate.topArticlesVC! as! TopArticlesViewController
//            topArticles.sideMenu = SideMenuViewController.instantiateFromStoryboardArticles(UIStoryboard(name: "Main", bundle: nil))
//            let nav: UINavigationController = UINavigationController(rootViewController: topArticles)
//            present(nav, animated: false, completion: nil)
            secondViewController.delegate = self.delegate
            secondViewController.articlesForDisplay = self.topArticles
            secondViewController.titleViewController.text = "Top Articles"
            present(nav, animated: false, completion: nil)

        }
        //Latest Articles.
        if tableView == self.tableView && indexPath.row == 2 {
            self.view.alpha = 0
            secondViewController.delegate = self.delegate
            secondViewController.articlesForDisplay = self.latestArticles
            secondViewController.titleViewController.text = "Latest Articles"
            present(nav, animated: false, completion: nil)
        }
        //Settings.
        if tableView == self.tableView && indexPath.row == 3 {
            self.view.alpha = 0
            let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            let nav: UINavigationController = UINavigationController(rootViewController: settingsViewController)
            present(nav, animated: false, completion: nil)
        }
        
        //categories
        if tableView == self.tableView1 && indexPath.section == 0 {
            self.view.alpha = 0
            secondViewController.delegate = self.delegate
            secondViewController.articlesForDisplay = []
            for i in 0..<self.allArticles.count {
                if self.allArticles[i].category == self.categories[indexPath.row] {
                    secondViewController.articlesForDisplay.append(self.allArticles[i])
                }
            }
            let itemText = self.categories[indexPath.row].replacingOccurrences(of: "-", with: " ", options: NSString.CompareOptions.literal, range: nil)
            secondViewController.titleViewController.text = itemText.capitalized
            
            present(nav, animated: false, completion: nil)
            
        }
        //sources
        if tableView == self.tableView1 && indexPath.section == 1 {
            self.view.alpha = 0
            secondViewController.delegate = self.delegate
            secondViewController.articlesForDisplay = []
            for i in 0..<self.allArticles.count {
                if self.allArticles[i].source.capitalized == self.sourcesArray[indexPath.row]["name"].string!.capitalized {
                    secondViewController.articlesForDisplay.append(self.allArticles[i])
                }
            }
            secondViewController.titleViewController.text = self.sourcesArray[indexPath.row]["name"].string?.capitalized
            present(nav, animated: false, completion: nil)
            
        }
    }
}
