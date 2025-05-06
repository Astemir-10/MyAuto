//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 21.09.2024.
//

import Foundation

public enum MultipartFormData {
    
    public static func createFormData(from fields: [String: String?]) -> (data: Data, contentType: String) {
        let boundary = "----WebKitFormBoundary\(UUID().uuidString)"
        var httpBody = Data()
        
        for (name, value) in fields {
            let value = value ?? ""
            
            var fieldData = ""
            fieldData += "--\(boundary)\r\n"
            fieldData += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
            fieldData += "\(value)\r\n"
            
            if let data = fieldData.data(using: .utf8) {
                httpBody.append(data)
            }
        }
        
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        return (data: httpBody, contentType: contentType)
    }

}
