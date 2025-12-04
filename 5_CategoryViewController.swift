import UIKit

class CategoryViewController: UIViewController {
    
    // Данные
    private let allProducts: [Product] = [
        Product(title: "Apple", cost: 1.50, imageName: "applelogo"),
        Product(title: "Box", cost: 5.00, imageName: "cube.box"),
        Product(title: "Headphones", cost: 150.00, imageName: "headphones"),
        Product(title: "Monitor", cost: 300.00, imageName: "desktopcomputer"),
        Product(title: "Keyboard", cost: 50.00, imageName: "keyboard"),
        Product(title: "Mouse", cost: 25.00, imageName: "mouse")
    ]
    
    private var filteredProducts: [Product] = []
    
    // UI
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Category Page"
        
        filteredProducts = allProducts
        setupSearch()
        setupCollectionView()
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 48) / 2 // 2 колонки с отступами
        layout.itemSize = CGSize(width: width, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.id)
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: - CollectionView DataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.id, for: indexPath) as! ProductCell
        let product = filteredProducts[indexPath.item]
        
        cell.configure(with: product)
        
        // Обработка нажатия "Add to Cart"
        cell.didTapAdd = {
            CartService.shared.addToCart(product: product)
            // Небольшая вибрация для обратной связи
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            print("Added \(product.title) to cart")
        }
        
        return cell
    }
}

// MARK: - Search Logic
extension CategoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredProducts = allProducts
            collectionView.reloadData()
            return
        }
        
        filteredProducts = allProducts.filter { $0.title.lowercased().contains(text.lowercased()) }
        collectionView.reloadData()
    }
}
