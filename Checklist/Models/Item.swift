import Foundation
import NotificationCenter

class Item:NSObject, NSCoding{
    
    var detail:String = ""
    var check:Bool = false
    var dueDate:Date = Date().addingTimeInterval(24 * 60 * 60)
    var remind:Bool = false
    var itemId:Int
    
    func encode(with coder: NSCoder) {
        coder.encode(detail, forKey: Constants.detail)
        coder.encode(check, forKey: Constants.check)
        coder.encode(dueDate, forKey: Constants.dueDate)
        coder.encode(remind, forKey: Constants.remind)
        coder.encode(itemId, forKey: Constants.itemId)
    }
    
    required init?(coder: NSCoder) {
        detail = coder.decodeObject(forKey: Constants.detail) as! String
        check = coder.decodeBool(forKey: Constants.check)
        dueDate = coder.decodeObject(forKey: Constants.dueDate) as! Date
        remind = coder.decodeBool(forKey: Constants.remind)
        itemId = coder.decodeInteger(forKey: Constants.itemId)
        super.init()
    }
    
    override init(){
        itemId = nextChecklistId()
        super.init()
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemId)"])
    }
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
//        removeNotification()
    }
    
    func toggleCheck(){
        check = !check
    }
    
    func scheduleNotification(){
        removeNotification()
        if remind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = detail
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(itemId)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
}












