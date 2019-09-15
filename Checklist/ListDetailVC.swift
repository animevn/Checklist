import UIKit

protocol ListDetailDelegate:class{
    func listDetailDidCancel(_ controller:ListDetailVC)
    func listDetail(_ controller:ListDetailVC, didFinishAdding checklist:Checklist)
    func listDetail(_ controller:ListDetailVC, didFinishEditing checklist:Checklist)
}

class ListDetailVC:UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var bnDone: UIBarButtonItem!
    @IBOutlet weak var tfInput: UITextField!
    weak var deletgate:ListDetailDelegate?
    var checklistToEdit:Checklist?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit{
            title = "Edit checklist"
            tfInput.text = checklist.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfInput.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath:IndexPath)->IndexPath?{
        return nil
    }
    
    @IBAction func cancel(){
        deletgate?.listDetailDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let checklist = checklistToEdit{
            checklist.name = tfInput.text!
            deletgate?.listDetail(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: tfInput.text!)
            deletgate?.listDetail(self, didFinishAdding: checklist)
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
