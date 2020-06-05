//
//  FileReaderWriter.swift
//  TerraCards
//
//  Created by foxy on 21/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


enum FileError: Error {
    case unknown
    case imageNotFound
    case jsonNotFound
    case writingError(error: Error)
    case deletingError(error: Error)
}

struct FileProvider {
    
    typealias Completion = (Result<URL, FileError>) -> Void

    static func fileModificationDate(fileURL: URL) -> Date? {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }

    

    static func getCachedCardImageUrl(name: String?, suffix: String) -> URL {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesURL.appendingPathComponent("\(name ?? "image_default")_\(suffix).png")
    }


    static func getImageFromCache(name: String?, suffix: String, completion: Completion? = nil) -> Image? {
        var image: Image?
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cachesURL.appendingPathComponent("\(name ?? "image_default")_\(suffix).png")
        let filePath = fileURL.path

        if FileManager.default.fileExists(atPath: filePath) {
            print("image trouvée dans le cache")
            image = Image(uiImage: UIImage(contentsOfFile: filePath) ?? UIImage(systemName: "chene")!)
            completion?(.success(fileURL))
            return image
        }
        
        completion?(.failure(.imageNotFound))
        print("image non trouvée")
        return image
    }
    
    static func getJsonFromCacheOrBundle(completion: Completion? = nil) -> Data? {
        print("on cherche le json")
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheFileURL = cachesURL.appendingPathComponent("liste_cartes_default.json")
        let bundleFileURL = Bundle.main.url(forResource: "liste_cartes_default", withExtension: "json")
        
        if FileManager.default.fileExists(atPath: cacheFileURL.path) {
            print("json trouvé dans le cache")
            if let data = try? Data(contentsOf: cacheFileURL) {
                completion?(.success(cacheFileURL))
                return data
            }
        }
        
        if let bundleFileURL = bundleFileURL {
            print("json trouvé dans le bundle")
            if let data = try? Data(contentsOf: bundleFileURL) {
                print("json trouvé dans le bundle")
                completion?(.success(bundleFileURL))
                return data
            }
        }
        
        completion?(.failure(.jsonNotFound))
        print("image non trouvée")
        return nil
    }
    
    static func writeImageInCache(image: UIImage, name: String?, suffix: String?, completion: Completion? = nil) {
        print("on écrit l'image \(suffix ?? "") dans le cache")
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cachesURL.appendingPathComponent("\(name ?? "image_default")_\(suffix ?? "").png")
        do {
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
                print("bien inscrite dans le cache à l'adresse : \(fileURL.path)")
                completion?(.success(fileURL))
            }
        } catch {
            print("erreur inscription dans cache : \(error)")
            completion?(.failure(.writingError(error: error)))
        }
        
    }
    
    static func writeJsonInCache(data: Data) {
       print("on écrit le json dans le cache")
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cachesURL.appendingPathComponent("liste_cartes_default.json")
        do {
                try data.write(to: fileURL, options: .atomic)
                print("json bien inscrit dans le cache à l'adresse : \(fileURL.path)")
            
        } catch {
            print("erreur inscription json dans cache : \(error)")

        }
    }

    static func clearImagesFromCacheFolder(completion: Completion?  = nil) {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheFolderPath = cachesURL.path
        do {
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: cacheFolderPath)
            for filePath in filePaths {
                let fileUrl = URL(fileURLWithPath: filePath)
                print(URL(fileURLWithPath: fileUrl.lastPathComponent).pathExtension)
                if URL(fileURLWithPath: fileUrl.lastPathComponent).pathExtension == "png" {
                    try FileManager.default.removeItem(atPath: cacheFolderPath + "/" + filePath)
                    completion?(.success(cachesURL))
                }
            }
        } catch {
            print("Could not clear cache folder: \(error)")
            completion?(.failure(.deletingError(error: error)))
        }
    }
    
}


