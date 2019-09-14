import Foundation

//subclass NSObject will be Equatable also
class ChecklistItem{
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
}
