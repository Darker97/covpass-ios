//
//  VaccinationDelegate.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CovPassCommon

protocol VaccinationViewDelegate: AnyObject {
    func vaccinationViewDidPressDelete(_ vaccination: Vaccination)
    func vaccinationViewDidPressShowQRCode(_ vaccination: Vaccination)
}
