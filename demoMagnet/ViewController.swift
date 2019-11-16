//
//  ViewController.swift
//  demoMagnet
//
//  Created by 伊藤永光 on 2019/11/09.
//  Copyright © 2019 Nito. All rights reserved.
//

import UIKit
import CoreMotion
import simd


class ViewController: UIViewController {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var sensingButton: UIButton!
    @IBOutlet weak var csvFileManageButton: UIButton!
    
    //インスタンス生成
    let motionManager = CMMotionManager()
    let csvManager = csvSaveDataManager()
    let formatter: DateFormatter = DateFormatter()
    
    
    // sensingしているかどうか
    private var isSensing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        秒単位で計測している
        motionManager.magnetometerUpdateInterval = 0.1

        //記録計測の開始
//        startSensorUpdates(motionManager.magnetometerUpdateInterval)
        // pushされるとsensingButtonの実行
//        sensingButton.addTarget(self, action: #selector(self.pushButton(_:)), for: UIControl.Event.touchUpInside)
        
        // pushされるとcsvファイルを作成する。
        csvFileManageButton.addTarget(self, action: #selector(self.recordingCsvActive(_:)), for: UIControl.Event.touchUpInside)
    }
    
    // sensingの開始を行う。
    // magnetavailableのbool切り替え
    // 状態確認する。切り替えする。
    @objc func pushButton(_ sender: UIButton) {
        if self.isSensing {
            isSensing = false
            stopSensing()
        } else {
            isSensing = true
            startSensing()
        }
//        print(isSensing)
    }
    
    // sensingの開始を行う。計測結果をcsvファイルとして出力できるようにする。
    // pushButton同様に切り替えを行い、記録に開始を行う。
    @objc func recordingCsvActive(_ sender: Any) {
        if csvManager.isRecording {
            csvManager.stopRecording()
            // save csvfile
            stopSensing()
            formatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
            let dateText = formatter.string(from: Date())
            showSaveCsvFileAlert(fileName: dateText)
            
            sensingButton.isEnabled = true
            csvFileManageButton.setTitle("Start", for: .normal)
        } else {
            csvManager.startRecording()
            startSensing()
//            csvFileManageButton.isEnabled = false
            sensingButton.isEnabled = false
            csvFileManageButton.setTitle("Stop", for: .normal)
            
        }
    }
    
    func showSaveCsvFileAlert(fileName: String) {
        let alertController = UIAlertController(title: "Save CSV file", message: "Enter file name to add.", preferredStyle: .alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            let textField = alertController.textFields![0] as UITextField
            self.csvManager.saveSensorDataToCsv(fileName: textField.text!)
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction!) -> Void in
            self.showDeleteRecordedDataAlert(fileName: fileName)
        })
        
        alertController.addTextField{(textField:UITextField!) -> Void in
            alertController.textFields![0].text = fileName
        }
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDeleteRecordedDataAlert(fileName:String){
        let alertController = UIAlertController(title: "Delete recorded data", message: "Do you delete recorded data?", preferredStyle: .alert)
        
        let defaultAction:UIAlertAction =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler:{
                            (action:UIAlertAction!) -> Void in
                            // delete recorded data
            })
        let cancelAction:UIAlertAction =
            UIAlertAction(title: "Cancel",
                          style: .cancel,
                          handler:{
                            (action:UIAlertAction!) -> Void in
                            self.showSaveCsvFileAlert(fileName: fileName)
            })
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // センシングの開始。pushButtonで呼び出し
    func startSensing() {
//        motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error: Error?) in
//            self.measureMagnetoData(magnetoData: CMMagnetometerData)
//        })
        if motionManager.isDeviceMotionAvailable {
            motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(magnetoData:CMMagnetometerData?, error:Error?) in
                self.measureMagnetoData(magnetoData: magnetoData!)
            })
        }
//        print("dekiteru")
    }
    
    // センシングの停止。pushButtonで呼び出し
    func stopSensing() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopMagnetometerUpdates()
        }
//        print("止まるんじゃねえぞ")
    }
    
    


    func measureMagnetoData(magnetoData: CMMagnetometerData) {
        
//        if let data = magnetoData {
//            print(data.magneticField.x)
//            print(data.magneticField.y)
//            print(data.magneticField.z)
//
//            mag_x = data.magneticField.x
//            mag_y = data.magneticField.y
//            mag_z = data.magneticField.z
//        }
        
//        print(magnetoData.magneticField.x)
//        print(magnetoData.magneticField.y)
//        print(magnetoData.magneticField.z)
        

//        print("タイプ確認")
//        ダブル型の返り値でした。
//        print(type(of: magnetoData.magneticField.x))
        xLabel.text = String(magnetoData.magneticField.x)
        yLabel.text = String(magnetoData.magneticField.y)
        zLabel.text = String(magnetoData.magneticField.z)
        
        if csvManager.isRecording {
            formatter.dateFormat = "MM-dd_HH:mm:ss:SSS"
            var text = ""
            text += formatter.string(from: Date()) + ","
            text += String(magnetoData.magneticField.x) + ","
            text += String(magnetoData.magneticField.y) + ","
            text += String(magnetoData.magneticField.z)
            
            csvManager.addText(addText: text)
        }
    }

}

