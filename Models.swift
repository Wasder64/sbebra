import UIKit

struct Product {
    let id = UUID()
    let title: String
    let cost: Double
    let imageName: String
}

struct CartItem {
    let product: Product
    var quantity: Int
}
