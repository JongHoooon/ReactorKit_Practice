//
//  BoardService.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//

import RxSwift

enum BoardEvent {
  case create(boardPost: BoardPost)
}

protocol BoardServiceType {
  var event: PublishSubject<BoardEvent> { get }
  
  @discardableResult
  func saveBoardPosts(_ boardPosts: [BoardPost]) -> Observable<Void>
  
  func fetchPost() -> Observable<[BoardPost]>
  func create(title: String, content: String) -> Observable<BoardPost>
}

final class BoardService: BoardServiceType {
  
  let event = PublishSubject<BoardEvent>()
  
  func fetchPost() -> Observable<[BoardPost]> {
    if let savedPosts = UserDefaultsService.shared.getBoardPosts() {
      return .just(savedPosts)
    } else {
      let defaultPosts = [BoardPost(), BoardPost(), BoardPost()]
      UserDefaultsService.shared.setBoardPosts(defaultPosts)
      return .just(defaultPosts)
    }
  }
  
  func create(title: String, content: String) -> Observable<BoardPost> {
    return fetchPost()
      .flatMap { [weak self] boardPosts -> Observable<BoardPost> in
        guard let self = self else { return .empty() }
        let newBoardPost = BoardPost(title: title, content: content)
        return self.saveBoardPosts([newBoardPost] + boardPosts).map { newBoardPost }}
      .do(onNext: { task in
        self.event.onNext(.create(boardPost: task))
      })
  }
  
  @discardableResult
  func saveBoardPosts(_ boardPosts: [BoardPost]) -> Observable<Void> {
    UserDefaultsService.shared.setBoardPosts(boardPosts)
    return .just(Void())
  }
}
