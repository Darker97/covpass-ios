//
//  VaccinationCertificateService.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
import Keychain

public class VaccinationCertificateService {
    public init() {}

    public func save(_ certificate: VaccinationCertificateList) throws {
        let data = try JSONEncoder().encode(certificate)

        try Keychain.storePassword(data, for: KeychainConfiguration.vaccinationCertificateKey)
    }

    public func fetch() throws -> VaccinationCertificateList? {
        do {
            guard let data = try Keychain.fetchPassword(for: KeychainConfiguration.vaccinationCertificateKey) else {
                throw ApplicationError.general("Could not find certificate in Keychain")
            }
            let certificate = try JSONDecoder().decode(VaccinationCertificateList.self, from: data)
            return certificate
        } catch {
            // TODO FIX THIS
//            if error == KeychainError.fetch {
//                return nil
//            }
            return nil
            throw error
        }
    }
}
