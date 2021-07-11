//
//  RuleCheckSceneFactory.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import CovPassUI
import PromiseKit
import UIKit

struct RuleCheckSceneFactory: ResolvableSceneFactory {
    // MARK: - Properties

    let router: RuleCheckRouterProtocol

    // MARK: - Lifecycle

    init(router: RuleCheckRouterProtocol) {
        self.router = router
    }

    func make(resolvable: Resolver<Void>) -> UIViewController {
        let viewModel = RuleCheckViewModel(
            router: router,
            resolvable: resolvable
        )
        return RuleCheckViewController(viewModel: viewModel)
    }
}
