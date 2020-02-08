import UIKit

class ItemDetailController:UITableViewController{
    
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var swRemind: UISwitch!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet var tcDatePicker: UITableViewCell!
    @IBOutlet weak var dpDatePicker: UIDatePicker!
    @IBOutlet weak var bnDone: UIBarButtonItem!
    
    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func onButtonCancelPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onButtonDonePressed(_ sender: UIBarButtonItem) {
    }
}
