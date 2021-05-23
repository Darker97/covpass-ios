//
//  VaccinationDetailSceneResult.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import CovPassCommon
import Foundation

enum VaccinationDetailSceneResult {
    case didDeleteCertificate
    case showCertificatesOnOverview([ExtendedCBORWebToken])
}
