//
//  BoardPost.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/04.
//

import Foundation
import Differentiator
import ReactorKit

struct BoardPost: Codable, Identifiable, Equatable {
  var id = UUID().uuidString
  var title: String
  var content: String
  
  init(title: String, content: String) {
    self.title = title
    self.content = content
  }
  
  init() {
    self.title = "스위프트 코테 스터디"
    self.content = "스위프트 코딩테스트 모집합니다~~"
  }
}




func makeLabel(
  _ title: String,
  content: String
) -> NSMutableAttributedString {
  let result = NSMutableAttributedString(
    string: title,
    attributes: [ .foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 12.0)]
  )
  result.append(NSAttributedString(string: " "))
  result.append(NSMutableAttributedString(
    string: content,
    attributes: [ .foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 12.0)])
  )
  return result
}
