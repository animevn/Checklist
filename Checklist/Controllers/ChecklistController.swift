import UIKit

class ChecklistController:UITableViewController{
    
    var checklist:Checklist!
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueAddItem{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ItemDetailController
            controller.delegate = self
            controller.itemToEdit = nil
        }
        
        if segue.identifier == Constants.segueShowItem{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ItemDetailController
            controller.delegate = self
            controller.itemToEdit = nil
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}

extension ChecklistController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checklist.items.count
    }
    
    private func configureCheckmark(cell:UITableViewCell, item:Item){
        let label = cell.viewWithTag(19) as! UILabel
        label.text = item.check ? "✓" : " "
        label.textColor = view.tintColor
    }
    
    private func configureCell(cell:UITableViewCell, indexPath:IndexPath){
        let label = cell.viewWithTag(29) as! UILabel
        let item = checklist.items[indexPath.row]
        label.text = "\(item.itemId) | \(item.detail)"
        configureCheckmark(cell: cell, item: item)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.checklistCell,
                                                 for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let item = checklist.items[indexPath.row]
        item.toggleCheck()
        configureCheckmark(cell: cell, item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChecklistController:ItemDetailDelegate{
    
    func cancel() {
        dismiss(animated: true)
    }
    
    func finishAdding(item: Item) {
        checklist.items.append(item)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func finishEditing(item: Item) {
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    
    
}

