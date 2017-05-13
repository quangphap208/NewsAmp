//
//  collectionCell.swift
//  NewsApp
//
//  Created by Alina Costache on 1/10/17.
//  Copyright © 2017 ThemeDimension.com a Mobile Web America, Inc. venture
//

import Foundation
import UIKit

class collectionCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var sourceName: UILabel!
    var sourceImage: UIImageView!
    var backgroundViewCell = UIView()
    var whiteRoundedView = UIView()
    var addToArticlesList: UIButton!
    var shareButton: UIButton!
    var backgroundViewImage = UIImageView()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}
