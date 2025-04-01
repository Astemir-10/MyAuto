//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation

public enum AppFileManagerError: Error {
    case saveError, deletingError, getError
}

final public class AppFileManager {
    
    public init() {}
    // Получить путь к Documents
    private func documentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private  func getFolderPath(folderName: String) -> URL? {
        guard let docs = documentsDirectory() else { return nil }
        let folderURL = docs.appendingPathComponent(folderName)

        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Ошибка создания папки: \(error.localizedDescription)")
                return nil
            }
        }

        return folderURL
    }
    
    public func createFile(folder: String? = nil, fileName: String, content: Data) -> Result<Data, AppFileManagerError> {
        var folderURL: URL?
        if let folder {
            guard let directory = getFolderPath(folderName: folder) else { return .failure(.saveError) }
            folderURL = directory
        } else {
            guard let directory = documentsDirectory() else { return .failure(.saveError) }
            folderURL = directory
        }

        guard let folderURL else {
            return .failure(.saveError)
        }
        
        let fileURL = folderURL.appendingPathComponent(fileName)

        // Запись данных в файл
        do {
            try content.write(to: fileURL)
            print("Файл успешно создан: \(fileURL.path)")
            return .success(content)
        } catch {
            print("Ошибка при создании файла: \(error.localizedDescription)")
            return .failure(.saveError)
        }
    }
    
    // Удаление файла по имени
    public func deleteFile(folder: String? = nil, fileName: String) -> Result<String, AppFileManagerError> {
        var folderURL: URL?
        if let folder {
            guard let directory = getFolderPath(folderName: folder) else { return .failure(.deletingError) }
            folderURL = directory
        } else {
            guard let directory = documentsDirectory() else { return .failure(.deletingError) }
            folderURL = directory
        }

        guard let folderURL else {
            return .failure(.saveError)
        }
        let fileURL = folderURL.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Файл успешно удалён: \(fileURL.path)")
                return .success(fileName)
            } catch {
                print("Ошибка при удалении файла: \(error.localizedDescription)")
                return .failure(.deletingError)
            }
        } else {
            print("Файл не найден по пути: \(fileURL.path)")
            return .failure(.deletingError)
        }
    }

    public func saveImageWithReplace(folder: String? = nil, fileName: String, content: Data) -> Result<URL, AppFileManagerError> {
        var folderURL: URL?
        if let folder {
            guard let directory = getFolderPath(folderName: folder) else { return .failure(.saveError) }
            folderURL = directory
        } else {
            guard let directory = documentsDirectory() else { return .failure(.saveError) }
            folderURL = directory
        }

        guard let folderURL else {
            return .failure(.saveError)
        }

        let fileURL = folderURL.appendingPathComponent(fileName)
        
        // Проверяем, есть ли уже файл с таким названием и удаляем его
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Существующий файл удалён: \(fileURL.lastPathComponent)")
            } catch {
                print("Ошибка при удалении старого файла: \(error.localizedDescription)")
                return .failure(.saveError)
            }
        }
        
        // Сохраняем новую фотографию
        do {
            try content.write(to: fileURL)
            print("Фотография успешно сохранена: \(fileURL.path)")
            return .success(fileURL)
        } catch {
            print("Ошибка при сохранении фотографии: \(error.localizedDescription)")
            return .failure(.saveError)
        }
    }
    
    public func getFile(folder: String? = nil, fileName: String) -> Result<Data, AppFileManagerError> {
        var folderURL: URL?
        if let folder {
            guard let directory = getFolderPath(folderName: folder) else { return .failure(.getError) }
            folderURL = directory
        } else {
            guard let directory = documentsDirectory() else { return .failure(.getError) }
            folderURL = directory
        }

        guard let folderURL else {
            return .failure(.saveError)
        }

        let fileURL = folderURL.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                return .success(data)
            } catch {
                return .failure(.getError)
            }
        } else {
            print("Файл не найден: \(fileURL.path)")
            return .failure(.getError)
        }
    }
}
