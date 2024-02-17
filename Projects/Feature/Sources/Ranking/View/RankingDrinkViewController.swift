//
//  RankingDrinkViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import Combine
import UIKit
import DesignSystem

/// 술 순위를 보여주는 뷰 컨트롤러
final class RankingDrinkViewController: BaseViewController {
    var viewModel: RankingViewModel?
    var detailViewController: DetailDrinkViewController?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(86))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private lazy var rankingDrinkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(RankingDrinkCell.self, forCellWithReuseIdentifier: RankingDrinkCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = RankingViewModel()
        
        bind()
        addViews()
        makeConstraints()
    }
    
    override func addViews() {
        view.addSubview(rankingDrinkCollectionView)
    }
    
    override func makeConstraints() {
        rankingDrinkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Custom Method

extension RankingDrinkViewController {
    private func bind() {
        viewModel?
            .rankingDrinkPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rankingDrinkCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - 콜렉션 뷰 DataSource

extension RankingDrinkViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel?.drinkDatasourceCount() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingDrinkCell.reuseIdentifier, for: indexPath) as? RankingDrinkCell else {
            return UICollectionViewCell()
        }
        
        if let model = viewModel?.drinkDatasource.first?.ranking?[indexPath.item] {
            print(model)
            cell.bind(model)
        }
        
        return cell
    }
}

// MARK: - 콜렉션 뷰 델리게이트

extension RankingDrinkViewController: UICollectionViewDelegate {
    /// !! - DetailDrinkViewController 디자인 테스트
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let rootViewController = RankingViewController()
        let viewController = DetailDrinkViewController()
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.pushViewController(viewController, animated: true)
        // present(viewController, animated: true, completion: nil)
    }
}
