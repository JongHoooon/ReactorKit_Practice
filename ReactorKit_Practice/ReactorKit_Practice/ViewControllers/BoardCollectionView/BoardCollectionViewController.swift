//
//  BoardCollectionViewController.swift
//  RxDataSource_Practice
//
//  Created by JongHoon on 2022/11/04.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import ReactorKit
import RxViewController

class BoardCollectionViewController: UIViewController, StoryboardView {
  
  
  // MARK: - Property
  
  var disposeBag = DisposeBag()
  
  
  let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBoardPost>(
    configureCell: { dataSource, collectionView, indexPath, reactor in
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "Cell",
        for: indexPath
      ) as? BoardCollectionViewCell
      cell?.reactor = reactor
      
      return cell ?? UICollectionViewCell()
      
    }
  )
    
  // MARK: - UI
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var writeButton: UIButton!
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.backgroundColor = .systemGray6
    self.collectionView.register(
      BoardCollectionViewCell.self,
      forCellWithReuseIdentifier: "Cell"
    )
    
  }
  
  // MARK: - Binding
  
  func bind(reactor: BoardCollectionViewReactor) {
        
    // MARK: Action
    
    self.rx.viewWillAppear
      .map { _ in Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    writeButton.rx.tap
      .map { reactor.reactorForWrite() }
      .subscribe(onNext: { [weak self] reactor in
        guard let self = self else { return }
        let viewController = WriteViewController(reactor: reactor)
        let navigationeController = UINavigationController(rootViewController: viewController)
        self.present(navigationeController, animated: true)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: {
        print("\($0)")
      })
      .disposed(by: self.disposeBag)
    
      
  
    // MARK: State
    
    reactor.state.asObservable().map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension BoardCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 8, height: 120.0)
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: 4.0, left: 0,
      bottom: 4.0, right: 0
    )
  }
}
