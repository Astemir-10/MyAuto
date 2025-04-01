//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import UIKit

final class DocumentDetailsViewController: UIViewController {
    
    var output: DocumentDetailsViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
    
}

extension DocumentDetailsViewController: DocumentDetailsViewInput {

}
