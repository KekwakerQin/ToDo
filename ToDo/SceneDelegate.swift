import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        window.rootViewController = ToDoListBuilder.build(context: context)
        
        window.makeKeyAndVisible()
    }


}

