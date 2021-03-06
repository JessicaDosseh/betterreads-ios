//
//  Helpers.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/22/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

// Animation
extension UIView {
  func performFlare() {
    func flare() { transform = CGAffineTransform( scaleX: 1.03, y: 1.04) }
    func unflare() { transform = .identity }
    UIView.animate(withDuration: 0.15,
                   animations: { flare() },
                   completion: { _ in UIView.animate(withDuration: 0.7) { unflare() }})
  }
}
// Color Palette
extension UIColor {
    /// Trinidad Orange #D44808
    static let trinidadOrange = UIColor(red: 212.0/255.0, green: 72.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    /// Tundra #404040
    static let tundra = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    /// Dove Gray #737373
    static let doveGray = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    /// Alto Gray #D9D9D9
    static let altoGray = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    /// Cinnabar Red #E33434
    static let cinnabarRed = UIColor(red: 208.0/255.0, green: 68.0/255.0, blue: 61.0/255.0, alpha: 1.0)
}
// Alerts
extension UIViewController {
    func showBasicAlert(alertText: String, alertMessage: String) {
        let alert = UIAlertController(title: alertText,
                                      message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Segmented Control Background & Divider Image on Sign Up/Sign In Screen
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
}
// Break down User's full name into first and last
extension Name {
    init(fullName: String) {
        var names = fullName.components(separatedBy: " ")
        let first = names.removeFirst()
        let last = names.joined(separator: " ")
        self.init(first: first, last: last)
    }
}

extension Name: CustomStringConvertible {
    var description: String { return "\(first) \(last)" }
}
