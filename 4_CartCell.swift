import UIKit

class CartCell: UITableViewCell {
    static let id = "CartCell"
    
    var onDelete: (() -> Void)?
    var onQuantityChange: ((Int) -> Void)?
    
    private var currentQty: Int = 1
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 16)
        return l
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .gray
        return l
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .red
        btn.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return btn
    }()
    
    private let quantityLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.layer.borderWidth = 1
        l.layer.borderColor = UIColor.lightGray.cgColor
        l.layer.cornerRadius = 4
        return l
    }()
    
    private lazy var stepper: UIStepper = {
        let s = UIStepper()
        s.minimumValue = 0
        s.addTarget(self, action: #selector(handleStepper), for: .valueChanged)
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(item: CartItem) {
        productImageView.image = UIImage(systemName: item.product.imageName)
        nameLabel.text = item.product.title
        priceLabel.text = String(format: "$%.2f", item.product.cost)
        
        currentQty = item.quantity
        quantityLabel.text = "\(currentQty)"
        stepper.value = Double(currentQty)
    }
    
    @objc private func handleDelete() {
        onDelete?()
    }
    
    @objc private func handleStepper(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        onQuantityChange?(newValue)
    }
    
    private func setupLayout() {
        [productImageView, nameLabel, priceLabel, deleteButton, quantityLabel, stepper].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepper.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 8),
            stepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            quantityLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -8),
            quantityLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),
            quantityLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
