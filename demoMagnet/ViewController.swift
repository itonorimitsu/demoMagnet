//
//  ViewController.swift
//  demoMagnet
//
//  Created by 伊藤永光 on 2019/11/09.
//  Copyright © 2019 Nito. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var sensingButton: UIButton!
    
    //インスタンス生成
    let motionManager = CMMotionManager()
    
//    let magdata: CMMagnetometerData = CMMagnetometerData()
    
    // CMMagnetometer
    var mag_x: Double = 0.0
    var mag_y: Double = 0.0
    var mag_z: Double = 0.0
    
    // sensingしているかどうか
    private var isSensing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.magnetometerUpdateInterval = 0.1
        
//        // isMagnetometerAvailableは端末に磁気センサーがあるかどうかを確認している。
//        if motionManager.isMagnetometerAvailable && motionManager.isMagnetometerActive {
//            let handler: CMMagnetometerHandler = {(magnetoData: CMMagnetometerData?, error:Error?) -> Void in
//                self.measureMagnetoData(magnetoData:magnetoData)
//            }
//            motionManager.startMagnetometerUpdates(to: OperationQueue.main, withHandler: handler)
//        }
        // pushされるとsensingButtonの実行
        sensingButton.addTarget(self, action: #selector(self.pushButton(_:)), for: UIControl.Event.touchUpInside)
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
//        motionManager.startMagnetometerUpdates(to: OperationQueue.main, withHandler:handler)
    }
    
    // センシングの停止。pushButtonで呼び出し
    func stopSensing() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopMagnetometerUpdates()
        }
//        print("止まるんじゃねえぞ")
    }
    
    
//    func showMagnetoData(magnetoData: CMMagnetometerData?, error: NSError?) {
//        if let data = magnetoData {
//            var x = data.magneticField.x
//            var y = data.magneticField.y
//            var z = data.magneticField.z
//
//            x = round(x*100)/100
//            y = round(y*100)/100
//            z = round(z*100)/100
//
//            xLabel.text = String(x)
//            yLabel.text = String(y)
//            zLabel.text = String(z)
//        }
//    }

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
        
        print(magnetoData.magneticField.x)
        print(magnetoData.magneticField.y)
        print(magnetoData.magneticField.z)
        

//        print("タイプ確認")
//        ダブル型の返り値でした。
//        print(type(of: magnetoData.magneticField.x))

        print("_____________________")
        xLabel.text = String(magnetoData.magneticField.x)
        yLabel.text = String(magnetoData.magneticField.y)
        zLabel.text = String(magnetoData.magneticField.z)
    }
    

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self.imageView)
//
//        let locationX = round(location.x * 10000) / 10000
//        let locationY = round(location.y * 10000) / 10000
//    }

}

