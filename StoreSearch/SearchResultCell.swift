//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Chad on 2/23/18.
//  Copyright © 2018 Chad Williams. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageVIew: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
      let selectedView = UIView(frame: CGRect.zero)
      selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
      selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
