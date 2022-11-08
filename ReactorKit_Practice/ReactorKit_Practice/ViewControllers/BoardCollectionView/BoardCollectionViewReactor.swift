//
//  BoardCollectionViewReactor.swift
//  RxDataSource_Practice
//
//  Created by JongHoon on 2022/11/04.
//

import UIKit
import RxDataSources
import ReactorKit
import RxSwift
import RxCocoa

// Differentiator 사용
typealias SectionOfBoardPost = SectionModel<Void, BoardCellReactor>

final class BoardCollectionViewReactor: Reactor {
  
  // MARK: - Model
  
  enum Action {
    case refresh
  }
  
  enum Mutation {
    case setSections([SectionOfBoardPost])
    case insertSectionItem(IndexPath, SectionOfBoardPost.Item)
  }
  
  struct State {
    var sections: [SectionOfBoardPost]
    
  }
  
  // MARK: - Property
  
  let initialState: State
  let boardService: BoardServiceType
  
  // MARK: - Initializing
  
  init(initialState: State, boardService: BoardServiceType) {
    self.initialState = initialState
    self.boardService = boardService
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    var newMutation: Observable<Mutation>
    switch action {
      
    case .refresh:
      newMutation = self.getRefreshMutaion()
    
    }
    return newMutation
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let boaderEventMutaion = self.boardService.event
      .flatMap { [weak self] boardEvent -> Observable<Mutation> in
        self?.mutate(boardEvent: boardEvent) ?? .empty()
      }
    return Observable.of(mutation, boaderEventMutaion).merge()
  }
  
  func mutate(boardEvent: BoardEvent) -> Observable<Mutation> {
    switch boardEvent {
      
    case .create(let boardPost):
      let indexPath = IndexPath(item: 0, section: 0)
      let reactor = BoardCellReactor(boardPost: boardPost)
      return .just(.insertSectionItem(indexPath, reactor))
    
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case .setSections(let sections):
      state.sections = sections
      return state
    case let .insertSectionItem(indexPath, sectionItem):
      state.sections.insert(sectionItem, at: indexPath)
      return state
    }
  }
}

// MARK: - Method

extension BoardCollectionViewReactor {
  
  // MARK: Mutation
  private func getRefreshMutaion() -> Observable<Mutation> {
    
    let boardPosts = boardService.fetchPost()
    
    return boardPosts.map { boardPosts in
      let sectionItems = boardPosts.map(BoardCellReactor.init)
      let section = SectionOfBoardPost(model: Void(), items: sectionItems)
      return .setSections([section])
    }
  }
  
  func reactorForWrite() -> WriteViewReactor {
    return WriteViewReactor(service: self.boardService)
  }
}
