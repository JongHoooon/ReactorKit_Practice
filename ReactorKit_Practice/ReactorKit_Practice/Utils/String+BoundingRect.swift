//
//  String+BoundingRect.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//

import UIKit

extension String {
  
  func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }
  
  func size(fits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    var size = self.boundingRect(with: size, attributes: attributes).size
    if maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    return size
  }
  
  func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
  }
  
  func height(fits width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
  }
}
