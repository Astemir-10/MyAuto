import UIKit

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension CGImage {
    static func drawRainDrop() -> CGImage? {
        let size = CGSize(width: 10, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func drawPoint() -> CGImage? {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func drawLine() -> CGImage? {
        let size = CGSize(width: 420, height: 5)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func blurCGImage(_ image: CGImage, radius: CGFloat) -> CGImage? {
        let ciImage = CIImage(cgImage: image)
        let context = CIContext()
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = blurFilter?.outputImage else {
            return nil
        }
        
        return context.createCGImage(outputImage, from: outputImage.extent)
    }
}

public extension UIViewController {
    
    var topViewController: UIViewController? {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
                return nil
        }
        return topViewController(for: rootViewController)
    }

    private func topViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topViewController(for: presentedController)
        } else if let navController = controller as? UINavigationController,
                  let visible = navController.visibleViewController {
            return topViewController(for: visible)
        } else if let tabController = controller as? UITabBarController,
                  let selected = tabController.selectedViewController {
            return topViewController(for: selected)
        } else {
            return controller
        }
    }
}

public extension UIImage {
    static func emojiToImage(emoji: String, size: CGFloat) -> UIImage {
        let font = UIFont.systemFont(ofSize: size)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = emoji.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(textSize, false, 0.0)
        emoji.draw(in: CGRect(origin: .zero, size: textSize), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

public protocol ConvertibleToDictionary: Codable {
    func toDictionary() -> [String: Any]
    init(from dictionary: [String: Any]) throws
}

public extension Array<ConvertibleToDictionary> {
    func toDictionary() -> [[String: Any]] {
        let encoder = JSONEncoder()
        
        // Настроим кастомный форматтер для Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        do {
            let data = try encoder.encode(try self.map({ try encoder.encode($0) }))
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                return jsonObject as? [[String: Any]] ?? []
            }
        } catch {
            print("Ошибка при кодировании структуры: \(error)")
        }
        return []
    }
}

public extension ConvertibleToDictionary {
    
    // Преобразование структуры в словарь
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        
        // Настроим кастомный форматтер для Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        do {
            let data = try encoder.encode(self)
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                return jsonObject as? [String: Any] ?? [:]
            }
        } catch {
            print("Ошибка при кодировании структуры: \(error)")
        }
        return [:]
    }
    
    // Инициализация структуры из словаря
    init(from dictionary: [String: Any]) throws {
        let decoder = JSONDecoder()
        
        // Настроим кастомный форматтер для Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            self = try decoder.decode(Self.self, from: data)
        } else {
            throw NSError(domain: "Invalid dictionary", code: 1, userInfo: nil)
        }
    }
}

public extension Dictionary<String, Any> {
    func toJsonData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}

public extension Array<Dictionary<String, Any>> {
    func toJsonData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
