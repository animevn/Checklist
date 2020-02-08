import UIKit
import UserNotifications

protocol ItemDetailDelegate:class{
    func cancel()
    func finishAdding(item:Item)
    func finishEditing(item:Item)
}

class ItemDetailController:UITableViewController{
    
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var swRemind: UISwitch!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet var tcDatePicker: UITableViewCell!
    @IBOutlet weak var dpDatePicker: UIDatePicker!
    @IBOutlet weak var bnDone: UIBarButtonItem!
    
    weak var delegate:ItemDetailDelegate?
    var itemToEdit:Item?
    var datePickerVisible = false
    var dueDate:Date = Date().addingTimeInterval(24 * 60 * 60)
    
    private func updateLableDueDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        lbDueDate.text = dateFormatter.string(from: dueDate)
    }

    private func updateItem(){
        if let item = itemToEdit{
            title = Constants.editItem
            tfDetail.text = item.detail
            bnDone.isEnabled = true
            swRemind.isOn = item.remind
            dueDate = item.dueDate
        }
        updateLableDueDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfDetail.delegate = self
        updateItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfDetail.becomeFirstResponder()
    }
    
    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateLableDueDate()
    }
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        tfDetail.resignFirstResponder()
        if swRemind.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]){_,_ in}
        }
    }
    
    @IBAction func onButtonCancelPressed(_ sender: UIBarButtonItem) {
        delegate?.cancel()
    }
    
    @IBAction func onButtonDonePressed(_ sender: UIBarButtonItem) {
        if let item = itemToEdit{
            item.detail = tfDetail.text!
            item.remind = swRemind.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.finishEditing(item: item)
        }else{
            let item = Item()
            item.detail = tfDetail.text!
            item.remind = swRemind.isOn
            item.dueDate = dueDate
            item.check = false
            item.scheduleNotification()
            delegate?.finishAdding(item: item)
        }
    }
}

extension ItemDetailController{
    
    private func showDatePicker(){
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        lbDueDate.textColor = view.tintColor
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        dpDatePicker.setDate(dueDate, animated: true)
    }
    
    private func hideDatePicker(){
        tfDetail.delegate = self
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            lbDueDate.textColor = .black
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            return tcDatePicker
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tfDetail.resignFirstResponder()
        if indexPath.row == 1 && indexPath.section == 1{
            if !datePickerVisible{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    //two of these is needed for show or hide tcDuedate
    override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat{
        if indexPath.section == 1 && indexPath.row == 2{
            return 250
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
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
    
    //not sure if this one for what reason :D
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
}

extension ItemDetailController:UITextFieldDelegate{
    
    //hide date picker when start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    //only show button Done when text changed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {return false}
        guard let newText = text.replacingCharacters(in: range, with: string)
            as NSString? else {return false}
        bnDone.isEnabled = (newText.length > 0) ? true : false
        return true
    }
}

