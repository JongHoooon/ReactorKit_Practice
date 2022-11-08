# ReactorKit_Practice


![Simulator Screen Recording - iPhone 11 Pro - 2022-11-09 at 03 11 24](https://user-images.githubusercontent.com/98168685/200648025-b47f7aaf-8a95-47a6-9e43-9b601b5545f2.gif)


ReactorKit의 [README](https://github.com/ReactorKit/ReactorKit#readme)의 transform() 설명을 참고해보면

> transform()은 각각의 stream을 변형합니다. transform()은 observable stream을 변형하고 결합하는데 사용합니다.
> 

<br> 

reactor가 자기 view에서 발생한 action에 의한 mutation과 다른 view에서 발생한 event에 의한 mutation을 transform()으로 결합하는 코드를 작성해봤습니다.




```swift
// BoardCollectionViewReactor

  // Action에 의해 발생하는 Mutation
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
  
  // BoardEvent에 의해 발생하는 Mutation
  func mutate(boardEvent: BoardEvent) -> Observable<Mutation> {
    switch boardEvent {
    case .create(let boardPost):
      let indexPath = IndexPath(item: 0, section: 0)
      let reactor = BoardCellReactor(boardPost: boardPost)
      return .just(.insertSectionItem(indexPath, reactor))
    }
  }
```
trasform()으로 Action에 의해 발생하는 Mutaion과 BoardEvent에 의해 발생하는 Mutation을 결합했습니다.

```swift
// WriteViewReactor

    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      return self.service.create(
        title: self.currentState.title,
        content: self.currentState.content
      ).map { _ in .dismiss }	// BoardEvent 발생
```


따라서 다른 화면에서 BoardEvent가 발생해도 BoardCollectionViewReactor에서 처리해줄 수 있습니다.

글 작성화면 에서 Done 버튼을 누르면 create에 의해 BoardEvent가 발생하고 Event처리는 BoardCollectionViewReactor 에서 해줍니다.

1. 글 작성 viewController에서 action 발생
2. 글 작성 reactor에서 action에 맞는 mutation 실행, service한테 create 요청
3. service에서 요청 처리 후 내부 PublishSubject에 onNext로 event 발생
4. 글 목록 reactor에서 event를 구독하고 있다가 event onNext가 발생하면 mutate - reduce를 거쳐 state 발생




<br>


> [참고 1](https://github.com/devxoul/RxTodo)
> [참고 2](https://ios-development.tistory.com/784)

