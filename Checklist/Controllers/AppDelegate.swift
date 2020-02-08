import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataModel = DataModel()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?)->Bool{
        print("app did load")
        let navigation = window?.rootViewController as! UINavigationController
        let controller = navigation.viewControllers[0] as! AllListController
        controller.dataModel = dataModel
        requestNotification()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("app did become active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       print("app will become inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
        dataModel.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       print("app will become active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("app did terminate")
        dataModel.save()
    }
}

