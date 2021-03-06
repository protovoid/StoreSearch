//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Chad on 3/23/18.
//  Copyright © 2018 Chad Williams. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var search: Search!
  private var firstTime = true
  private var downloads = [URLSessionDownloadTask]()
  
  
  deinit {
    print("deinit \(self)")
    for task in downloads {
      task.cancel()
    }
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      // remove constraints from main view
      view.removeConstraints(view.constraints)
      view.translatesAutoresizingMaskIntoConstraints = true
      // remove constraints for page control
      pageControl.removeConstraints(pageControl.constraints)
      pageControl.translatesAutoresizingMaskIntoConstraints = true
      // remove constraints from scroll view
      scrollView.removeConstraints(scrollView.constraints)
      scrollView.translatesAutoresizingMaskIntoConstraints = true
      
      scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
      
      pageControl.numberOfPages = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    pageControl.frame = CGRect(x: 0,
                               y: view.frame.size.height - pageControl.frame.size.height,
                               width: view.frame.size.width,
                               height: pageControl.frame.size.height)
    
    if firstTime {
      firstTime = false
      
      switch search.state {
      case .notSearchedYet: break
      case .loading: showSpinner()
      case .noResults: showNothingFoundLabel()
      case .results(let list): tileButtons(list)
      }
    }
  }
  
  
  // MARK: - Private methods
  private func tileButtons(_ searchResults: [SearchResult]) {
    // 480 pts 3.5-inch device
    var columnsPerPage = 5
    var rowsPerPage = 3
    var itemWidth: CGFloat = 96
    var itemHeight: CGFloat = 88
    var marginX: CGFloat = 0
    var marginY: CGFloat = 20
    
    let viewWidth = scrollView.bounds.size.width
    
    switch viewWidth {
      // 4-inch device
    case 568:
      columnsPerPage = 6
      itemWidth = 94
      marginX = 2
      
      // 4.7-inch device
    case 667:
      columnsPerPage = 7
      itemWidth = 95
      itemHeight = 98
      marginX = 1
      marginY = 29
      
      // 5.5-inch device
    case 736:
      columnsPerPage = 8
      rowsPerPage = 4
      itemWidth = 92
      
    default:
      break
    }
    
    // button size
    let buttonWidth: CGFloat = 82
    let buttonHeight: CGFloat = 82
    let paddingHorizontal = (itemWidth - buttonWidth)/2
    let paddingVertical = (itemHeight - buttonHeight)/2
    
    // add buttons
    var row = 0
    var column = 0
    var x = marginX
    for (index, result) in searchResults.enumerated() {
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
      button.tag = 2000 + index
      button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      
      button.frame = CGRect(x: x + paddingHorizontal, y: marginY + CGFloat(row)*itemHeight + paddingVertical, width: buttonWidth, height: buttonHeight)
      
      scrollView.addSubview(button)
      downloadImage(for: result, andPlaceOn: button)
      
      row += 1
      if row == rowsPerPage {
        row = 0; x += itemWidth; column += 1
        
        if column == columnsPerPage {
          column = 0; x += marginX * 2
        }
      }
    }
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth, height: scrollView.bounds.size.height)
    print("Number of pages: \(numPages)")
    
    pageControl.numberOfPages = numPages
    pageControl.currentPage = 0
  }
  
  private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
    if let url = URL(string: searchResult.imageSmall) {
      let task = URLSession.shared.downloadTask(with: url)
      {
        [weak button] url, response, error in
        
        if error == nil, let url = url,
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) {
          DispatchQueue.main.async {
            if let button = button {
              button.setImage(image, for: .normal)
            }
          }
        }
      }
      task.resume()
      downloads.append(task)
    }
  }
  
  private func showSpinner() {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5, y: scrollView.bounds.midY + 0.5)
    spinner.tag = 1000
    view.addSubview(spinner)
    spinner.startAnimating()
  }
  
  private func showNothingFoundLabel() {
    let label = UILabel(frame: CGRect.zero)
    label.text = NSLocalizedString("Nothing Found", comment: "Localized: Nothing Found Label Text")
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.clear
    
    label.sizeToFit()
    
    var rect = label.frame
    rect.size.width = ceil(rect.size.width/2) * 2 // make even
    rect.size.height = ceil(rect.size.height/2) * 2 // make even
    label.frame = rect
    label.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
    view.addSubview(label)
  }
  
  // MARK: - Public Methods
  func searchResultsReceived() {
    hideSpinner()
    
    switch search.state {
    case .notSearchedYet, .loading: break
    case .noResults: showNothingFoundLabel()
    case .results(let list): tileButtons(list)
    }
  }
  
  private func hideSpinner() {
    view.viewWithTag(1000)?.removeFromSuperview()
  }
  
  
  // MARK: = Actions
  @IBAction func pageChanged(_ sender: UIPageControl) {
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
      self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
    }, completion: nil)
  }
  
  @objc func buttonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: "ShowDetail", sender: sender)
  }
    

  
    // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      if case .results(let list) = search.state {
        let detailViewController = segue.destination as! DetailViewController
        let searchResult = list[(sender as! UIButton).tag - 2000]
        detailViewController.searchResult = searchResult
        detailViewController.isPopUp = true
      }
    }
  }


}

extension LandscapeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let page = Int((scrollView.contentOffset.x + width / 2) / width)
    pageControl.currentPage = page
  }
}
