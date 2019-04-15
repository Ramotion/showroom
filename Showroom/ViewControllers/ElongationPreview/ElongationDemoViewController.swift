//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview


class ElongationDemoViewController: ElongationViewController {
  
  var datasource: [Villa] = Villa.testData
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()

    // Setup Showroom
    _ = MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.elongationPreview.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func openDetailView(for indexPath: IndexPath) {
    let detailViewController = ElongationDemoDetailViewController(style: .grouped)
    let villa = datasource[indexPath.row]
    detailViewController.title = villa.title
    expand(viewController: detailViewController)
  }
  
}

// MARK: - Setup ⛏
private extension ElongationDemoViewController {
  
  func setup() {
    view.backgroundColor = .black
    tableView.backgroundColor = UIColor.black
    tableView.registerNib(DemoElongationCell.self)
  }
  
}

// MARK: - TableView 📚
extension ElongationDemoViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(DemoElongationCell.self)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    guard let cell = cell as? DemoElongationCell else { return }
    
    let villa = datasource[indexPath.row]
    
    let attributedLocality = NSAttributedString(string: villa.locality.uppercased(), attributes: [
        kCTFontAttributeName: UIFont.robotoFont(ofSize: 22, weight: .medium),
        kCTKernAttributeName: 8.2,
        kCTForegroundColorAttributeName: UIColor.white
        ] as [NSAttributedString.Key : Any])
    
    cell.topImageView?.image = UIImage(named: villa.imageName)
    cell.localityLabel?.attributedText = attributedLocality
    cell.countryLabel?.text = villa.country
    cell.aboutTitleLabel?.text = villa.title
    cell.aboutDescriptionLabel?.text = villa.description
  }
  
}
