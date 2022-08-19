//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by ARAM on 16.07.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    
        private lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.headerReferenceSize = CGSize(width: 0, height: 20)
            layout.footerReferenceSize = CGSize(width: 0, height: 5)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
            collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
            collectionView.backgroundColor = .myWhite
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
    }()
    
        private lazy var statusBarColor: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        setConstraints()
    }
    
    private func settings() {
        self.view.backgroundColor = .myWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        navigationItem.rightBarButtonItem?.tintColor = .myPurple
    }
    
    @objc func addButton() {
        let habitVC = HabitViewController()
        let navVC = UINavigationController(rootViewController: habitVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func setConstraints() {
        view.addSubview(collectionView)
        view.addSubview(statusBarColor)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            statusBarColor.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarColor.heightAnchor.constraint(equalToConstant: 47)
        ])
    }
    
}

extension HabitsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 350, height: 60)
        } else {
            return CGSize(width: 350, height: 140)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.setupData(habit: habit)
            return cell
        }
    }
}

