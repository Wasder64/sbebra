import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let categoryVC = CategoryViewController()
        let nav1 = UINavigationController(rootViewController: categoryVC)
        nav1.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "list.dash"), tag: 0)
        
        let cartVC = CartViewController()
        let nav2 = UINavigationController(rootViewController: cartVC)
        nav2.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        
        viewControllers = [nav1, nav2]
    }
}
