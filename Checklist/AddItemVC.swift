import UIKit

protocol AddItemViewControllerDelegate: class{
    func addItemViewControllerDidCancel(_ controller:AddItemVC)
    func addItemViewController(_ controller: AddItemVC, didFinishAdding item:ChecklistItem)
}

class AddItemVC:UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var bnDone: UIBarButtonItem!
    @IBOutlet weak var tfInput: UITextField!
    weak var delegate:AddItemViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfInput.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func cancel(){
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        let item = ChecklistItem()
        item.text = tfInput.text!
        item.checked = false
        
        delegate?.addItemViewController(self, didFinishAdding: item)
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
