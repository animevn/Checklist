import UIKit

class ChecklistVC: UITableViewController, ItemDetailDelegate{
    
    var checklist:Checklist!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }

    override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return checklist.items.count
    }
    
    private func configureCheckmark(cell:UITableViewCell, isChecked:Bool){
        let label = cell.viewWithTag(699) as! UILabel
        label.text = isChecked ? "✓" : " "
    }
    
    private func configureCell(cell:UITableViewCell, indexPath:IndexPath){
        let label = cell.viewWithTag(999) as! UILabel
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "\(checklist.items[indexPath.row].text)"
        configureCheckmark(cell: cell, isChecked: checklist.items[indexPath.row].checked)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklist", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        checklist.items[indexPath.row].toggleChecked()
        configureCheckmark(cell: cell, isChecked: checklist.items[indexPath.row].checked)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func addItem(item:ChecklistItem){
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    //delete row
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func itemDetailDidCancel(_ controller: ItemDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetail(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem) {
        addItem(item: item)
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetail(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {

        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem"{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ItemDetailVC
            controller.delegate = self
            }else if segue.identifier == "editItem"{
                let destination = segue.destination as! UINavigationController
                let controller = destination.topViewController as! ItemDetailVC
                controller.delegate = self
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                    controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
   
}

