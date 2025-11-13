//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager() // singleton
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
            
        // Create Folder
        createFolderIfNeeded(folderName: folderName)
        
        // Get path for the Image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // Save Image to path
        do {
            try data.write(to: url)
        }catch let error{
            print("Error savin image. ImageName: \(imageName). Error: \" \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
        
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. Foldername: \(folderName). Error: \"\(error)")
            }
        }
    }
    
    private func getURLFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
