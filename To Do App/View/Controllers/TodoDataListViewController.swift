//
//  TodoDataListViewController.swift
//  To Do App
//
//  Created by Apple on 01/10/21.
//

import UIKit

class TodoDataListViewController: UIViewController {
    
    @IBOutlet weak var listTableview: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    let cellId: String = "TaskListTableCell"
    let viewModel = ListClassVM()
    var taskListArray: [TaskList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTblCell()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: .reloadTable, object: nil)
    }
    @objc func methodOfReceivedNotification(notification: NSNotification){
        listTableview.reloadData()
    }
    func configureTblCell(){
        self.listTableview.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        self.listTableview.dataSource = self
    }
    @IBAction func addTaskBtnTapped(_ sender: UIButton){
        openAddModifyController()
    }
    @IBAction func recurranceChanged(sender: UISegmentedControl) {
        self.listTableview.reloadData()
    }
    func openAddModifyController(_ isModify: Bool? = false, taskID: Int? = 0){
        let myViewController = AddModifyViewController(nibName: "AddModifyViewController", bundle: nil)
        myViewController.isModify = isModify ?? false
        if isModify!{
            myViewController.taskId = taskID
        }
        myViewController.modalPresentationStyle = .fullScreen
        self.present(myViewController, animated: true, completion: nil)
    }
}

//MARK: Tableview Datasource
extension TodoDataListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0:
            self.taskListArray = viewModel.loadTodaysList()
        case 1:
            self.taskListArray = viewModel.loadTomorrowList()
        case 2:
            self.taskListArray = viewModel.loadOtherDaysList()
        default:
            break
        }
        /*if viewModel.taskListDataArray.count == 0{
         viewModel.taskListDataArray = viewModel.loadTaskList()
         }*/
        return taskListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskListTableCell
        let task = taskListArray[indexPath.row]
        cell.taskHeaderLable.text =  task.task_header
        cell.taskDescriptionLable.text =  task.task_desc
        cell.deleteButton.tag = Int(task.task_id)
        cell.editButton.tag = Int(task.task_id)
        cell.cellbuttonDelegate = self
        return cell
    }
}

//MARK: Cell Action button handler
extension TodoDataListViewController: CellButtonHandlerProtocol{
    func editButtonTapped(task_id: Int) {
        openAddModifyController(true,taskID: task_id)
    }
    
    func deleteButtonTapped(_ task: TaskList) {
        viewModel.deleteTaskFromLost(task: task) { (isComplete) in
            if isComplete ?? false{
                DispatchQueue.main.async {
                    self.listTableview.reloadData()
                }
            }
        }
    }
}
