//
//  OnboardingPageViewModel.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit

public enum OnboardingPageViewModelType: CaseIterable {
    case page1
    case page2
    case page3
}

public class OnboardingPageViewModel {
    var type: OnboardingPageViewModelType

    public init(type: OnboardingPageViewModelType) {
        self.type = type
    }

    var image: UIImage? {
        switch type {
        case .page1:
            return UIImage(named: UIConstants.IconName.OnboardingScreen1, in: UIConstants.bundle, compatibleWith: nil)
        case .page2:
            return UIImage(named: UIConstants.IconName.OnboardingScreen2, in: UIConstants.bundle, compatibleWith: nil)
        case .page3:
            return UIImage(named: UIConstants.IconName.OnboardingScreen3, in: UIConstants.bundle, compatibleWith: nil)
        }
    }

    var title: String {
        switch type {
        case .page1:
            return "vaccination_first_onboarding_page_title".localized
        case .page2:
            return "vaccination_second_onboarding_page_title".localized
        case .page3:
            return "vaccination_third_onboarding_page_title".localized
        }
    }

    var info: String {
        switch type {
        case .page1:
            return "vaccination_first_onboarding_page_message".localized
        case .page2:
            return "vaccination_second_onboarding_page_message".localized
        case .page3:
            return "vaccination_third_onboarding_page_message".localized
        }
    }

    // MARK: - Settings

    var imageAspectRatio: CGFloat { 375 / 220 }
    var imageWidth: CGFloat { UIScreen.main.bounds.width }
    var imageHeight: CGFloat { imageWidth / imageAspectRatio }
    var imageContentMode: UIView.ContentMode { .scaleAspectFit }
    var headlineFont: UIFont { UIConstants.Font.onboardingHeadlineFont }
    var headlineColor: UIColor { .black }
    var paragraphBodyFont: UIFont { UIConstants.Font.regularLarger }
    var backgroundColor: UIColor { UIConstants.BrandColor.backgroundPrimary }
}

