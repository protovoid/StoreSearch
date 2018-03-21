//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Chad on 3/19/18.
//  Copyright © 2018 Chad Williams. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    containerView!.insertSubview(dimmingView, at: 0)
    
    // animate background gradient view
    dimmingView.alpha = 0
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { _ in
        self.dimmingView.alpha = 1
      }, completion: nil)
    }
  }
  
  override func dismissalTransitionWillBegin() {
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { _ in
        self.dimmingView.alpha = 0
      }, completion: nil)
    }
  }
  
  
}
