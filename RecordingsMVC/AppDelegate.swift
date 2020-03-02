import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          // Override point for customization after application launch.
          let splitViewController = window?.rootViewController as? UISplitViewController
          splitViewController?.delegate = self
          let leftNav = splitViewController?.viewControllers.first as? UINavigationController
          let folder = leftNav?.viewControllers.first as? FolderViewController
          if let rootvc = folder {
            Store.createFloder(folderName: .rootFolderName, path: .rootPath)
            let rootFolder = Folder(name: .rootFolderName, path: .rootPath)
            rootvc.folder = rootFolder
          }
        
          return true
      }
      
      func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
          return true
      }

}

