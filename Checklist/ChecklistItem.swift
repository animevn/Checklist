import Foundation

class ChecklistItem:NSObject, NSCoding{
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemId:Int
    
    override init() {
        itemId = DataModel.nextChecklistItemId()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemId, forKey: "ItemId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemId = aDecoder.decodeInteger(forKey: "ItemId")
        super.init()
    }
    
    func toggleChecked(){
        checked = !checked
    }
}
