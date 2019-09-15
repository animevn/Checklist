import UIKit

class ChecklistVC: UITableViewController, ItemDetailDelegate{
    
    private var items:[ChecklistItem]
    var checklist:Checklist!

    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        
        loadChecklist()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }

    override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return items.count
    }
    
    private func configureCheckmark(cell:UITableViewCell, isChecked:Bool){
        let label = cell.viewWithTag(699) as! UILabel
        label.text = isChecked ? "✓" : " "
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        items[indexPath.row].toggleChecked()
        configureCheckmark(cell: cell, isChecked: items[indexPath.row].checked)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func addItem(item:ChecklistItem){
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    //delete row
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        saveChecklist()
    }
    
    func itemDetailDidCancel(_ controller: ItemDetailVC) {
        dismiss(animated: true, completion: nil)
        saveChecklist()
    }
    
    func itemDetail(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem) {
        addItem(item: item)
        dismiss(animated: true, completion: nil)
        saveChecklist()
    }
    
    func itemDetail(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {

//        if let index = items.firstIndex(of: item){
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath){
//                configureCell(cell: cell, indexPath: indexPath)
//            }
//        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        saveChecklist()
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
                    controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    private func documentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath()->URL{
        return documentsDirectory().appendingPathComponent("checklist.plist")
    }
    
    private func saveChecklist(){
        do{
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: items,
                requiringSecureCoding: false)
            do{
                try data.write(to: dataFilePath(), options: .atomic)
            }catch let error{
                print(error)
            }
        }catch let error{
            print(error)
        }
    }
    
    private func loadChecklist(){
        let path = dataFilePath()
        do{
            let data = try Data(contentsOf: path)
            do{
                items = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [ChecklistItem]
            }catch let error{
                print(error)
            }
        }catch let error{
            print(error)
        }
    }
}

