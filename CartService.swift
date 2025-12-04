import Foundation

class CartService {
    static let shared = CartService()
    
    private init() {}
    
    var items: [CartItem] = []
    
    func addToCart(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func updateQuantity(at index: Int, quantity: Int) {
        if quantity <= 0 {
            removeItem(at: index)
        } else {
            items[index].quantity = quantity
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    var cartTotal: Double {
        return items.reduce(0) { $0 + ($1.product.cost * Double($1.quantity)) }
    }
    
    var tax: Double {
        return cartTotal * 0.20
    }
    
    var subTotal: Double {
        return cartTotal + tax
    }
}
