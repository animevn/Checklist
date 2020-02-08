import UIKit

protocol IconPickerDelegate:class {
    func onIconPicked(iconName:String)
}

class IconPickerController:UITableViewController{
    
    weak var delegate:IconPickerDelegate?

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.iconNames.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconPickerCell,
                                                 for: indexPath)
        cell.textLabel?.text = Constants.iconNames[indexPath.row]
        cell.imageView?.image = UIImage(named: Constants.iconNames[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onIconPicked(iconName: Constants.iconNames[indexPath.row])
    }
    
}
