//
//  AddModifyViewController.swift
//  To Do App
//
//  Created by Apple on 01/10/21.
//

import UIKit

class AddModifyViewController: UIViewController {
    
    @IBOutlet weak var headerTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addModifyButton: UIButton!
    
    let datePicker = UIDatePicker()
    let viewModel = ListClassVM()
    var pickedDate: Date?
    var isModify: Bool = false
    var taskId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDatePicker()
        isForModify()
    }
    func setupUI(){
        addModifyButton.layer.cornerRadius = 7.0
        self.descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTextField.layer.borderWidth = 1
    }
    func isForModify(){
        if isModify{
            guard let id = taskId else{return}
            guard let taskData = viewModel.getSelectedTask(taskId: id) else{return}
            self.setDefaultData(task: taskData)
            self.addModifyButton.setTitle(Constants.modify, for: .normal)
        }else{
            self.addModifyButton.setTitle(Constants.add, for: .normal)
        }
    }
    func setDefaultData(task: TaskList){
        self.headerTextField.text = task.task_header
        self.descriptionTextField.text = task.task_desc
        self.dateTextField.text = task.date?.toString()
    }
    func configureDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Constants.done, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Constants.cancel, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    @objc func donedatePicker(){
        pickedDate = datePicker.date
        dateTextField.text = datePicker.date.toString()
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addModifyButtonTapped(_ sender: UIButton){
        let test = CoreDataBaseModel(title: headerTextField.text!, listDescription: descriptionTextField.text!, date: pickedDate ?? Date(), id: self.taskId != nil ? self.taskId! : Int.random(in: 1...1000))
        
        if self.isModify{
            viewModel.modifyTask(task: test)
        }else{
            viewModel.saveDataToDatabase(dataModel: test)
        }
        Alerts.goBackAlert(view: self, title: "", message: "Database task done successfully", navController: nil)
        NotificationCenter.default.post(name: .reloadTable, object: nil)
    }
}
