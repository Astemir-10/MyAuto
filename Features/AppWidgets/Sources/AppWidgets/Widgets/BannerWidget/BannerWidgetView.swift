//
//  BannerWidgetView.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import UIKit
import DesignKit

final class BannerWidgetView: UIViewController {
    
    var output: BannerWidgetViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
}

extension BannerWidgetView: BannerWidgetViewInput {
    func setState(_ state: WidgetState) {
        
    }
    
    
}
