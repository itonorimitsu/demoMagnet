//
//  csvFileManagerViewController.swift
//  demoMagnet
//
//  Created by 伊藤永光 on 2019/11/16.
//  Copyright © 2019 Nito. All rights reserved.
//

import UIKit

class csvFileManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var csvTableView: UITableView!
    
    // directory path of csv files
    let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let directoryPath = NSHomeDirectory() + "/Documents"
    var csvFileNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(directoryPath)
        getCsvFileNames()
        csvTableView.allowsMultipleSelection = false
        
        deleteButton.addTarget(self, action: #selector(self.deleteAllCsvButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        closeButton.addTarget(self, action: #selector(self.closeButtonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func deleteAllCsvButtonAction(_ sender: Any) {
        showDeleteAllCsvAlert()
    }
    
    func showDeleteAllCsvAlert() {
        let alertController = UIAlertController(title: "Delete CSV file", message: "Do you delete all csv files", preferredStyle: .alert)
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in self.deleteAllCsvFiles()})
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction!) -> Void in })
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("csvファイルのカウント数")
        return csvFileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let csvFileName = csvFileNames[indexPath.row]
        cell.textLabel!.text = String(csvFileName)
        
//        print("cell返し")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteCsvPath = directoryPath + "/" + csvFileNames[indexPath.row]
            deleteCsvFile(filePath: deleteCsvPath)
            getCsvFileNames()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
//            print("tableViewが帰ってくる")
            
        }
    }
    
    func getCsvFileNames() {
        var tmp: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: directoryPath)
            } catch {
                return []
            }
        }
        csvFileNames = tmp
    }
    
    func deleteCsvFile(filePath:String) {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            print("Failure to Delete CSV")
        }
    }
    
    func deleteAllCsvFiles() {
        var indexPaths = [IndexPath]()
        for (i, name) in csvFileNames.enumerated() {
            let deleteCsvPath = directoryPath + "/" + name
            deleteCsvFile(filePath: deleteCsvPath)
            indexPaths.append([0, i])
        }
        getCsvFileNames()
        csvTableView.deleteRows(at: indexPaths, with: .fade)
        csvTableView.reloadData()
    }
    
}
