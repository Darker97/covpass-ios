//
//  CertificatesOverviewRouter.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import PromiseKit
import Scanner
import UIKit
import CovPassCommon
import CovPassUI

class CertificatesOverviewRouter: CertificatesOverviewRouterProtocol, DialogRouterProtocol {
    // MARK: - Properties

    let sceneCoordinator: SceneCoordinator

    // MARK: - Lifecycle

    init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
    }

    // MARK: - Methods

    func showCertificates(_ certificates: [ExtendedCBORWebToken]) -> Promise<VaccinationDetailSceneResult> {
        sceneCoordinator.push(
            VaccinationDetailSceneFactory(
                router: VaccinationDetailRouter(sceneCoordinator: sceneCoordinator),
                certificates: certificates
            )
        )
    }

    func showHowToScan() -> Promise<Void> {
        sceneCoordinator.present(
            HowToScanSceneFactory(
                router: HowToScanRouter(sceneCoordinator: sceneCoordinator)
            )
        )
    }

    func scanQRCode() -> Promise<ScanResult> {
        sceneCoordinator.present(
            ScanSceneFactory(
                cameraAccessProvider: CameraAccessProvider(
                    router: DialogRouter(sceneCoordinator: sceneCoordinator)
                )
            )
        )
    }

    func showAppInformation() {
        sceneCoordinator.push(
            AppInformationSceneFactory(
                router: AppInformationRouter(sceneCoordinator: sceneCoordinator)
            )
        )
    }
}
