//
//  SelectDrinkViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import UIKit
import DesignSystem
import Combine

public class SelectDrinkViewController: BaseViewController {
    private let viewModel = SelectDrinkViewModel()
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var dataSource: [Pairing] = []
    var cancelBag = Set<AnyCancellable>()
    private lazy var containerView = UIView()
    
    private lazy var numberLabel = UILabel().then({
        $0.text = "Q1"
    })
    private lazy var titleLabel = UILabel().then({
        $0.text = "주로 마시는 술"
    })
    
    private lazy var drinkCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: DrinkCell.reuseIdentifer)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.gray050.color
        addViews()
        makeConstraints()
        bind()
    }
    public override func addViews() {
        view.addSubview(containerView)
        containerView.addSubviews([titleLabel,
                                   drinkCollectionView])
    }
    public override func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 100))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalToSuperview().inset(48)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        drinkCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func bind() {
        viewModel.pairingsValuePublisher()
            .sink { [weak self] result in
                self?.dataSource = result.pairings ?? []
                self?.drinkCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    public override func setupIfNeeded() {
        
    }
}

extension SelectDrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCell.reuseIdentifer, for: indexPath) as? DrinkCell else { return UICollectionViewCell() }
        cell.setDrinkData(image: "", name: dataSource[indexPath.row].name ?? "")
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapCell(at: indexPath)
    }
    
    private func didTapCell(at indexPath: IndexPath) {
        
    }
}

extension SelectDrinkViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
