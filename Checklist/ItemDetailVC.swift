import UIKit

protocol ItemDetailDelegate: class{
    
    func itemDetailDidCancel(_ controller:ItemDetailVC)
    func itemDetail(_ controller: ItemDetailVC, didFinishAdding item:ChecklistItem)
    func itemDetail(_ controller: ItemDetailVC, didFinishEditing item:ChecklistItem)
}

class ItemDetailVC:UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var bnDone: UIBarButtonItem!
    @IBOutlet weak var tfInput: UITextField!
    weak var delegate:ItemDetailDelegate?
    var itemToEdit:ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{
            title = "Edit Item"
            tfInput.text = item.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfInput.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func cancel(){
        delegate?.itemDetailDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit{
            item.text = tfInput.text!
            delegate?.itemDetail(self, didFinishEditing: item)
        }else{
            let item = ChecklistItem()
            item.text = tfInput.text!
            item.checked = false
            delegate?.itemDetail(self, didFinishAdding: item)
        }
       
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text! as NSString
        let newText = text.replacingCharacters(in: range, with: string) as NSString
        
        bnDone.isEnabled = (newText.length > 0) ? true : false

        return true
    }
    
}
