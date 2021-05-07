//
//  PassAppInformationSceneFactory.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit
import VaccinationUI

public struct PassAppInformationSceneFactory: SceneFactory {
    // MARK: - Properties

    let router: AppInformationRouterProtocol

    // MARK: - Lifecycle

    init(router: AppInformationRouterProtocol) {
        self.router = router
    }

    public func make() -> UIViewController {
        let viewModel = PassAppInformationViewModel(router: router)
        let viewController = AppInformationViewController(viewModel: viewModel)
        return viewController
    }
}
