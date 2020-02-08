import Foundation

class DataMode{
    var lists:[Checklist] = [Checklist]()
    var indexOfSelectedChecklist:Int{
        get{
            UserDefaults.standard.integer(forKey: "checklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "checklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    private func dataFilePath()->URL{
        let path:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("checklist.plist")
    }
    
    func save(){
        guard let data = try? NSKeyedArchiver.archivedData(
            withRootObject: lists,
            requiringSecureCoding: false) else {return}
        try? data.write(to: dataFilePath(), options: .atomic)
    }
    
    func load(){
        guard let data = try? Data(contentsOf: dataFilePath()) else {return}
        lists = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Checklist])
            ?? [Checklist]()
    }
    
    private func registerDefault(){
        let start:[String:Any] = ["checklistIndex":-1,
                                    "firstTime":true,
                                    "checklistItemId":0]
        UserDefaults.standard.register(defaults: start)
    }
    
    private func handleFirstTime(){
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        if firstTime{
            let checklist = Checklist(name: "Test")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "firstTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    init(){
        load()
        registerDefault()
        handleFirstTime()
    }
}

class func nextChecklistId()->Int{
    let itemId = UserDefaults.standard.integer(forKey: "checklistItemId")
    UserDefaults.standard.set(itemId + 1, forKey: "checklistItemId")
    UserDefaults.standard.synchronize()
    return itemId
}









