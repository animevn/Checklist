import UIKit
import UserNotifications

protocol ItemDetailDelegate:class{
    
    func itemDetailDidCancel(_ controller:ItemDetailVC)
    func itemDetail(_ controller: ItemDetailVC, didFinishAdding item:ChecklistItem)
    func itemDetail(_ controller: ItemDetailVC, didFinishEditing item:ChecklistItem)
}

class ItemDetailVC:UITableViewController, UITextFieldDelegate{
    
    @IBOutlet var tcDuedate: UITableViewCell!
    @IBOutlet weak var dpDuedate: UIDatePicker!
    @IBOutlet weak var bnDone: UIBarButtonItem!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var lbDuedate: UILabel!
    @IBOutlet weak var swRemind: UISwitch!
    
    weak var delegate:ItemDetailDelegate?
    var itemToEdit:ChecklistItem?
    var datePickerVisible = false
    var dueDate = Date()
    
    private func showDatePicker(){
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        lbDuedate.textColor = view.tintColor
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        dpDuedate.setDate(dueDate, animated: false)
    }
    
    private func hideDatePicker(){
        if datePickerVisible{
            datePickerVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            lbDuedate.textColor = .black
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        }
    }

    private func updateDueDateLabel(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        lbDuedate.text = dateFormatter.string(from: dueDate)
    }
    
    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
        dueDate = dpDuedate.date
        updateDueDateLabel()
    }
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        tfInput.resignFirstResponder()
        if swRemind.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {
                granted, error in 
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{
            title = "Edit Item"
            tfInput.text = item.text
            bnDone.isEnabled = true
            swRemind.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfInput.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2{
            return tcDuedate
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible{
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat{
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tfInput.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerVisible{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView:UITableView,
                            indentationLevelForRowAt indexPath: IndexPath)->Int{
        
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text! as NSString
        let newText = text.replacingCharacters(in: range, with: string) as NSString
        
        bnDone.isEnabled = (newText.length > 0) ? true : false
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    @IBAction func cancel(){
        delegate?.itemDetailDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit{
            item.text = tfInput.text!
            item.shouldRemind = swRemind.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetail(self, didFinishEditing: item)
        }else{
            let item = ChecklistItem()
            item.text = tfInput.text!
            item.checked = false
            item.shouldRemind = swRemind.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetail(self, didFinishAdding: item)
        }
    }
}
