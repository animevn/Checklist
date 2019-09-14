import UIKit

class ChecklistVC: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklist", for: indexPath)
        
        
        
        let label = cell.viewWithTag(999) as! UILabel
        
        switch indexPath.row % 5{
        case 0:
            label.text = "Java is King"
        case 1:
            label.text = "Swift is just a Kotlin follower"
        case 2:
            label.text = "Apple love your $$$ hahaha"
        case 3:
            label.text = "Xcode sucks big time"
        case 4:
            label.text = "Java is King"
        default:
            label.text = "Still need Swift and Xcode though"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        if cell.accessoryType == .none{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
    }
    
    
}

