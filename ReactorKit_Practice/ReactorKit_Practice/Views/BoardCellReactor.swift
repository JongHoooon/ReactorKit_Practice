//
//  BoardCellReactor.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//


import ReactorKit
import RxCocoa
import RxSwift

final class BoardCellReactor: Reactor {
  
  enum Action {
    case tapButton
  }
  
  enum Mutation {
    case tapButton
  }
  
  let initialState: BoardPost
  
  init(boardPost: BoardPost) {
    self.initialState = boardPost
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapButton:
      return Observable.just(Mutation.tapButton)
    }
  }
  
  func reduce(state: BoardPost, mutation: Mutation) -> BoardPost {
    let state = state
    
    switch mutation {
    case .tapButton:
      print("tap")
      return state
    }
  }
}
