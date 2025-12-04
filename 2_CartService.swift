import Foundation

class CartService {
    static let shared = CartService()
    
    private init() {}
    
    var items: [CartItem] = []
    
    // Добавить товар
    func addToCart(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    // Удалить позицию
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    // Изменить количество
    func updateQuantity(at index: Int, quantity: Int) {
        if quantity <= 0 {
            removeItem(at: index)
        } else {
            items[index].quantity = quantity
        }
    }
    
    // Очистить корзину
    func clearCart() {
        items.removeAll()
    }
    
    // 2.2.3 Cart Total - сумма всех позиций
    var cartTotal: Double {
        return items.reduce(0) { $0 + ($1.product.cost * Double($1.quantity)) }
    }
    
    // 2.2.4 Tax - налог 20%
    var tax: Double {
        return cartTotal * 0.20
    }
    
    // 2.2.5 Sub Total (по ТЗ это Cart Total + Tax)
    var subTotal: Double {
        return cartTotal + tax
    }
}
