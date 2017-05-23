//
//  ReelSearchViewModel.swift
//  Showroom
//
//  Created by Abdurahim Jauzee on 23/05/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import Foundation
import RAMReel
import RxSwift

class ReelSearchViewModel {
  
  static var shared = ReelSearchViewModel()
  private init() {}
  
  var dataSource = Variable<SimplePrefixQueryDataSource>(SimplePrefixQueryDataSource([]))

  func initializeDatabase() {
    DispatchQueue.global(qos: .background).async {
      guard
        let dataPath = Bundle.main.path(forResource: "data", ofType: "txt"),
        let reader = try? WordReader(filepath: dataPath) else {
          return
      }
      
      self.dataSource.value = SimplePrefixQueryDataSource(reader.words)
    }
  }
  
}
