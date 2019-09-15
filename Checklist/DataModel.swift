import Foundation

class DataModel{
    
    var lists = [Checklist]()
    var indexOfSelectedChecklist:Int{
        get{
            return UserDefaults.standard.integer(forKey: "checklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "checklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init(){
        loadChecklist()
        registerDefaults()
        handleFirstTime()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    private func registerDefaults(){
        let dictionary:[String:Any] = ["checklistIndex": -1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    private func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime{
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    
    
    private func documentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath()->URL{
        return documentsDirectory().appendingPathComponent("checklist.plist")
    }
    
    func saveChecklist(){
        print("save")
        do{
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: lists,
                requiringSecureCoding: false)
            do{
                try data.write(to: dataFilePath(), options: .atomic)
            }catch let error{
                print(error)
            }
        }catch let error{
            print(error)
        }
    }
    
    private func loadChecklist(){
        let path = dataFilePath()
        do{
            let data = try Data(contentsOf: path)
            do{
                lists = try NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(data) as! [Checklist]
            }catch let error{
                print(error)
            }
        }catch let error{
            print(error)
        }
    }
}
