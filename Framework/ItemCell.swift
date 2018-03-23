//
//  ItemCell.swift
//  Framework
//
//  Created by Clementine Ferreol on 29/01/2018.
//  Copyright © 2018 Clementine Ferreol. All rights reserved.
//

import Foundation
import UIKit

class ItemCell : UITableViewCell {
    
    override func  awakeFromNib() {
        self.contentView.backgroundColor = .white
        
    }
    
    func prepareView(data:[String:String]){
        
        let url = URL(string: data["image"]!)
        let imageUrl = try? Data(contentsOf: url!)
        
        let image = UIImageView()
        image.image = UIImage(data: imageUrl!)
        image.contentMode = .scaleAspectFill
        
        self.contentView.addSubviewGrid(view: image, grid:["x": 0, "y":0, "width":4, "height":12])
        
        let title = UILabel()
        title.text = data["title"]!
        title.font = title.font.withSize(12)
        title.font = UIFont.boldSystemFont(ofSize: title.font.pointSize)
        title.textAlignment = .left
        title.textColor = .blue
        
        self.contentView.addSubviewGrid(view: title, grid:["x": 5, "y":-4, "width":6, "height":12])
        
        let price = UILabel()
        price.text = data["price"]! + "€"
        price.font = price.font.withSize(12)
        price.textAlignment = .left
        price.textColor = .orange
        
        self.contentView.addSubviewGrid(view: price, grid:["x": 5, "y":-1, "width":4, "height":12])
        
        let type = UILabel()
        type.text = data["type"]!
        type.font = type.font.withSize(10)
        type.textAlignment = .left
        type.textColor = .blue
        
        
        self.contentView.addSubviewGrid(view: type, grid:["x": 5, "y":1, "width":4, "height":12])
        
        let adress = UILabel()
        adress.text = data["adress"]!
        adress.font = adress.font.withSize(10)
        adress.textAlignment = .left
        adress.textColor = .blue
        
        
        self.contentView.addSubviewGrid(view: adress, grid:["x": 5, "y":3, "width":6, "height":12])
        
        
        let date = UILabel()
        date.text = data["date"]!
        date.font = adress.font.withSize(10)
        date.textAlignment = .left
        date.textColor = .blue
        
        
        self.contentView.addSubviewGrid(view: date, grid:["x": 5, "y":5, "width":4, "height":12])
        
    }
}
