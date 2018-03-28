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
  
  var downloadTask: URLSessionDownloadTask?

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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }
  
  // MARK:- Public Methods
  func configure(for result: SearchResult) {
    nameLabel.text = result.name
    
    if result.artistName.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown Artist Name")
    } else {
      // artistNameLabel.text = String(format: "%@ (%@)", result.artistName, result.type)
      artistNameLabel.text = String(format: NSLocalizedString("ARTIST_NAME_LABEL_FORMAT", comment: "Format for artist name label"), result.artistName, result.type)
    }
    artworkImageVIew.image = UIImage(named: "Placeholder")
    if let smallURL = URL(string: result.imageSmall) {
      downloadTask = artworkImageVIew.loadImage(url: smallURL)
    }
  }

}
