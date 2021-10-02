//
//  TaskListTableCell.swift
//  To Do App
//
//  Created by Apple on 01/10/21.
//

import UIKit

protocol CellButtonHandlerProtocol: NSObject{
    func editButtonTapped(task_id: Int)
    func deleteButtonTapped(_ task: TaskList)
}

class TaskListTableCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var taskHeaderLable: UILabel!
    @IBOutlet weak var taskDescriptionLable: UILabel!
    var viewModel = ListClassVM()
    weak var cellbuttonDelegate: CellButtonHandlerProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.setCardViewUI()
    }
    @IBAction func editBtnTapped(_ sender: UIButton){
        self.cellbuttonDelegate?.editButtonTapped(task_id: sender.tag)
    }
    @IBAction func deleteBtnTapped(_ sender: UIButton){
        guard let task = viewModel.getSelectedTask(taskId: sender.tag)else{return}
        self.cellbuttonDelegate?.deleteButtonTapped(task)
    }
}
