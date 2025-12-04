import UIKit

class ProductCell: UICollectionViewCell {
    static let id = "ProductCell"
    
    var didTapAdd: (() -> Void)?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add to Cart", for: .normal)
        btn.backgroundColor = .darkGray
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func handleAdd() {
        didTapAdd?()
    }
    
    func configure(with product: Product) {
        imageView.image = UIImage(systemName: product.imageName)
        nameLabel.text = product.title
        costLabel.text = String(format: "$%.2f", product.cost)
    }
    
    private func setupLayout() {
        [imageView, nameLabel, costLabel, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            addButton.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
