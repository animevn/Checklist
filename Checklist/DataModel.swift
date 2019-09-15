import Foundation

class DataModel{
    
    var lists = [Checklist]()
    
    init(){
        loadChecklist()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
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
