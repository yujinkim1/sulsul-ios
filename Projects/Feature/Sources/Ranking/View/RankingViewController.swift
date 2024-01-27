//
//  RankingViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import Combine
import UIKit

public final class RankingViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    var viewModel: RankingViewModel?
    
    private var viewControllers: [UIViewController] = []
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "이번주 랭킹"
        $0.font = Font.bold(size: 28)
        $0.setTextLineHeight(height: 38)
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var weekendLabel = UILabel().then {
        $0.text = "MM/dd ~ MM/dd"
        $0.font = Font.regular(size: 14)
        $0.setTextLineHeight(height: 22)
        $0.textColor = DesignSystemAsset.gray600.color
    }
    
    private lazy var pageTabBarContainerView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var horizontalFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var pageTabBarView = UICollectionView(frame: .zero, collectionViewLayout: horizontalFlowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(RankingPageTabBarCell.self, forCellWithReuseIdentifier: RankingPageTabBarCell.reuseIdentifier)
    }
    
    private lazy var indicatorView = UIView().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var rankingDrinkViewController = RankingDrinkViewController()
    
    private lazy var rankingCombinationViewController = RankingCombinationViewController()
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = RankingViewModel()
        
        bind()
        addViews()
        makeConstraints()
        configurePageViewController()
    }
    
    public override func addViews() {
        pageTabBarContainerView.addSubview(pageTabBarView)
        view.addSubviews([titleLabel, weekendLabel, pageTabBarContainerView, indicatorView, pageViewController.view])
        addChild(pageViewController)
    }
    
    public override func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.top.equalToSuperview().offset(moderateScale(number: 52))
        }
        weekendLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.bottom.equalTo(titleLabel)
        }
        pageTabBarContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.height.equalTo(moderateScale(number: 40))
        }
        pageTabBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalToSuperview()
        }
        indicatorView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(pageTabBarView.snp.width).dividedBy(2)
            $0.top.equalTo(pageTabBarContainerView.snp.bottom)
            $0.leading.equalTo(pageTabBarView)
        }
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 16))
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Custom Method

extension RankingViewController {
    private func bind() {
        viewModel?
            .rankingBasePublisher
            .sink { [weak self] data in
                guard let self = self,
                      let startDate = data.first?.startDate,
                      let endDate = data.first?.endDate else { return }
                self.weekendLabel.text = "\(startDate) ~ \(endDate)"
            }
            .store(in: &cancelBag)
    }
    
    private func configurePageViewController() {
        viewControllers = [rankingDrinkViewController, rankingCombinationViewController]
        
        pageViewController.didMove(toParent: self)
        
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: false)
    }
}

// MARK: - 페이지 탭바 콜렉션 뷰 DataSource

extension RankingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingPageTabBarCell.reuseIdentifier, for: indexPath) as? RankingPageTabBarCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == 0 {
            cell.configure(text: "술")
            
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else if indexPath.item == 1 {
            cell.configure(text: "술+안주")
        }
        
        return cell
    }
}

// MARK: - 페이지 탭바 콜렉션 뷰 델리게이트

extension RankingViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let position = CGFloat(indexPath.item) * itemWidth
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints {
                $0.height.equalTo(2)
                $0.width.equalTo(self.pageTabBarView.snp.width).dividedBy(2)
                $0.top.equalTo(self.pageTabBarContainerView.snp.bottom)
                $0.leading.equalTo(self.pageTabBarView).offset(position)
            }
            
            self.view.layoutIfNeeded()
        }
        
        let selectedViewController = viewControllers[indexPath.item]
        
        let direction: UIPageViewController.NavigationDirection = indexPath.item > 0 ? .forward : .reverse
        
        pageViewController.setViewControllers([selectedViewController], direction: direction, animated: true) { [weak self] _ in
            self?.updateTabIndex()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let itemWidth = scrollView.bounds.width / CGFloat(2)
        
        let selectedItem = Int((contentOffsetX + itemWidth / 2) / itemWidth)
        
        if selectedItem >= 0 && selectedItem < 2 {
            let indexPath = IndexPath(item: selectedItem, section: 0)
            pageTabBarView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - 페이지 탭바 CollectionViewFlowLayout 델리게이트

extension RankingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let itemHeight = moderateScale(number: 40)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - 페이지 뷰 컨트롤러 DataSource

extension RankingViewController: UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        
        return viewControllers[previousIndex]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        guard nextIndex < viewControllers.count else { return nil }
        
        return viewControllers[nextIndex]
    }
}

// MARK: - 페이지 뷰 컨트롤러 델리게이트

extension RankingViewController: UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        pageTabBarView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView(pageTabBarView, didSelectItemAt: indexPath)
    }
    
    private func updateTabIndex() {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
        
        print("Current selected tab index: \(currentIndex)")
    }
}
