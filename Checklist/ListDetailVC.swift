import UIKit

protocol ListDetailDelegate:class{
    func listDetailDidCancel(_ controller:ListDetailVC)
    func listDetail(_ controller:ListDetailVC, didFinishAdding checklist:Checklist)
    func listDetail(_ controller:ListDetailVC, didFinishEditing checklist:Checklist)
}

class ListDetailVC:UITableViewController, UITextFieldDelegate, IconPickerDelegate{
    
    
    
    @IBOutlet weak var bnDone: UIBarButtonItem!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var ivChecklist: UIImageView!
    weak var deletgate:ListDetailDelegate?
    var checklistToEdit:Checklist?
    var iconName:String = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit{
            title = "Edit checklist"
            tfInput.text = checklist.name
            iconName = checklist.iconName
            bnDone.isEnabled = true
        }
        ivChecklist.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfInput.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath:IndexPath)->IndexPath?{
        if indexPath.section == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    @IBAction func cancel(){
        deletgate?.listDetailDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let checklist = checklistToEdit{
            checklist.name = tfInput.text!
            checklist.iconName = iconName
            deletgate?.listDetail(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: tfInput.text!)
            checklist.iconName = iconName
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickIcon"{
            let destination = segue.destination as! IconPickerVC
            destination.delegate = self
        }
    }
    
    func iconPicker(_ picker: IconPickerVC, didPick iconName: String) {
        self.iconName = iconName
        ivChecklist.image = UIImage(named: iconName)
        tfInput.text = iconName
        bnDone.isEnabled = true
        navigationController?.popViewController(animated: true)
    }
    
}
