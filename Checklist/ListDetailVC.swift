import UIKit

protocol ListDetailDelegate:class{
    func listDetailDidCancel(_ controller:ListDetailVC)
    func listDetail(_ controller:ListDetailVC, didFinishAdding checklist:Checklist)
    func listDetail(_ controller:ListDetailVC, didFinishEditing checklist:Checklist)
}

class ListDetailVC:UITableViewController{
    
    
    
}
