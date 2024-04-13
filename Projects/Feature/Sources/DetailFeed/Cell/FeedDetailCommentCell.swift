//
//  FeedDetailCommentCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Combine
import UIKit
import DesignSystem
import Service

final class FeedDetailCommentCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedDetailCommentCell"
    
    private let numberOfSection = 1
    
    private var numberOfItems = 0
    private var parentID = 0
    private var viewModel: CommentViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var commentTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.contentView.addSubview(self.commentTableView)
    }
    
    private func makeConstraints() {
        self.commentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func bind(withID feedID: Int) {
        self.viewModel = CommentViewModel(feedId: feedID)
        self.viewModel?.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                if let count = viewModel?.comments.count {
                    self.numberOfItems = count
                }
                self.commentTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        if self.numberOfItems == 0 {
            let backgroundView = UIView()
            
            backgroundView.backgroundColor = .red
            self.commentTableView.backgroundView = backgroundView
        } else {
            self.commentTableView.backgroundView = nil
        }
    }
}

// MARK: - UITableView DataSource

extension FeedDetailCommentCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSection
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return min(numberOfItems, 5)
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as? CommentCell 
        else { return .init() }
        
        if let comment = viewModel?.comments[indexPath.row] {
            cell.selectionStyle = .none
            cell.bind(comment)
            
            cell.replayLabel.onTapped { [weak self] in
                guard let self = self else { return }
                self.parentID = comment.comment_id
            }
            
            cell.moreButton.onTapped { [weak self] in
                let userId = UserDefaultsUtil.shared.getInstallationId()
                if userId == comment.user_info.user_id {
                    let vc = CommentMoreBottomSheet()
                    vc.viewModel = self?.viewModel
                    vc.requestModel = .init(feed_id: 1, comment_id: comment.comment_id)
                    vc.modalPresentationStyle = .overFullScreen
    //                self?.present(vc, animated: false)
                    
                } else {
                    let vc = SpamBottomSheet()
                    vc.viewModel = self?.viewModel
                    vc.modalPresentationStyle = .overFullScreen
    //                self?.present(vc, animated: false)
                }
            }
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension FeedDetailCommentCell: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
