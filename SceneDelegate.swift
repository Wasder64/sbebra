func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = MainTabController() // Мы создадим этот контроллер позже
    self.window = window
    window.makeKeyAndVisible()
}

// Заменяем на это