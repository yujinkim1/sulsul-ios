//
//  SelectDrinkViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import UIKit
import DesignSystem
import Combine

public class SelectDrinkViewController: SelectTasteBaseViewController {
    
    private let maxSelectNmber = 4
    private var selectIsPossible: Bool = true
    private let viewModel = SelectDrinkViewModel()
   
    var cancelBag = Set<AnyCancellable>()
    private lazy var containerView = UIView()
    
    private lazy var numberLabel = UILabel().then({
        $0.text = "Q1."
        $0.font = Font.regular(size: 18)
        $0.textColor = DesignSystemAsset.gray100.color
    })
    private lazy var titleLabel = UILabel().then({
        $0.text = "주로 마시는 술"
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray100.color
    })
    private lazy var countLabel = UILabel().then({
        $0.text = "0"
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray300.color
    })
    private lazy var selectLabel = UILabel().then({
        $0.text = "개 선택됨"
        $0.font = Font.bold(size: 14)
        $0.textColor = DesignSystemAsset.gray300.color
    })
    
    private lazy var drinkCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16

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
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
        bind()
    }
    public override func addViews() {
        super.addViews()
        view.addSubview(containerView)
        containerView.addSubviews([numberLabel,
                                   titleLabel,
                                   countLabel,
                                   selectLabel,
                                   drinkCollectionView])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(selectLabel.snp.leading)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        selectLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(countLabel.snp.centerY)
        }
        drinkCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 32))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitTouchableLabel.snp.top)
        }
    }
    private func bind() {
        viewModel.currentSelectedDrinkPublisher()
            .sink { [weak self] result in
                print(result)
                self?.countLabel.text = String(result)
            }
            .store(in: &cancelBag)
    }
    public override func setupIfNeeded() {
        
    }
}

extension SelectDrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSourceCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCell.reuseIdentifer, for: indexPath) as? DrinkCell else { return UICollectionViewCell() }
        
        let model = viewModel.getDataSource(indexPath.row)
        cell.model = model
        if model.isSelect {
            cell.containerView.backgroundColor = .blue
        } else {
            cell.containerView.backgroundColor = .red
        }
        
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? DrinkCell {
            viewModel.selectDataSource(indexPath.row)
            collectionView.reloadData()
        }
    }

}

extension SelectDrinkViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let itemWidth = (collectionView.bounds.width - 16 * (numberOfItemsPerRow - 1)) / numberOfItemsPerRow
        let itemHeight: CGFloat = moderateScale(number: 146)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
