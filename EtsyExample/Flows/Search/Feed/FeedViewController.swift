//
//  FeedViewController.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Reusable
import CCBottomRefreshControl

protocol FeedViewControllerOutput: FeedModelInput {}
protocol FeedViewControllerInput: FeedModelOutput {}

class FeedViewController: UIViewController, BarButtonCustomable {

  var model: FeedViewControllerOutput!
  weak var output: FeedModelOutput!
  
  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  fileprivate var topRefreshControl = UIRefreshControl()
  fileprivate var bottomRefreshControl = UIRefreshControl()
  fileprivate let minimumSpacing: CGFloat = 15
  fileprivate let triggerVerticalOffset: CGFloat = 70
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.loadItems(refresh: false)
    setupViews()
    setupCollectionView()
    setupRefreshControls()
  }
  
}

fileprivate extension FeedViewController {
  
  func setupViews() {
    navigationItem.backBarButtonItem = buttonWithoutTitle
    navigationItem.title = model.categoryName()
  }

  func setupCollectionView() {
    collectionView.register(cellType: FeedCollectionViewCell.self)
    collectionView.alwaysBounceVertical = true
    collectionView.isScrollEnabled = true
  }
  
  func setupRefreshControls() {
    setupRefreshControl(
      topRefreshControl,
      selector: #selector(FeedViewController.refreshItems)
    )
    collectionView.addSubview(topRefreshControl)
    
    setupRefreshControl(
      bottomRefreshControl,
      selector: #selector(FeedViewController.loadMoreItems)
    )
    collectionView.bottomRefreshControl = bottomRefreshControl
  }
  
  func setupRefreshControl(_ control: UIRefreshControl, selector: Selector) {
    control.tintColor = UIColor(named: .defaultBlueColor)
    control.triggerVerticalOffset = triggerVerticalOffset
    control.addTarget(self, action: selector, for: .valueChanged)
  }
  
    @objc func refreshItems() {
    model.loadItems(refresh: true)
  }
  
    @objc func loadMoreItems() {
    model.loadItems(refresh: false)
  }
  
  func stopRefreshControls() {
    if topRefreshControl.isRefreshing {
      topRefreshControl.endRefreshing()
    }
    
    if bottomRefreshControl.isRefreshing {
      bottomRefreshControl.endRefreshing()
    }
  }
  
  func handleEmptyState(_ numberOfItems: Int) {
    if numberOfItems == 0 {
      let placeholderView = PlaceholderView.loadFromNib()
      collectionView.backgroundView = placeholderView
      placeholderView.title = L10n.feedPlacheholderNoItemsText
      placeholderView.image = Asset.Common.feedPlaceholder.image
    } else {
      collectionView.backgroundView = nil
    }
  }
  
}

extension FeedViewController: FeedViewControllerInput {
  
  func didStartActivity() {
    DispatchQueue.main.async {
      self.showHud(with: L10n.feedHudStartLoadItemsText)
    }
  }
  
  func didFinishActivity(hasNewData: Bool) {
    DispatchQueue.main.async {
      self.stopRefreshControls()
      self.hideHud(
        successStatus: L10n.feedHudEndLoadItemsText,
        completion: {
          if hasNewData {
            self.collectionView.reloadData()
            self.handleEmptyState(self.model.numberOfItems())
          }
      })
    }
  }
  
  func didFinishActivity(error: Error) {
    DispatchQueue.main.async {
      self.stopRefreshControls()
      self.hideHud(errorStatus: error.localizedDescription)
    }
  }
  
  func handleValidationError(_ validationError: String) {
    hideHud(errorStatus: validationError)
  }
  
  func didMissingItems() {
    DispatchQueue.main.async {
      self.showErrorHud(with: L10n.feedHudNoAvailableItemText)
    }
  }
  
}

extension FeedViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.numberOfItems()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath) as FeedCollectionViewCell
    cell.сonfigure(with: model.item(at: indexPath.row))
    model.imageURL(at: indexPath.row) { url in
      cell.setImage(with: url)
    }
    return cell
  }
  
}

extension FeedViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    model.openItemDetails(at: indexPath.row)
  }
  
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let widthWithoutSpacing = collectionView.frame.width - (minimumSpacing * 3)
    return CGSize(
      width: widthWithoutSpacing / 2,
      height: widthWithoutSpacing / 2
    )
  }
  
}
