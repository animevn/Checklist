import Foundation

class Checklist:NSObject, NSCoding{
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName:String
    
    init(name:String){
        self.name = name
        iconName = "Appointments"
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    func countUnchecked()->String{
        var count = 0
        for item in items where !item.checked{
            count += 1
        }
        if items.count == 0{
            return "No items"
        }else if count == 0{
            return "All done"
        }else {
            return "\(count) remaining"
        }
    }
}
