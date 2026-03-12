//
//  FontType.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

public enum FontType {
    case black
    case bold
    case book
    case light
    case medium
    case regular
    
    var fontName: String {
        switch self {
        case .black:
            return "TBCContracticaCAPS-Black"
        case .bold:
            return "TBCContracticaCAPS-Bold"
        case .book:
            return "TBCContracticaCAPS-Book"
        case .light:
            return "TBCContracticaCAPS-Light"
        case .medium:
            return "TBCContracticaCAPS-Medium"
        case .regular:
            return "TBCContracticaCAPS-Regular"
        }
    }
    
    func fontType(size: CGFloat) -> Font {
        return .custom(fontName, size: size)
    }
    
}
