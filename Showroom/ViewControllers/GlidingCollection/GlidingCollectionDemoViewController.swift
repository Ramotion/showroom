//
//  ViewController.swift
//  GlidingCollectionDemo
//
//  Created by Abdurahim Jauzee on 04/03/2017.
//  Copyright © 2017 Ramotion Inc. All rights reserved.
//

import UIKit
import GlidingCollection


class GlidingCollectionDemoViewController: UIViewController {
  
  fileprivate var glidingView: GlidingCollection!
  fileprivate var collectionView: UICollectionView!
  fileprivate var items = ["gloves", "boots", "bindings", "hoodie"]
  fileprivate var images: [[UIImage?]] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    // Setup Showroom
    _ = MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.glidingCollection.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }
  
}

// MARK: - Setup
extension GlidingCollectionDemoViewController {
  
  func setup() {
    setupGlidingCollectionView()
    loadImages()
  }
  
  private func setupGlidingCollectionView() {
    var config = GlidingConfig.shared
    config.buttonsFont = UIFont.boldSystemFont(ofSize: 22)
    config.inactiveButtonsColor = config.activeButtonColor
    GlidingConfig.shared = config
    
    glidingView = GlidingCollection(frame: view.bounds)
    glidingView.backgroundColor = UIColor.white
    view = glidingView
    glidingView.dataSource = self
    
    let nib = UINib(nibName: "CollectionCell", bundle: nil)
    collectionView = glidingView.collectionView
    collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = glidingView.backgroundColor
  }
  
  private func loadImages() {
    for item in items {
      let imageURLs = FileManager.default.fileUrls(for: "jpeg", fileName: item)
      var images: [UIImage?] = []
      for url in imageURLs {
        guard let data = try? Data(contentsOf: url) else { continue }
        let image = UIImage(data: data)
        images.append(image)
      }
      self.images.append(images)
    }
  }
  
}

// MARK: - CollectionView 🎛
extension GlidingCollectionDemoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let section = glidingView.expandedItemIndex
    return images[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
    let section = glidingView.expandedItemIndex
    let image = images[section][indexPath.row]
    cell.imageView.image = image
    cell.contentView.clipsToBounds = true
    
    let layer = cell.layer
    let config = GlidingConfig.shared
    layer.shadowOffset = config.cardShadowOffset
    layer.shadowColor = config.cardShadowColor.cgColor
    layer.shadowOpacity = config.cardShadowOpacity
    layer.shadowRadius = config.cardShadowRadius
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let section = glidingView.expandedItemIndex
    let item = indexPath.item
    print("Selected item #\(item) in section #\(section)")
  }
  
}

// MARK: - Gliding Collection 🎢
extension GlidingCollectionDemoViewController: GlidingCollectionDatasource {
  
  func numberOfItems(in collection: GlidingCollection) -> Int {
    return items.count
  }
  
  func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String {
    return "– " + items[index]
  }
  
}
