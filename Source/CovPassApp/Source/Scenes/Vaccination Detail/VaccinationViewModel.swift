//
//  VaccinationViewModel.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CovPassCommon
import CovPassUI
import PromiseKit

struct VaccinationViewModel {
    // MARK: - Properties

    private var token: ExtendedCBORWebToken
    private var certificate: DigitalGreenCertificate { token.vaccinationCertificate.hcert.dgc }
    private var vaccination: Vaccination? { certificate.v.first }
    private let repository: VaccinationRepositoryProtocol
    private let delegate: VaccinationDelegate?
    private let router: VactinationViewRouterProtocol

    var headline: String {
        let number = vaccination?.dn ?? 0
        let total = vaccination?.sd ?? 0
        return String(format: "vaccination_certificate_detail_view_vaccination_title".localized, number, total)
    }

    var date: String {
        guard let occurrence = vaccination?.dt else { return "" }
        return DateUtils.displayDateFormatter.string(from: occurrence)
    }

    var vaccine: String {
        vaccination?.map(key: vaccination?.mp, from: Bundle.commonBundle.url(forResource: "vaccine-medicinal-product", withExtension: "json")) ?? vaccination?.mp ?? ""
    }

    var manufacturer: String {
        vaccination?.map(key: vaccination?.ma, from: Bundle.commonBundle.url(forResource: "vaccine-mah-manf", withExtension: "json")) ?? vaccination?.ma ?? ""
    }

    var vaccineCode: String {
        vaccination?.map(key: vaccination?.vp, from: Bundle.commonBundle.url(forResource: "vaccine-prophylaxis", withExtension: "json")) ?? vaccination?.vp ?? ""
    }

    var fullVaccineProduct: String {
        "\(vaccineCode)(\(vaccine))"
    }

    var issuer: String {
        vaccination?.is ?? ""
    }

    var country: String {
        vaccination?.map(key: vaccination?.co, from: Bundle.commonBundle.url(forResource: "country", withExtension: "json")) ?? vaccination?.co ?? ""
    }

    var uvci: String {
        vaccination?.ci ?? ""
    }

    // MARK: - Lifecycle

    init(token: ExtendedCBORWebToken,
         repository: VaccinationRepositoryProtocol,
         delegate: VaccinationDelegate?,
         router: VactinationViewRouterProtocol) {
        self.token = token
        self.repository = repository
        self.delegate = delegate
        self.router = router
    }

    func delete() {
        self.delegate?.showDeleteDialog().then {
            self.repository.getVaccinationCertificateList()
        }.then { list -> Promise<VaccinationCertificateList> in
            var certList = list
            certList.certificates.removeAll(where: { cert in
                if cert.vaccinationCertificate.hcert.dgc == self.certificate {
                    return true
                }
                return false
            })
            return Promise.value(certList)
        }
        .then { list in
            self.repository.saveVaccinationCertificateList(list).asVoid()
        }.done {
            self.delegate?.didDeleteCertificate()
        }
        .catch { error in
            self.delegate?.updateDidFailWithError(error)
        }
    }
    
    func showCertificate() {
        firstly {
            router.showCertificate(for: token)
        }.catch { error in
            self.delegate?.updateDidFailWithError(error)
        }
    }
}
