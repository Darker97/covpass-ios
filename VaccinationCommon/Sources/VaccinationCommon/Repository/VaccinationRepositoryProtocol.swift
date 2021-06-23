//
//  VaccinationRepositoryProtocol.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
import Keychain
import PromiseKit

public protocol VaccinationRepositoryProtocol {
    /// Return the vaccination certificate list
    func getVaccinationCertificateList() -> Promise<VaccinationCertificateList>

    /// Save the vaccination certificate list
    func saveVaccinationCertificateList(_ certificateList: VaccinationCertificateList) -> Promise<VaccinationCertificateList>

    /// Refreshes the local validation CA
    func refreshValidationCA() -> Promise<Void>

    /// scanVaccinationCertificate validates the given QR code, parses it, and returns everything as an ExtendedCBORWebToken.
    ///
    /// If an error occurs, the method will not return a certificate but an error
    ///
    /// - USED BY VaccinationPass App
    func scanVaccinationCertificate(_ data: String) -> Promise<ExtendedCBORWebToken>

    /// checkVaccinationCertificate validates the given QR code and returns the vaccinatino certificate when it's valid, otherwise an error
    ///
    /// - USED BY VaccinationValidator App
    func checkVaccinationCertificate(_ data: String) -> Promise<CBORWebToken>
}
