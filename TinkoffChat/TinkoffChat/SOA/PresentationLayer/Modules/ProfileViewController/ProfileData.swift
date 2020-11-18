//
//  ProfileData.swift
//  TinkoffChat
//
//  Created by Ildar on 10/23/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

enum TypesDocument {
    case txt
    case photo
}

struct ProfileDetail {
    var fileDirectory = ""
    var fileDirectoryUrl: URL?
    var previous = ""
    var typeDocument: TypesDocument = .txt
    var text: String? = ""
    var image: UIImage? = UIImage()
    
    init(fileDirectory: String, previous: String = "", typeDocument: TypesDocument, text: String? = "", image: UIImage? = UIImage()) {
        self.fileDirectory = fileDirectory
        self.fileDirectoryUrl = self.fileDirectory(file: fileDirectory)
        self.previous = previous
        self.typeDocument = typeDocument
        self.text = text
        self.image = image
    }
    
    func fileDirectory(file: String) -> URL? {
           if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
               return directory.appendingPathComponent(file)
           } else {
               return nil
           }
       }
}

class ProfileData {
    
    var detailsArray = [ProfileDetail]()
    
    init(details: [ProfileDetail]) {
        for detail in details {
            detailsArray.append(detail)
        }
    }
    
    func save() {
        for detail in detailsArray {
            if let url = detail.fileDirectoryUrl {
                do {
                    if detail.typeDocument == .txt {
                        try detail.text?.write(to: url, atomically: false, encoding: .utf8)
                    } else {
                        if let data = detail.image?.jpegData(compressionQuality: 1) {
                            try data.write(to: url)
                        }
                    }
                } catch {
                    print("error with reading file 1 or first opening VC")
                }
            }
        }
    }
    
    func load() -> [ProfileDetail]? {

        var details = [ProfileDetail]()
        do {
            for detail in detailsArray {
                if let url = detail.fileDirectoryUrl {
                    if detail.typeDocument == .txt {
                        let savedTxt = try String(contentsOf: url, encoding: .utf8)
                        details.append(.init(fileDirectory: detail.fileDirectory, previous: "", typeDocument: .txt, text: savedTxt))
                    } else {
                        let savedImage = UIImage(contentsOfFile: url.path)
                        details.append(.init(fileDirectory: detail.fileDirectory, previous: "", typeDocument: .txt, image: savedImage))
                    }
                }
            }
            return details
        } catch {
            return nil
        }
    }
}
