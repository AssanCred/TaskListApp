//
//  NewTaskViewController.swift
//  TaskListApp
//
//  Created by Артём Латушкин on 18.05.2023.
//

import UIKit



final class NewTaskViewController: UIViewController {

    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New task"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        // Set attributes for button title
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Create button
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = UIColor(named: "MilkBlue")
        buttonConfiguration.attributedTitle = AttributedString("Save task", attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: UIAction { [unowned self] _ in
            save()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        // Set attributes for button title
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Create button
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = UIColor(named: "MilkRed")
        buttonConfiguration.attributedTitle = AttributedString("Cancel", attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: UIAction { [unowned self] _ in
            dismiss(animated: true)
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSubviews(taskTextField, saveButton, cancelButton)
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func save() {
        dismiss(animated: true)
    }
}
