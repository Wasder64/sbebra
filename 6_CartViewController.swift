import UIKit

class CartViewController: UIViewController {
    
    private let tableView = UITableView()
    
    // UI для футера (Итоги)
    private let cartTotalLabel = UILabel()
    private let taxLabel = UILabel()
    private let subTotalLabel = UILabel() // По задаче это CartTotal + Tax
    private let doneButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cart Page"
        
        setupTableView()
        setupFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем данные каждый раз, когда открываем вкладку
        reloadData()
    }
    
    private func reloadData() {
        tableView.reloadData()
        updateTotals()
    }
    
    private func updateTotals() {
        let service = CartService.shared
        cartTotalLabel.text = String(format: "Cart Total: $%.2f", service.cartTotal)
        taxLabel.text = String(format: "Tax (20%%): $%.2f", service.tax)
        subTotalLabel.text = String(format: "Sub Total: $%.2f", service.subTotal)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        // Оставляем место внизу для футера с итогами
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }
    
    private func setupFooter() {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray6
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка лейблов
        [cartTotalLabel, taxLabel, subTotalLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textAlignment = .right
        }
        subTotalLabel.font = .boldSystemFont(ofSize: 18)
        
        // Настройка кнопки Done
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .black
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [cartTotalLabel, taxLabel, UIView(), subTotalLabel, UIView(), doneButton])
        stack.axis = .vertical
        stack.spacing = 8
        footerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleDone() {
        // Очистить корзину
        CartService.shared.clearCart()
        reloadData()
        
        // Показать алерт
        // Примечание: "Successed" грамматически неверно, правильно "Succeeded" или "Success", 
        // но в коде оставляю как в ТЗ.
        let alert = UIAlertController(title: "Successed", message: "Your order has been placed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartService.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.id, for: indexPath) as! CartCell
        let item = CartService.shared.items[indexPath.row]
        
        cell.configure(item: item)
        
        // Удаление
        cell.onDelete = { [weak self] in
            CartService.shared.removeItem(at: indexPath.row)
            self?.reloadData()
        }
        
        // Степпер
        cell.onQuantityChange = { [weak self] newQty in
            CartService.shared.updateQuantity(at: indexPath.row, quantity: newQty)
            self?.reloadData()
        }
        
        return cell
    }
}
