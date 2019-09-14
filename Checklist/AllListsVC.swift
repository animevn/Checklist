import UIKit

class AllListsVC:UITableViewController{
    
    var lists:[Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        super.init(coder: aDecoder)
        
        var list = Checklist(name: "Keep trying")
        lists.append(list)
        
        list = Checklist(name: "Fabled")
        lists.append(list)
        
        list = Checklist(name: "Vin")
        lists.append(list)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let checklist = lists[indexPath.row]
        cell.textLabel?.text = "\(checklist.name)"
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist"{
            let destination = segue.destination as! ChecklistVC
            destination.checklist = sender as? Checklist
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "showChecklist", sender: checklist)
    }
}
