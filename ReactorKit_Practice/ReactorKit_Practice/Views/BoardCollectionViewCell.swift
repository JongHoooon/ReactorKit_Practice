//
//  BoardCollectionViewCell.swift
//  10-2-home
//
//  Created by JongHoon on 2022/10/15.
//

import Then
import SnapKit
import UIKit
import ReactorKit

final class BoardCollectionViewCell: UICollectionViewCell, View {

  // MARK: - Constant
  
  struct Constant {
    static let contentLabelNumberOfLines = 2
  }
  
  struct Metric {
    static let cellPadding: CGFloat = 16.0
    static let labelPadding: CGFloat = 8.0
    static let separatorHeight: CGFloat = 0.5
    static let cellCornerRadius: CGFloat = 8.0
  }
  
  struct Font {
    static let titlelabel = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    static let contentLabel = UIFont.systemFont(ofSize: 14.0, weight: .regular)
  }
  
  struct Color {
    static let Label = UIColor.label
  }
  
  // MARK: - Property
  
  var disposeBag: DisposeBag = DisposeBag()
  var reactor: BoardCellReactor? {
    didSet {
      if let reactor = reactor {
        self.bind(reactor: reactor)
      }
    }
  }
  
  // MARK: - UI
  
  private lazy var titleLabel = UILabel().then {
    $0.font = Font.titlelabel
    $0.textColor = Color.Label
  }
  
  private lazy var contentLabel = UILabel().then {
    $0.font = Font.contentLabel
    $0.textColor = Color.Label
    $0.numberOfLines = Constant.contentLabelNumberOfLines
  }
  
  private lazy var separatorView = UIView().then {
    $0.backgroundColor = .quaternaryLabel
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: BoardCellReactor) {
    
    self.titleLabel.text = reactor.currentState.title
    self.contentLabel.text = reactor.currentState.content
  }
}

// MARK: - Method

private extension BoardCollectionViewCell {
  func configureLayout() {
    backgroundColor = .systemBackground
    
    [
      titleLabel,
      separatorView,
      contentLabel
    ].forEach { addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.cellPadding)
      $0.top.equalToSuperview().inset(Metric.cellPadding)
    }
    
    separatorView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.labelPadding)
      $0.leading.trailing.equalTo(Metric.cellPadding)
      $0.height.equalTo(Metric.separatorHeight)
    }
    
    contentLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(separatorView.snp.bottom).offset(Metric.labelPadding)
    }
   
    self.layer.cornerRadius = Metric.cellCornerRadius
    self.clipsToBounds = true
  }
}
