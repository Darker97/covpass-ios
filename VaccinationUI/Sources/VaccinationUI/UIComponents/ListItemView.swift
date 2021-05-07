//
//  File.swift
//  
//
//  Created by Sebastian Maschinski on 06.05.21.
//

import UIKit

public class ListItemView: XibView {
    // MARK: - Properties

    @IBOutlet public var stackView: UIStackView!
    @IBOutlet public var imageView: UIImageView!
    @IBOutlet public var textLabel: UILabel!
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var internalButton: UIButton!

    var showSeperator: Bool = false {
        didSet {
            seperatorView.isHidden = showSeperator == false
        }
    }

    public var action: (() -> Void)?

    // MARK: - Lifecycle

    public override func initView() {
        super.initView()
        contentView?.layoutMargins = .init(top: .space_12, left: .space_24, bottom: .space_12, right: .space_24)
        backgroundColor = .neutralWhite
        textLabel.text = ""
        imageView.image = .chevronRight
        seperatorView.backgroundColor = .onBackground20
    }

    // MARK: - Methods

    @IBAction func didTapButton() {
        action?()
    }
}
