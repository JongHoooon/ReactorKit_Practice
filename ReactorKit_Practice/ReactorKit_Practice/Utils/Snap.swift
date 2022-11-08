//
//  Snap.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//

import UIKit

/// Ceil to snap pixel
func snap(_ x: CGFloat) -> CGFloat {
  let scale = UIScreen.main.scale
  return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
  return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
  return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}
