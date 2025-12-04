import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // 1. Эта переменная обязательна. Она хранит ссылку на главное окно приложения.
    // Если ее удалить, появится ошибка "self.window not found".
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 2. Превращаем общую "сцену" в "оконную сцену"
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 3. Создаем окно вручную
        let window = UIWindow(windowScene: windowScene)
        
        // 4. Назначаем стартовый экран.
        // MainTabController - это класс, который мы создадим в последнем файле.
        // Если он сейчас горит красным - это нормально, ошибка исчезнет, когда добавишь файл MainTabController.swift
        window.rootViewController = MainTabController()
        
        // 5. Сохраняем окно в переменную класса и делаем его видимым
        self.window = window
        window.makeKeyAndVisible()
    }

    // Остальные методы можно оставить пустыми или удалить, они не нужны для этой задачи
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}