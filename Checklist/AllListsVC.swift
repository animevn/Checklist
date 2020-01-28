import UIKit

class AllListsVC:UITableViewController, ListDetailDelegate, UINavigationControllerDelegate{
    
    var dataModel:DataModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self

        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "showChecklist", sender: checklist)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    private func makeCell(tableView:UITableView)->UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            return cell
        }else{
            return UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(tableView: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = "\(checklist.name)"
        cell.detailTextLabel?.text = checklist.countUnchecked()
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(named: checklist.iconName)
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
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "showChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigation = storyboard!
            .instantiateViewController(withIdentifier: "checklistDetailNavigation")
            as! UINavigationController
        
        let controller = navigation.topViewController as! ListDetailVC
        controller.deletgate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigation.modalTransitionStyle = .flipHorizontal
        present(navigation, animated: true, completion: nil)
        
    }
    
    private func addItem(checklist:Checklist){
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
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
        dismiss(animated: true, completion: nil)
    }
}
