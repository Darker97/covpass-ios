//
//  PopupRouter.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
import UIKit
import VaccinationUI
import BottomPopup
import Scanner

public class PopupRouter {
    
    // MARK: - Init
    
    public init() {}
}

// MARK: - Router

extension PopupRouter: Popup {
    
    public func presentPopup(onTopOf viewController: UIViewController) {
        let popupVC = ProofPopupViewController.createFromStoryboard()
        popupVC.popupDelegate = self
        popupVC.viewModel = ProofPopupViewModel()
//        popupVC.router = ScanPopupRouter()
        viewController.present(popupVC, animated: true, completion: nil)
    }
}

// MARK: - BottomPopupDelegate

extension PopupRouter: BottomPopupDelegate {
    public func bottomPopupViewLoaded(){}
    public func bottomPopupWillAppear(){}
    public func bottomPopupDidAppear(){}
    public func bottomPopupWillDismiss(){}
    public func bottomPopupDidDismiss(){}
    public func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat){}
}
