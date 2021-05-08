//
//  ValidatorRouter.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import PromiseKit
import Scanner
import UIKit
import VaccinationCommon
import VaccinationUI

class ValidatorRouter: ValidatorRouterProtocol {
    // MARK: - Properties

    let sceneCoordinator: SceneCoordinator

    // MARK: - Lifecycle

    init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
    }

    // MARK: - Methods

    func scanQRCode() -> Promise<ScanResult> {
        sceneCoordinator.present(
            ScanSceneFactory(
                cameraAccessProvider: CameraAccessProvider(
                    router: DialogRouter(sceneCoordinator: sceneCoordinator)
                )
            )
        )
    }

    func showCertificate(_ certificate: CBORWebToken?) {
        sceneCoordinator.present(
            ValidationResultSceneFactory(
                router: ValidationResultRouter(sceneCoordinator: sceneCoordinator),
                certificate: certificate
            )
        )
    }

    func showAppInformation() {
        sceneCoordinator.push(
            ValidatorAppInformationSceneFactory(
                router: AppInformationRouter(sceneCoordinator: sceneCoordinator)
            )
        )
    }
}
