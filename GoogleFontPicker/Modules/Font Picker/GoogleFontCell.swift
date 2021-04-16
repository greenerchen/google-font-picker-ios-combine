//
//  GoogleFontCell.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/16.
//

import UIKit

class GoogleFontCell: UICollectionViewCell {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func reuseId() -> String {
        return "GoogleFontCell"
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        previewLabel.text = ""
        nameLabel.font = .systemFont(ofSize: 10)
        previewLabel.font = .systemFont(ofSize: 34)
    }
    
    // MARK: - Properties
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "bookmark.circle.fill"))
        icon.tintColor = .systemTeal
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: - Setup UI
extension GoogleFontCell {
    private func setupBackgroundView() {
        let outlinedView = UIView(frame: bounds)
        outlinedView.layer.borderWidth = 0.3
        outlinedView.layer.borderColor = UIColor.black.cgColor
        outlinedView.layer.cornerRadius = 5
        outlinedView.clipsToBounds = true
        backgroundView = outlinedView
        let outlinedView2 = UIView(frame: bounds)
        outlinedView2.layer.borderWidth = 1.5
        outlinedView2.layer.borderColor = UIColor.black.cgColor
        outlinedView2.layer.cornerRadius = 5
        outlinedView2.clipsToBounds = true
        selectedBackgroundView = outlinedView2
    }
    
    private func setupUI() {
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(previewLabel)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -4),
            icon.widthAnchor.constraint(equalToConstant: 16),
            icon.heightAnchor.constraint(equalToConstant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: icon.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            previewLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 4),
            previewLabel.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
            previewLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            previewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    
}
