//
//  MainViewController.swift
//  NewsApp
//
//  Created by Alina Costache on 12/6/16.
//  Copyright ©  2017 ThemeDimension.com a Mobile Web America, Inc. venture
//

import UIKit
import Alamofire
import SwiftyJSON


class MainViewController: UIViewController {
    //Begin variable listing.
    var activityView: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var titleLabel = UILabel()
    //This array contains the sources dictionary.
    var sourcesArray = [String: AnyObject]()
    //This array contains all the articles saved by the user.
    var savedArticles : [Article] = []
    //This array contains all the articles sorted by "top" for all the sources.
    var topArticles : [Article] = []
    //This array contains all the articles for all the sources.
    var allArticles : [Article] = []
    //This array contains all the categories for which there are articles.
    var categoriesArray : [String] = []
    var rowToPass = 0
    var sectionToPass = 0
    var source = ""
    var category = ""
    var sourceImage = ""
    var author = ""
    var articleTitle = ""
    var articleDescription = ""
    var url = ""
    var urlToImage = ""
    var publishedAt = Date()
    var sortBy = ""
    let blackView = UIView()
    var ok = false
    var gradientLayer = CAGradientLayer()
    //This array of JSON contains the JSON returned for the sources.
    var sources: [JSON] = []
    // You can change this array to contain the sources ID's for which you want to download the articles.
    // If the array is empty, all the articles for all the sources available will be downloaded.
    var definedSourcesIDs : [String] = []
    // You can change this array to contain the categories for which you want to download the articles.
    // If the array is empty, all the articles from all the categories available will be downloaded.
    var definedCategories : [String] =  []
    //This array contains the articles sorted by "latest".
    var latestArticles : [Article] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackground()
        parseJson()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Set view's background
    func setBackground() {
        let color33 =  UIColor(red:119, green: 136, blue: 153, alpha: 1).cgColor as CGColor
        let color44 = UIColor(white: 1, alpha: 0.9).cgColor as CGColor
        self.gradientLayer.colors = [color33,color44]
        self.gradientLayer.locations = [0.0,1.0]
        self.gradientLayer.frame = self.view.frame
        self.view.layer.addSublayer(self.gradientLayer)
        
    }
    
    //MARK: - Activity Indicator
    func showActivity(_ myView: UIView) {
        
        myView.isUserInteractionEnabled = false
        myView.endEditing(true)
        
        self.activityView.frame = CGRect(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
        
        self.activityView.center = myView.center
        self.activityView.backgroundColor = UIColor.white
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        self.loadingView.center = myView.center
        self.loadingView.backgroundColor = UIColor.clear
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 15
        
        self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        self.titleLabel.frame = CGRect(x: 5, y: loadingView.frame.height-20, width: loadingView.frame.width-10, height: 20)
        self.titleLabel.textColor = UIColor.gray
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.text = "Loading..."
        self.titleLabel.font = UIFont(name:"Roboto-Light", size: 10)
        
        self.loadingView.addSubview(self.activityIndicator)
        self.activityView.addSubview(self.loadingView)
        self.loadingView.addSubview(self.titleLabel)
        myView.addSubview(self.activityView)
        self.activityIndicator.startAnimating()
    }
    
    func removeActivity(_ myView: UIView) {
        myView.isUserInteractionEnabled = true
        myView.window?.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
        self.activityView.removeFromSuperview()
    }
    
    
    //MARK: - Json
    
    func parseJson() {
        //Show activity indicator while the articles are downloading.
        self.showActivity(self.view)
        var completedSources : Int = 0
        //The variable requestURL contains the URL for the sources.
        let requestURL: URL = URL(string:"https://newsapi.org/v1/sources")!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        
        Alamofire.request(urlRequest).responseJSON {
            response in
            switch response.result{
            case .failure:
                //In case of an error, the activity indicator is removed and a alert pops with a message.
                self.removeActivity(self.view)
                let ErrorAlert = UIAlertController(title: "Error", message: "There is a problem with the internet connectivity or server. Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                ErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in self.parseJson()}))
                self.present(ErrorAlert, animated: true, completion: nil)
            case .success(let value):
                //If the result is successfully, the json is saved.
                let json = JSON(value)
                if let sources = json["sources"].array {
                    for source in sources {
                        if let sourceId = source["id"].string {
                            //Here the definedSourcesIDs array is checked to see if there are prefered sources for which to download the articles.
                            if self.definedSourcesIDs.count == 0 || self.definedSourcesIDs.contains(sourceId) {
                                //Save categories.
                                if let category = source["category"].string {
                                    //Here the definedCategories array is checked to see if there are prefered categories for which to download the articles.
                                     if (self.definedCategories.count == 0 || self.definedCategories.contains(category)) {
                                        //Add a new Source
                                        self.sources.append(source)
                                        //Successfully add a new category.
                                        if !self.categoriesArray.contains(category) {
                                            self.categoriesArray.append(category)
                                        }

                                    }
                                }
                            }
                        }
                    }
                    for source in self.sources {
                        if let sourceDictionary = source.dictionary {
                            //Successfully got the sources as a dictionary.
                            if let sourceId = source["id"].string {
                                //Call downloadArticlesForID for the current source.
                                self.downloadArticlesForID(sourceId: sourceId, source : sourceDictionary,callback: {
                                    (check:Int) -> Void in
                                    if check == 1 {
                                        //Checked if the download is finished. If the download is finished, the TopArticlesViewController is presented.
                                        completedSources += 1
                                        if completedSources == self.sources.count || (self.definedSourcesIDs.count != 0 && completedSources == self.definedSourcesIDs.count)  {
                                                self.downloadCompleted()
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    /*
     MARK: - Download articles for source.
     This function downloads the articles with the parameter sourceId for the source submitted as a parameter too.
     */
    func downloadArticlesForID(sourceId: String, source: [String: JSON], callback:@escaping (Int) -> Void) {
        
        //The variable requestURL contains the URL for the sources you want to download the articles.
        let requestURL = URL(string:"https://newsapi.org/v1/articles?source="+"\(sourceId)"+"&apiKey=cab5d0775dc545288f3c981d052d2dc7")!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        Alamofire.request(urlRequest).responseJSON {
            response in
            switch response.result{
            case .failure:
                //In case of an error a alert pops with a message.
                self.removeActivity(self.view)
                let ErrorAlert = UIAlertController(title: "Error", message: "There is a problem with the internet connectivity or server. Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                ErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in self.parseJson()}))
                self.present(ErrorAlert, animated: true, completion: nil)
                callback(0)
            case .success(let value):
                //If the result is successfully, the json is saved.
                let json = JSON(value)
                if let sortType = json["sortBy"].string, sortType == "top" {
                    //Successfully call getArticles for the articles sorted by "top".
                    self.getArticles(source: source, json: json, top: true, latest: false  )
                }
                if let sortType = json["sortBy"].string, sortType == "latest" {
                    //Successfully call getArticles for the articles sorted by "latest".
                    self.getArticles(source: source, json: json, top: false, latest: true )
                }
                //Successfully call getArticles for all the articles.
                self.getArticles(source: source, json: json, top: false, latest: false )
                
                self.author = ""
                self.articleTitle = ""
                self.articleDescription = ""
                self.url = ""
                self.urlToImage = ""
                self.publishedAt = Date()
                self.source = ""
                self.category = ""
                self.sourceImage = ""
                self.sortBy = ""
                callback(1)
            }
        }
    }
    
    /*
     MARK: - Save the downloaded article.
     This functions will save the downloaded article depending on its "sortBy" status.
     */
    func getArticles(source: [String: JSON], json: JSON, top: Bool, latest: Bool) {
        
        //Save the data into variables.
        if let sortType = json["sortBy"].string {
            if let articlesUnwrapped = json["articles"].array {
                if let sourceName = source["name"]?.string {
                    self.source = sourceName
                }
                if let urlToLogos = source["urlsToLogos"]?.dictionary {
                    if let logo = urlToLogos["small"]?.string {
                        self.sourceImage = logo
                    }
                }
                self.sortBy = sortType
                if let artCategory = source["category"]?.string {
                    self.category = artCategory
                }
                
                for articleDictionary in articlesUnwrapped {
                    if let article = articleDictionary.dictionary {
                        if let artAuthor = article["author"]?.string {
                            self.author = artAuthor
                        }
                        if let artTitle = article["title"]?.string {
                            self.articleTitle = artTitle
                        }
                        if let artDesc = article["description"]?.string {
                            self.articleDescription = artDesc
                        }
                        if let artUrl = article["url"]?.string {
                            if URL(string: artUrl) != nil {
                                self.url = artUrl
                                self.ok = true
                            }
                        }
                        if let artUrlImage = article["urlToImage"]?.string {
                            self.urlToImage = artUrlImage
                        }
                        if let artPubAt = article["publishedAt"]?.string {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date = dateFormatter.date(from: artPubAt)
                            if  date != nil {
                                self.publishedAt = date!
                            }
                        }
                        if self.source == "" && self.category ==  "" && self.sourceImage == "" && self.author ==  "" && self.author == "" && self.articleTitle ==  "" && self.articleDescription ==  "" && self.url == "" && self.urlToImage ==  "" && self.publishedAt ==  Date() {
                            return
                        }
                        else {
                            if self.ok == true {
                                let articleToSave = Article(source: self.source,category: self.category, sourceImage: self.sourceImage, author: self.author, title: self.articleTitle, articleDescription: self.articleDescription,url: self.url, urlToImage: self.urlToImage, publishedAt: self.publishedAt, sortBy: self.sortBy)
                                if top == true {
                                    //If the article is sorted by top, it's added in the topArticles Array.
                                    if !self.topArticles.contains(articleToSave){
                                        self.topArticles.append(articleToSave)
                                    }
                                } else if latest == true {
                                    if !self.latestArticles.contains(articleToSave){
                                        self.latestArticles.append(articleToSave)
                                    }
                                }
                                //The article it's added in the allArticles Array.
                                if !self.allArticles.contains(articleToSave){
                                    self.allArticles.append(articleToSave)
                                }
                          
                                self.author = ""
                                self.articleTitle = ""
                                self.articleDescription = ""
                                self.url = ""
                                self.urlToImage = ""
                                self.publishedAt = Date()
                                self.ok = false
                            }
                        }
                    }
                }
                
                self.source = ""
                self.category = ""
                self.sourceImage = ""
                self.sortBy = ""
            }
        }
        
    }

    /*
     MARK: - Finished download
     Initializes the variables for the TopArticlesViewController and presests it.
    */
    func downloadCompleted() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let topArticlesViewController = appDelegate.topArticlesVC! as! TopArticlesViewController
        topArticlesViewController.sideMenu = SideMenuViewController.instantiateFromStoryboardArticles(UIStoryboard(name: "Main", bundle: nil))
        topArticlesViewController.allArticles = [Article](Set(self.allArticles))
        topArticlesViewController.categoriesArray = self.categoriesArray
        topArticlesViewController.topArticles =  [Article](Set(self.topArticles))
        topArticlesViewController.sourcesArray = self.sources
        topArticlesViewController.latestArticles = self.latestArticles
        let nav: UINavigationController = UINavigationController(rootViewController: topArticlesViewController)
        present(nav, animated: false, completion: nil)
    }
}
