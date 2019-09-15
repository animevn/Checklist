import UIKit

class AllListsVC:UITableViewController, ListDetailDelegate{
    
    var lists = [Checklist]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadChecklist()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    private func makeCell(tableView:UITableView)->UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            return cell
        }else{
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(tableView: tableView)
        let checklist = lists[indexPath.row]
        cell.textLabel?.text = "\(checklist.name)"
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist"{
            let destination = segue.destination as! ChecklistVC
            destination.checklist = sender as? Checklist
        }else if segue.identifier == "addChecklist"{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ListDetailVC
            controller.deletgate = self
            controller.checklistToEdit = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "showChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigation = storyboard!
            .instantiateViewController(withIdentifier: "checklistDetailNavigation")
            as! UINavigationController
        
        let controller = navigation.topViewController as! ListDetailVC
        controller.deletgate = self
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigation.modalTransitionStyle = .flipHorizontal
        present(navigation, animated: true, completion: nil)
        
    }
    
    private func addItem(checklist:Checklist){
        let newRowIndex = lists.count
        lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func listDetailDidCancel(_ controller: ListDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetail(_ controller: ListDetailVC, didFinishAdding checklist: Checklist) {
        addItem(checklist: checklist)
        dismiss(animated: true, completion: nil)
    }
    
    func listDetail(_ controller: ListDetailVC, didFinishEditing checklist: Checklist) {
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    private func documentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath()->URL{
        return documentsDirectory().appendingPathComponent("checklist.plist")
    }
    
    func saveChecklist(){
        print("save")
        do{
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: lists,
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
                lists = try NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(data) as! [Checklist]
            }catch let error{
                print(error)
            }
        }catch let error{
            print(error)
        }
    }
    
    
}
