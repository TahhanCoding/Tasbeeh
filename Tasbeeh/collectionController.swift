//  collectionController.swift
//  Tasbeeh
//  Created by Ahmed Shaban on 03/08/2022.

import UIKit
class collectionController: UICollectionViewController {
     var azkar = [Zekr]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "إضافة", style: .plain, target: self, action: #selector(addZekr))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collectionView.addGestureRecognizer(longPress)
        
        // user defaults is used mainly for saving user settings
        let defaults = UserDefaults.standard
        if let savedAzkar = defaults.object(forKey: "azkar") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                azkar = try jsonDecoder.decode([Zekr].self, from: savedAzkar)
            } catch {
                print("Failed to Load")
            }
        }
    }
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                let zekr = azkar[indexPath.item]
                let ac = UIAlertController(title: "خيارات", message: nil, preferredStyle: .alert)
                ac.addTextField()
                ac.textFields?[0].text = zekr.text
                ac.addAction(UIAlertAction(title: "حذف", style: .cancel) {
                    [weak self] _ in
                    self?.azkar.remove(at: indexPath.item)
                    self?.save()
                    self?.collectionView.reloadData()
                })
                ac.addAction(UIAlertAction(title: "تسمية", style: .default) { [weak self, weak ac] _ in
                    guard let newZekr = ac?.textFields?[0].text else { return }
                    self?.azkar[indexPath.item].text = newZekr
                    self?.save()
                    self?.collectionView.reloadData()
                })
                ac.addAction(UIAlertAction(title: "ضبط العداد", style: .default) {
                   [weak self] _ in
                    self?.azkar[indexPath.item].counter = 0
                    self?.save()
                    self?.collectionView.reloadData() 
                  })
                present(ac, animated: true)
            }
        }
    }
    @objc func addZekr(){
        let ac = UIAlertController(title: "اكتب الذكر لإضافته:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let add = UIAlertAction(title: "إضافة", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
            self?.save()
        }
        
        ac.addAction(add)
        present(ac, animated: true)
    }
    func submit(_ Item: String) {
        let newZekr = Zekr(text: Item, counter: 0)
        azkar.insert(newZekr, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        return
    }
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(azkar) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "azkar")
        } else {
            print("failed saving")
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return azkar.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Zekr", for: indexPath) as? ZekrClass else {
            fatalError("Unable to dequeue ZekrClass Cell.")
        }
        let zekr = azkar[indexPath.item]
        cell.zekrText.text = zekr.text
        cell.counterView.text = "العدد: " + String(azkar[indexPath.row].counter)
        cell.layer.cornerRadius = 30
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewZekr") as? ViewController {
            vc.zekr = azkar[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.save()
        self.collectionView.reloadData()
    }
    
}


    


