import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.backgroundColor = .orange
        let navigation = window!.rootViewController as! UINavigationController
        let controller = navigation.viewControllers[0] as! AllListsVC
        controller.dataModel = dataModel
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]){
            granted, error in
            if granted{
                print("granted")
            }else{
                print("denied")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    private func save(){
        dataModel.saveChecklist()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        save()
    }
}

