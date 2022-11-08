//
//  WriteViewController.swift
//  ReactorKit_Practice
//
//  Created by JongHoon on 2022/11/08.
//

import UIKit
import ReactorKit
import SnapKit

final class WriteViewController: UIViewController, View {
  
  // MARK: - Property
  
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  private lazy var titleTextField = UITextField().then {
    $0.becomeFirstResponder()
    $0.placeholder = "제목 입력"
    $0.borderStyle = .roundedRect
  }
  
  private lazy var contentTextField = UITextField().then {
    $0.placeholder = "내용을 입력하세요"
    $0.borderStyle = .roundedRect
  }
  
  private lazy var doneBarButton = UIBarButtonItem(systemItem: .done)
  
  private lazy var cancelBarButton = UIBarButtonItem(systemItem: .cancel)
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
  }
  
  // MARK: - Initialize
  init(reactor: WriteViewReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Binding
  
  func bind(reactor: WriteViewReactor) {
    
    // MARK: Action
    let titleText = titleTextField.rx.text.orEmpty
    let contentText = contentTextField.rx.text.orEmpty
    
    Observable.combineLatest(titleText, contentText) { Reactor.Action.updateWrite(
      title: $0,
      content: $1
    )}
    .bind(to: reactor.action)
    .disposed(by: self.disposeBag)
    
    doneBarButton.rx.tap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    cancelBarButton.rx.tap
      .map { Reactor.Action.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // MARK: State
    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneBarButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.isDismissed }
      .distinctUntilChanged()
      .filter{ $0 }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.dismiss(animated: true)
      })
      .disposed(by: self.disposeBag)
    
  }
}

// MARK: - Method

private extension WriteViewController {
  
  func configureLayout() {
    self.view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = doneBarButton
    navigationItem.leftBarButtonItem = cancelBarButton
    
    [
      titleTextField,
      contentTextField
    ].forEach { self.view.addSubview($0) }
    
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
    }
    
    contentTextField.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(32.0)
      $0.leading.trailing.equalTo(titleTextField)
    }
  }
}
