//
//  Style.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 20/02/21.
//

import Foundation
import UIKit

/// Mercado libre style guide
struct Style {
    static let font: Font = Font()
    static let color: Color = Color()
}

struct Font {
    // MARK: Font names
    private let fontName: String = "AvenirNext"
    private var fontRegular: String {
        fontName + "-Regular"
    }
    private var fontBold: String {
        fontName + "-DemiBold"
    }
    
    // MARK: Font sizes
    private let title: CGFloat = 22
    private let h1: CGFloat = 18
    private let h2: CGFloat = 14
    private let h3: CGFloat = 12
    
    // MARK: Guide
    // MARK: - Regular
    /// Font: AvenirNext-Regular Size: 22
    var titleRegular: UIFont {
        UIFont(name: fontRegular, size: title)!
    }
    
    /// Font: AvenirNext-Regular Size: 18
    var h1Regular: UIFont {
        UIFont(name: fontRegular, size: h1)!
    }
    
    /// Font: AvenirNext-Regular Size: 14
    var h2Regular: UIFont {
        UIFont(name: fontRegular, size: h2)!
    }
    
    /// Font: AvenirNext-Regular Size: 12
    var h3Regular: UIFont {
        UIFont(name: fontRegular, size: h3)!
    }
    
    // MARK: - Bold
    /// Font: AvenirNext-Regular Size: 18
    var h1Bold: UIFont {
        UIFont(name: fontBold, size: h1)!
    }
}

// MARK: Color
struct Color {
    var mercadolibre: UIColor {
        UIColor(named: "yellow") ?? UIColor.yellow
    }
    
    var gray: UIColor {
        UIColor(named: "gray") ?? UIColor.gray
    }
    
    var background: UIColor {
        UIColor(named: "background") ?? UIColor.lightGray
    }
    
    var green: UIColor {
        UIColor(named: "green") ?? UIColor.green
    }
    
    var lightGray: UIColor = .lightGray
    
    var blue: UIColor = .systemBlue
}
