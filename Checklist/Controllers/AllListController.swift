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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The view \(type(of: self)) did load")
        navigationController?.delegate = self
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
}

















