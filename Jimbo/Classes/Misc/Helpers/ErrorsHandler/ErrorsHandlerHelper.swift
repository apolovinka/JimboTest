//
//  ErrorsHandlerHelper.swift
//  Ippi
//
//  Created by Alexander Polovinka on 2/26/17.
//  Copyright © 2017 Worldline Communication. All rights reserved.
//

import Foundation


class ErrorsHandlerHelper {

    public class func showAlert(withError error: Error, title: String = "", inViewController viewController: UIViewController) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }

    

}
