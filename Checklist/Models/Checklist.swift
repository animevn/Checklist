import Foundation

class Checklist:NSObject, NSCoding{
    
    var name:String = ""
    var items:[Item] = [Item]()
    var iconName:String
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    init(name:String){
        self.name = name
        iconName = "Appointments"
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(items, forKey: "items")
        coder.encode(iconName, forKey: "iconName")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        items = coder.decodeObject(forKey: "items") as! [Item]
        iconName = coder.decodeObject(forKey: "iconName") as! String
    }
    
    func countNotChecked()->String{
        var count:Int = 0
        for item in items where !item.check {count += 1}
        if items.count == 0{
            return "No items"
        }else if count == 0{
            return "All done"
        }else{
            return "\(count) item(s) remains"
        }
    }
}
