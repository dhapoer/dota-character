//
//  MainMenuViewController.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    //var collectionView: UICollectionView!
    //var tableView: UITableView!
    
    //private var imageView: UIImageView = UIImageView()
    //private var labelDesc: UILabel = UILabel()
    
    private var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ROLE_MENU")
        tableView.estimatedRowHeight = 1
        tableView.estimatedSectionHeaderHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private var heightForRow = [IndexPath: CGFloat]()
    private var viewModel = MainMenuViewModel()
    private var dotaData: [DotaModel] = []
    private var selectedData: [DotaModel] = []
    private var selectedRole: String = "All"
    
    let roleString = [
        "Carry",
        "Disabler",
        "Durable",
        "Escape",
        "Initiator",
        "Jungler",
        "Nuker",
        "Pusher",
        "Support",
        "All"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func getData() {
        if let data = UserDefaults.standard.getCodable(
            data: [DotaModel].self,
            forKey: "Cache"
        ) {
            dotaData = data
            selectedRole = "All"
            self.collectionView.reloadData()
        }
        let isOnline = URLSession.connectedToNetwork()
        if isOnline {
            viewModel.getDotaData(completion: { [weak self] in
                switch $0 {
                    case .success(let resp):
                        UserDefaults.standard.setCodable(data: resp, forKey: "Cache")
                        self?.dotaData = resp
                        self?.selectedRoleFunc(self?.selectedRole ?? "All")
                    case .failure(let err):
                        print("no data")
                }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Intenet Offline", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func selectedRoleFunc(_ role: String){
        if role != "All" {
            selectedData = []
            for (index, data)  in dotaData.enumerated() {
                let filter = data.roles.filter {$0 == role }
                if filter.count > 0 {
                    selectedData.append(data)
                }
                if index == dotaData.count - 1 {
                    self.collectionView.reloadData()
                }
            }
        } else {
            selectedData = dotaData
            self.collectionView.reloadData()
        }
    }
    
    func goToHeroDetails(data: DotaModel){
        let vc = HeroDetailViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.dotaData = dotaData
        vc.selectedData = data
        vc.selectedRole = selectedRole
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension MainMenuViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = dotaData[index]
        self.goToHeroDetails(data: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width - 100) / 3.0 - 16
        let yourHeight = CGFloat(104)
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)
        
        cell.removeFromSuperview()
        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let imageView: UIImageView = UIImageView()
        cell.backgroundColor = .black
        cell.contentView.addSubview(imageView)
        cell.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        
        // TO DO: Cache with Core Data
        if let url = URL(string: "https://api.opendota.com" + dotaData[indexPath.row].img) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                imageView.image = UIImage(data: imageData)
            }
        }
        
        let labelDesc = UILabel()
        labelDesc.numberOfLines = 1
        labelDesc.backgroundColor = .clear
        labelDesc.textColor = .white
        labelDesc.text = dotaData[indexPath.row].localizedName
        labelDesc.textAlignment = .center
        
        cell.contentView.addSubview(labelDesc)
        labelDesc.translatesAutoresizingMaskIntoConstraints = false
        labelDesc.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        labelDesc.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
        labelDesc.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
        labelDesc.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        labelDesc.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return cell
    }
    
}


extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = roleString[index]
        self.selectedRoleFunc(data)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roleString.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ROLE_MENU", for: indexPath)
        let labelDesc = UILabel()
        labelDesc.numberOfLines = 1
        labelDesc.backgroundColor = .black
        labelDesc.textColor = .white
        labelDesc.text = roleString[indexPath.row]
        labelDesc.textAlignment = .center
        labelDesc.layer.cornerRadius = 8
        
        cell.contentView.addSubview(labelDesc)
        labelDesc.translatesAutoresizingMaskIntoConstraints = false
        labelDesc.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        labelDesc.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
        labelDesc.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
        labelDesc.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightForRow[indexPath] = cell.bounds.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow[indexPath] ?? UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}


