//
//  EmployeeCell.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 30.10.2022.
//

import UIKit

final class EmployeeCell: UITableViewCell {
    static let id = String(describing: EmployeeCell.self)
    
    // MARK: - Constraint constants
    
    private let padding: CGFloat = 10
    private let topPadding: CGFloat = 5
    
    // MARK: - UI elements
    
    private let containerView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: R.Strings.avatar)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.name
        label.font = R.Fonts.makeFont(weight: .regular)
        label.textColor = .systemBlue
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.phone
        label.font = R.Fonts.makeFont(weight: .light)
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.skills
        label.font = R.Fonts.makeFont(weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupContainer()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Public

extension EmployeeCell {
    public func configure(with model: Employee) {
        nameLabel.text = R.Strings.name + model.phoneNumber
        phoneLabel.text = R.Strings.phone + model.phoneNumber
        skillsLabel.text = R.Strings.skills + model.skills.joined(separator: R.Strings.separator)
    }
}

//MARK: - Private

private extension EmployeeCell {
    func setupContainer() {
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = (R.Numbers.rowHeight - (padding * 2)) / 2
        containerView.layer.masksToBounds = true
        containerView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding
            )
        )
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(skillsLabel)
    }
    
    func setupLayout() {
        containerView.prepareForAutoLayout()
        avatarImageView.prepareForAutoLayout()
        stackView.prepareForAutoLayout()
        
        let constraints = [
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -topPadding)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

