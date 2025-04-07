//
//  Color+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import SwiftUI
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    func withReducedOpacity(by factor: CGFloat) -> UIColor {
        let originalComponents = cgColor.components ?? [0, 0, 0, 1]
        let red = originalComponents[0]
        let green = originalComponents[1]
        let blue = originalComponents[2]
        let alpha = originalComponents[3]

        // Calculate the new alpha
        let newAlpha = max(min(alpha * factor, 1.0), 0.0)

        return UIColor(red: red, green: green, blue: blue, alpha: newAlpha)
    }
}

extension Color {
    init(hex: Int) {
        self.init(uiColor: UIColor(rgb: hex))
    }

    init(hexString string: String) {
        var string = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        switch string.count {
        case 2:
            let mask = 0xFF
            let g = Int(color) & mask
            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        case 4:
            let mask = 0x00FF
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        case 6:
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        case 8:
            let mask = 0x0000_00FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        default:
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 1)
        }
    }

    var alphaComponent: CGFloat {
        getComponents()?.alpha ?? .zero
    }

    var blueComponent: CGFloat {
        getComponents()?.blue ?? .zero
    }

    var greenComponent: CGFloat {
        getComponents()?.green ?? .zero
    }

    var hexString: String {
        let components = getComponents()
        let red = Int((components?.red ?? 0) * 255)
        let green = Int((components?.green ?? 0) * 255)
        let blue = Int((components?.blue ?? 0) * 255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }

    var hexStringWithAlpha: String {
        let components = getComponents()
        let red = Int((components?.red ?? 0) * 255)
        let green = Int((components?.green ?? 0) * 255)
        let blue = Int((components?.blue ?? 0) * 255)
        let alpha = Int((components?.alpha ?? 1.0) * 255)
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }

    var redComponent: CGFloat {
        getComponents()?.red ?? .zero
    }

    func darkened(by percentage: CGFloat) -> Color {
        // Convert Color to UIColor (for iOS)
        let uiColor = UIColor(self)

        // Extract HSB components
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }

        // Adjust the brightness component
        let newBrightness = max(brightness - brightness * percentage, 0.0)

        // Create a new UIColor with adjusted brightness
        let darkenedUIColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)

        // Convert UIColor back to Color
        return Color(darkenedUIColor)
    }

    func getComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        }
        return nil
    }

    func toHex() -> Int {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        let intRed = Int(red * 255)
        let intGreen = Int(green * 255)
        let intBlue = Int(blue * 255)

        return intRed << 16 + intGreen << 8 + intBlue
    }
}
