//
//  CertificateDetailViewModel.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import PromiseKit
import UIKit
import CovPassCommon
import CovPassUI
import PromiseKit
import UIKit

class CertificateDetailViewModel: CertificateDetailViewModelProtocol {
    // MARK: - Properties

    weak var delegate: ViewModelDelegate?
    var router: CertificateDetailRouterProtocol
    private let repository: VaccinationRepositoryProtocol
    private var certificates: [ExtendedCBORWebToken]
    private let resolver: Resolver<CertificateDetailSceneResult>?
    private var isFavorite = false

    var fullImmunization: Bool {
        certificates.map { $0.vaccinationCertificate.hcert.dgc.v?.first?.fullImmunization ?? false }.first(where: { $0 }) ?? false
    }

    var favoriteIcon: UIImage? {
        isFavorite ? .starFull : .starPartial
    }

    var name: String {
        certificates.first?.vaccinationCertificate.hcert.dgc.nam.fullName ?? ""
    }

    var birthDate: String {
        guard let date = certificates.first?.vaccinationCertificate.hcert.dgc.dob else { return "" }
        return DateUtils.displayDateFormatter.string(from: date)
    }

    var immunizationIcon: UIImage? {
        // TODO fix first cert
        if certificates.first?.vaccinationCertificate.hcert.dgc.r != nil {
            return .statusFull
        }
        if certificates.first?.vaccinationCertificate.hcert.dgc.t != nil {
            return .statusFull
        }
        return fullImmunization ? .statusFull : .statusPartial
    }

    var immunizationTitle: String {
        // TODO fix first cert
        if let r = certificates.first?.vaccinationCertificate.hcert.dgc.r?.first {
            if Date() < r.df {
                return String(format: "recovery_certificate_overview_valid_from_title".localized, DateUtils.displayDateFormatter.string(from: r.df))
            }
            return String(format: "recovery_certificate_overview_valid_until_title".localized, DateUtils.displayDateFormatter.string(from: r.du))
        }
        if let t = certificates.first?.vaccinationCertificate.hcert.dgc.t?.first {
            if t.isPCR {
                return String(format: "pcr_test_certificate_overview_title".localized, DateUtils.displayDateFormatter.string(from: t.sc))
            }
            return String(format: "test_certificate_overview_title".localized, DateUtils.displayDateFormatter.string(from: t.sc))
        }
        guard let cert = certificates.sorted(by: { c, _ in c.vaccinationCertificate.hcert.dgc.v?.first?.fullImmunization ?? false }).first?.vaccinationCertificate.hcert.dgc.v?.first else {
            return ""
        }
        if !fullImmunization {
            return String(format: "vaccination_certificate_overview_incomplete_title".localized, 1, 2)
        }
        if cert.fullImmunizationValid {
            return "vaccination_start_screen_qrcode_complete_protection_subtitle".localized
        } else if let date = cert.fullImmunizationValidFrom, fullImmunization {
            return String(format: "vaccination_certificate_overview_complete_title".localized, DateUtils.displayDateFormatter.string(from: date))
        }

        return String(format: "vaccination_certificate_overview_incomplete_title".localized, 1, 2)
    }

    var immunizationBody: String {
        fullImmunization ?
            "vaccination_certificate_detail_view_complete_message".localized :
            "vaccination_certificate_detail_view_incomplete_message".localized
    }

    var immunizationButton: String {
        fullImmunization ?
            "vaccination_certificate_detail_view_complete_action_button_title".localized :
            "vaccination_certificate_detail_view_incomplete_action_button_title".localized
    }

    var items: [CertificateItem] {
        certificates
            .reversed()
            .compactMap({ cert in
                let active = true
                var vm: CertificateItemViewModel?
                if cert.vaccinationCertificate.hcert.dgc.r != nil {
                    vm = RecoveryCertificateItemViewModel(cert, active: active)
                }
                if cert.vaccinationCertificate.hcert.dgc.t != nil {
                    vm = TestCertificateItemViewModel(cert, active: active)
                }
                if cert.vaccinationCertificate.hcert.dgc.v != nil {
                    vm = VaccinationCertificateItemViewModel(cert, active: active)
                }
                if vm == nil {
                    return nil
                }
                return CertificateItem(viewModel: vm!, action: {
                    self.router.showDetail(for: cert).done({
                        self.resolver?.fulfill($0)
                    }).cauterize()
                })
            })
    }

    // MARK: - Lifecyle

    init(
        router: CertificateDetailRouterProtocol,
        repository: VaccinationRepositoryProtocol,
        certificates: [ExtendedCBORWebToken],
        resolvable: Resolver<CertificateDetailSceneResult>?
    ) {
        self.router = router
        self.repository = repository
        self.certificates = certificates
        resolver = resolvable
    }

    // MARK: - Methods

    func refresh() {
        refreshFavoriteState()
    }

    func immunizationButtonTapped() {
        showCertificatesOnOverview()
    }

    func toggleFavorite() {
        guard let id = self.certificates.first?.vaccinationCertificate.hcert.dgc.v?.first?.ci else {
            self.showErrorDialog()
            return
        }
        firstly {
            repository.toggleFavoriteStateForCertificateWithIdentifier(id)
        }
        .get { isFavorite in
            self.isFavorite = isFavorite
        }
        .done { _ in
            self.delegate?.viewModelDidUpdate()
        }
        .catch { _ in
            self.showErrorDialog()
        }
    }

    private func refreshFavoriteState() {
        firstly {
            repository.favoriteStateForCertificates(certificates)
        }
        .get { isFavorite in
            self.isFavorite = isFavorite
        }
        .done { _ in
            self.delegate?.viewModelDidUpdate()
        }
        .catch { _ in
            self.showErrorDialog()
        }
    }

    private func showErrorDialog() {
        router.showUnexpectedErrorDialog()
    }

    private func showCertificatesOnOverview() {
        resolver?.fulfill(.showCertificatesOnOverview(certificates))
    }
}
