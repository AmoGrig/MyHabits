//
//  HabitViewController.swift
//  MyHabits
//
//  Created by ARAM on 24.07.2022.
//

import UIKit

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    private lazy var habitNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var habitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Morning runnings, sleep 8 hours and so on..."
        textField.textColor = .blue
        textField.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var colorNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Color"
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 17
        colorView.backgroundColor = .orange
        colorView.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pickColor))
        colorView.addGestureRecognizer(gesture)
        return colorView
    }()
    
    private lazy var timeNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Time"
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var timeDescriptionLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Every day at"
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let datePicker = UIDatePicker()
    
    private lazy var timeField: UITextField = {
        let textField = UITextField()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.datePickerMode = .time
        datePicker.frame.size = CGSize(width: 0, height: 150)
        textField.inputView = datePicker
        textField.textColor = .myPurple
        textField.placeholder = "11:00 AM"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove Habit", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeHabit), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        setConstraints()
    }
    
    private func settings() {
        self.view.backgroundColor = .white
        title = "Create"
        navigationController?.navigationBar.tintColor = .myPurple
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    @objc func saveButton() {
        let newHabit = Habit(name: habitTextField.text ?? "No habit name",
                             date: datePicker.date,
                             color: colorView.backgroundColor ?? .orange)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        dismiss(animated: true)
    }
    
    @objc func cancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func pickColor() {
        let colors = UIColorPickerViewController()
        colors.delegate = self
        present(colors, animated: true)
    }
    
    @objc private func doneAction() {
        view.endEditing(true)
    }
    
    @objc private func dateChanged() {
        getTime()
    }
    
    private func getTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let colors = viewController.selectedColor
        colorView.backgroundColor = colors
    }
    
    @objc private func removeHabit () {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Removing habit", message: "Do you want to remove habit \(habitTextField.text ?? "")?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
            for (index, element) in HabitsStore.shared.habits.enumerated() {
                if self.habitTextField.text == element.name && self.colorView.backgroundColor == element.color {
                    HabitsStore.shared.habits.remove(at: index)
                    dismiss(animated: true)
                } else {
                    dismiss(animated: true)
                }
            }
        }))
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        self.view.addSubview(habitNameLabel)
        self.view.addSubview(habitTextField)
        self.view.addSubview(colorNameLabel)
        self.view.addSubview(colorView)
        self.view.addSubview(timeNameLabel)
        self.view.addSubview(timeDescriptionLabel)
        self.view.addSubview(timeField)
        self.view.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            habitNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            
            habitTextField.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 10),
            habitTextField.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            
            colorNameLabel.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 10),
            colorNameLabel.leadingAnchor.constraint(equalTo: habitTextField.leadingAnchor),
            
            colorView.topAnchor.constraint(equalTo: colorNameLabel.bottomAnchor, constant: 10),
            colorView.leadingAnchor.constraint(equalTo: colorNameLabel.leadingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 35),
            colorView.widthAnchor.constraint(equalToConstant: 35),
            
            timeNameLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10),
            timeNameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            
            timeDescriptionLabel.topAnchor.constraint(equalTo: timeNameLabel.bottomAnchor, constant: 10),
            timeDescriptionLabel.leadingAnchor.constraint(equalTo: timeNameLabel.leadingAnchor),
            
            timeField.topAnchor.constraint(equalTo: timeDescriptionLabel.topAnchor),
            timeField.leadingAnchor.constraint(equalTo: timeDescriptionLabel.trailingAnchor, constant: 10),
            timeField.widthAnchor.constraint(equalToConstant: 100),
            
            removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            removeButton.widthAnchor.constraint(equalToConstant: 200),
            removeButton.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
