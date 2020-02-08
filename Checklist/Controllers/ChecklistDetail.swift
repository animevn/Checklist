import UIKit

protocol ChecklistDetailDelegate:class{
    func cancel()
    func finishAdding(checklist:Checklist)
    func finishEditing(checklist:Checklist)
}

class ChecklistDetailController:UITableViewController{
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbIcon: UILabel!
    @IBOutlet weak var bnDone: UIBarButtonItem!
    
    weak var delegate:ChecklistDetailDelegate?
    var checklistToEdit:Checklist?
    var iconName = "Folder"
    
    private func updateChecklist(){
        if let checklist = checklistToEdit{
            title = "Edit Checklist"
            tfName.text = checklist.name
            iconName = checklist.iconName
            bnDone.isEnabled = true
        }
        ivIcon.image = UIImage(named: iconName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.delegate = self
        updateChecklist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tfName.becomeFirstResponder()
    }
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pick_icon"{
            let destination = segue.destination as? IconPickerController
            destination?.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueIconPicker, sender: self)
    }
    
    @IBAction func onButtonCancelPressed(_ sender: UIBarButtonItem) {
        delegate?.cancel()
    }
    
    @IBAction func onButtonDonePressed(_ sender: UIBarButtonItem) {
        if let checklist = checklistToEdit{
            checklist.name = tfName.text!
            checklist.iconName = iconName
            delegate?.finishEditing(checklist: checklist)
        }else{
            let checklist = Checklist(name: tfName.text!)
            checklist.iconName = iconName
            delegate?.finishAdding(checklist: checklist)
        }
    }
}

extension ChecklistDetailController:IconPickerDelegate{
    func onIconPicked(iconName: String) {
        func onIconPicked(iconName: String) {
            self.iconName = iconName
            ivIcon.image = UIImage(named: iconName)
            lbIcon.text = iconName
            if let text = tfName.text, text.count > 0{
                bnDone.isEnabled = true
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}

extension ChecklistDetailController:UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let newText = text.replacingCharacters(in: range, with: string) as NSString
        bnDone.isEnabled = (newText.length > 0) ? true : false
        return true
    }
}












