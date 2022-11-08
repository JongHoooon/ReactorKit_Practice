//
//  UserDefualtsService.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//

import Foundation


final class UserDefaultsService {
  
  struct UserDefaultKey {
    static let boardPosts = "boardPosts"
  }
  
  static let shared = UserDefaultsService()

  private var defaults: UserDefaults {
    return UserDefaults.standard
  }
  
  func setBoardPosts(_ boardPosts: [BoardPost]) {
    defaults.setValue(
      try? JSONEncoder().encode(boardPosts),
      forKey: UserDefaultKey.boardPosts
    )
  }

  func getBoardPosts() -> [BoardPost]? {
    guard let data = defaults.data(forKey: UserDefaultKey.boardPosts) else { return nil }
    return (
      try? JSONDecoder().decode(
        [BoardPost].self,
        from: data
      )
    )
  }
}
