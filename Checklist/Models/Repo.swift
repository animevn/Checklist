import UserNotifications

public func requestNotification(){
    let current = UNUserNotificationCenter.current()
    current.requestAuthorization(options: [.alert, .sound]){ granted, error in
        if granted{
            print("granted")
        }else{
            print("denied")
        }
    }
}

public func testNotification(){
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = "Checklist Notification"
    content.sound = UNNotificationSound.default
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
    let request = UNNotificationRequest(identifier: "Checklist",
                                        content: content,
                                        trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

