import UIKit

// 1) Product Structure
struct Product {
    let id = UUID()
    let title: String
    let cost: Double
    let imageName: String // Будем использовать системные иконки SF Symbols
}

// Модель для элемента корзины
struct CartItem {
    let product: Product
    var quantity: Int
}
