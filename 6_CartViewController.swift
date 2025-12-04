import UIKit

class CartViewController: UIViewController {
    
    // UI Элементы
    private let tableView = UITableView()
    
    // Элементы футера (делаем их свойствами класса, чтобы иметь к ним доступ для обновления текста)
    private let cartTotalLabel = UILabel()
    private let taxLabel = UILabel()
    private let subTotalLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    
    // Сам контейнер футера (серый фон)
    private let footerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cart Page"
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем данные каждый раз при входе на экран
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
    
    private func setupUI() {
        // 1. Настройка Таблицы
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        // 2. Настройка Футера (серый блок снизу)
        footerView.backgroundColor = .systemGray6
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. Настройка содержимого Футера
        setupFooterContent()
        
        // 4. КОНСТРЕЙНТЫ (Самое важное)
        NSLayoutConstraint.activate([
            // --- Таблица ---
            // Верх таблицы к Safe Area (чтобы не лезла под заголовок)
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Низ таблицы приклеиваем к верху футера
            // Таблица займет всё пространство, которое не занял футер
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            // --- Футер ---
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // !!! ИСПРАВЛЕНИЕ ЗДЕСЬ !!!
            // Привязываем низ футера к Safe Area Bottom
            // Это поднимет кнопку НАД системным TabBar'ом
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Задаем примерную высоту футера (или минимальную высоту)
            // Это нужно, чтобы таблица знала, где остановиться
            footerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
    
    private func setupFooterContent() {
        // Настройка шрифтов
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
        // Собираем всё в StackView
        let stack = UIStackView(arrangedSubviews: [
            cartTotalLabel,
            taxLabel,
            UIView(), // Просто пустой разделитель
            subTotalLabel,
            UIView(), // Еще разделитель
            doneButton
        ])
        stack.axis = .vertical
        stack.spacing = 8
        
        footerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для StackView внутри Футера
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            
            // Важно: отступ снизу внутри футера, чтобы кнопка не прилипала к краю
            stack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),
            
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleDone() {
        // Очистить корзину
        CartService.shared.clearCart()
        reloadData()
        
        // Показать алерт
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
        
        // Обработка удаления
        cell.onDelete = { [weak self] in
            CartService.shared.removeItem(at: indexPath.row)
            self?.reloadData()
        }
        
        // Обработка изменения количества
        cell.onQuantityChange = { [weak self] newQty in
            CartService.shared.updateQuantity(at: indexPath.row, quantity: newQty)
            self?.reloadData()
        }
        
        return cell
    }
    
    // Этот метод убирает пустые строки внизу таблицы, если товаров мало
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}