//
//  HeroDetailViewController.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    public var dotaData: [DotaModel] = []
    public var selectedData: DotaModel?
    public var selectedRole: String = "All"
    
    var collectionView: UICollectionView!
    let scrollView: UIScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = selectedData?.localizedName ?? ""
        
        setupUI()
        sortByRequest()
    }
    
    func setupUI(){
        
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true;
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true;
        
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        if let url = URL(string: "https://api.opendota.com" + (selectedData?.img ?? "")) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                imageView.image = UIImage(data: imageData)
            }
        }
        
        let attackTypeLabel = UILabel()
        attackTypeLabel.numberOfLines = 1
        attackTypeLabel.backgroundColor = .clear
        attackTypeLabel.textColor = .black
        attackTypeLabel.text = "attack type: \(selectedData?.attackType ?? "")"
        attackTypeLabel.textAlignment = .center
        attackTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(attackTypeLabel)
        attackTypeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        attackTypeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let attributeLabel = UILabel()
        attributeLabel.numberOfLines = 1
        attributeLabel.backgroundColor = .clear
        attributeLabel.textColor = .black
        attributeLabel.text = "attribute: \(selectedData?.primaryAttr ?? "")"
        attributeLabel.textAlignment = .center
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(attributeLabel)
        attributeLabel.topAnchor.constraint(equalTo: attackTypeLabel.bottomAnchor, constant: 8).isActive = true
        attributeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let healthLabel = UILabel()
        healthLabel.numberOfLines = 1
        healthLabel.backgroundColor = .clear
        healthLabel.textColor = .black
        healthLabel.text = "health: \(selectedData?.baseHealth ?? 0)"
        healthLabel.textAlignment = .center
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(healthLabel)
        healthLabel.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 8).isActive = true
        healthLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let maxAttackLabel = UILabel()
        maxAttackLabel.numberOfLines = 1
        maxAttackLabel.backgroundColor = .clear
        maxAttackLabel.textColor = .black
        maxAttackLabel.text = "max attack: \(selectedData?.baseAttackMax ?? 0)"
        maxAttackLabel.textAlignment = .center
        maxAttackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(maxAttackLabel)
        maxAttackLabel.topAnchor.constraint(equalTo: healthLabel.bottomAnchor, constant: 8).isActive = true
        maxAttackLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let speedLabel = UILabel()
        speedLabel.numberOfLines = 1
        speedLabel.backgroundColor = .clear
        speedLabel.textColor = .black
        speedLabel.text = "speed: \(selectedData?.moveSpeed ?? 0)"
        speedLabel.textAlignment = .center
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(speedLabel)
        speedLabel.topAnchor.constraint(equalTo: maxAttackLabel.bottomAnchor, constant: 8).isActive = true
        speedLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        let similarLabel = UILabel()
        similarLabel.numberOfLines = 1
        similarLabel.backgroundColor = .clear
        similarLabel.textColor = .black
        similarLabel.text = "Similar Heroes:"
        similarLabel.textAlignment = .center
        similarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(similarLabel)
        similarLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 16).isActive = true
        similarLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        scrollView.addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func sortByRequest(){
        if selectedData?.primaryAttr == "agi" {
            dotaData.sort { (before, now) -> Bool in
                return (before.moveSpeed) > (now.moveSpeed) ? true : false
            }
            self.collectionView.reloadData()
        } else if selectedData?.primaryAttr == "str" {
            dotaData.sort { (before, now) -> Bool in
                return (before.baseAttackMax) > (now.baseAttackMax) ? true : false
            }
            self.collectionView.reloadData()
        } else {
            dotaData.sort { (before, now) -> Bool in
                return (before.baseMana) > (now.baseMana) ? true : false
            }
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

extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)
        
        cell.removeFromSuperview()
        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        cell.backgroundColor = .black
        let imageView = UIImageView(image: UIImage(named: ""))
        cell.contentView.addSubview(imageView)
        cell.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        
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

