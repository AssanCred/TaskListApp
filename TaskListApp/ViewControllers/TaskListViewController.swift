//
//  ViewController.swift
//  TaskListApp
//
//  Created by Артём Латушкин on 18.05.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    // MARK: - Privates proporties 
    private var taskList: [Task] = []
    private let cellID = "cell"
    private let storageDataManager = StorageDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .systemGray5
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageDataManager.delete(task: task)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = taskList[indexPath.row]
        
        showAlert(nameTask: task.title ?? "", withTitle: "Edit", addMassage: "Please, edit your task") { result in
            self.storageDataManager.edit(task: task, newTask: result)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Create method work with datas
    private func addNewTask() {
        showAlert(nameTask: "", withTitle: "New Task", addMassage: "Please, add a new task") { result in
            self.save(result)
        }
    }
    
    private func save(_ taskName: String) {
        storageDataManager.save(taskName) { [weak self] task in
            self?.taskList.append(task)
            self?.tableView.insertRows(
                at: [IndexPath(row: (self?.taskList.count ?? 0) - 1, section: 0)],
                with: .automatic)
        }
    }
    
    private func fetchData() {
        storageDataManager.fetchData { [weak self] result in
            switch result {
            case .success(let task):
                self?.taskList = task
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Create & setup alert controller
    private func showAlert(nameTask: String, withTitle title: String, addMassage message: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            completion(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            if nameTask == "" {
                textField.placeholder = "Name task"
            } else {
                textField.text = nameTask
            }
        }
        present(alert, animated: true)
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [unowned self] _ in
                addNewTask()
            }
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

