//
//  Articles.swift
//  NewsApp
//
//  Created by Alina Costache on 10/19/16.
//  Copyright © 2017 ThemeDimension.com a Mobile Web America, Inc. venture
//



import Foundation

class Article: NSObject, NSCoding {
    var source = String()
    var category = String()
    var sourceImage = String()
    var author = String()
    var title = String()
    var articleDescription = String()
    var url = String()
    var urlToImage = String()
    var publishedAt = Date()
    var sortBy = String()
    
    override init() {
        self.source = ""
        self.category = ""
        self.sourceImage = ""
        self.author = ""
        self.title = ""
        self.articleDescription = ""
        self.url = ""
        self.urlToImage = ""
        self.publishedAt = Date()
        self.sortBy = ""
    }
    
    init(source: String, category: String, sourceImage: String, author: String, title: String, articleDescription: String, url: String, urlToImage:String, publishedAt: Date, sortBy: String) {
        self.source = source
        self.category = category
        self.sourceImage = sourceImage
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.sortBy = sortBy
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {        
        
        self.init(
            source: aDecoder.decodeObject(forKey: "source") as! String,
            category: aDecoder.decodeObject(forKey: "category") as! String,
            sourceImage: aDecoder.decodeObject(forKey: "sourceImage") as! String,
            author: aDecoder.decodeObject(forKey: "author") as! String,
            title: aDecoder.decodeObject(forKey: "title") as! String,
            articleDescription : aDecoder.decodeObject(forKey: "articleDescription") as! String,
            url : aDecoder.decodeObject(forKey: "url") as! String,
            urlToImage : aDecoder.decodeObject(forKey: "urlToImage") as! String,
            publishedAt : aDecoder.decodeObject(forKey: "publishedAt") as! Date,
            sortBy : aDecoder.decodeObject(forKey: "sortBy") as! String

        )
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return (self.title == (object as! Article).title  && self.articleDescription == (object as! Article).articleDescription && self.url == (object as! Article).url && self.source == (object as! Article).source)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.source, forKey: "source")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.sourceImage, forKey: "sourceImage")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.articleDescription, forKey: "articleDescription")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.urlToImage, forKey: "urlToImage")
        aCoder.encode(self.publishedAt, forKey: "publishedAt")
        aCoder.encode(self.sortBy, forKey: "sortBy")

    }
    
    
    
}
