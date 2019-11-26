//
//  csvDataSaveManager.swift
//  demoMagnet
//
//  Created by 伊藤永光 on 2019/11/14.
//  Copyright © 2019 Nito. All rights reserved.
//

import Foundation

class csvSaveDataManager {
    
    private(set) var isRecording = false
    private let headerText = "timestamp, magnetoFirldX, magnetoFieldY, magnetoFieldZ, angle"
    private var recordText = ""
    
    var format = DateFormatter()
    
    init() {
        format.dateFormat = "YYYY-MM-dd_HH-mm-ss-SSS"
    }
    
    func startRecording() {
        recordText = ""
        recordText += headerText + "\n"
        isRecording = true
    }
    
    func stopRecording() {
        isRecording = false
    }
    
    func addText(addText:String) {
        recordText += addText + "\n"
    }
    
    func saveSensorDataToCsv(fileName: String) {
        let filePath = NSHomeDirectory() + "/Documents/" + fileName + ".csv"
        do {
            try recordText.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
            print("success to Write CSV")
        } catch let error as NSError {
            print("Failure to write CSV\n\(error)")
        }
    }
}
