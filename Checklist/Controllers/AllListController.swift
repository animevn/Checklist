import UIKit

class AllListController:UITableViewController{
        
    var dataModel:DataModel!
    
    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueShowChecklist{
            let destination = segue.destination as? ChecklistController
            destination?.checklist = sender as? Checklist
        }
        if segue.identifier == Constants.segueAddChecklist{
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ChecklistDetailController
            destination.modalPresentationStyle = .fullScreen
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    private func getIndexToOpenPreviousCheckList(){
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: Constants.segueShowChecklist, sender: checklist)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The view \(type(of: self)) did load")
        navigationController?.delegate = self
        getIndexToOpenPreviousCheckList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("The view \(type(of: self)) will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("The view \(type(of: self)) did appear")
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("The view \(type(of: self)) will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("The view \(type(of: self)) did appear")
    }
}

extension AllListController:ChecklistDetailDelegate{
    func cancel() {
        dismiss(animated: true)
    }
    
    func finishAdding(checklist: Checklist) {
        dataModel.lists.append(checklist)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func finishEditing(checklist: Checklist) {
        tableView.reloadData()
        dismiss(animated: true)
    }
}

extension AllListController:UINavigationControllerDelegate{
    
    //this is called when appdelegate move to this view
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}

extension AllListController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.allListCell)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.detailTextLabel?.text = checklist.countNotChecked()
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: Constants.segueShowChecklist, sender: checklist)
    }
}

















