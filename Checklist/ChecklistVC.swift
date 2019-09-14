import UIKit

class ChecklistVC: UITableViewController {
    
    private var items:[ChecklistItem]

    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Java is King"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Swift is just a Kotlin follower"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Apple love your $$$ hahaha"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Xcode sucks big time"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Still need Swift and Xcode though"
        row4item.checked = false
        items.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    private func configureCell(cell:UITableViewCell, indexPath:IndexPath){
        let label = cell.viewWithTag(999) as! UILabel
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "\(items[indexPath.row].text)"
        configureCheckmark(cell: cell, isChecked: items[indexPath.row].checked)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklist", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCheckmark(cell:UITableViewCell, isChecked:Bool){
        cell.accessoryType = isChecked ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        items[indexPath.row].toggleChecked()
        configureCheckmark(cell: cell, isChecked: items[indexPath.row].checked)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "Create a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
    }
    
}

