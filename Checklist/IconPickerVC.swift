import UIKit

protocol IconPickerDelegate:class{
    func iconPicker(_ picker:IconPickerVC, didPick iconName:String)
}

class IconPickerVC:UITableViewController{
    
    weak var delegate:IconPickerDelegate?
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips"
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        cell.textLabel?.text = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(self, didPick: icons[indexPath.row])
    }
    
}
