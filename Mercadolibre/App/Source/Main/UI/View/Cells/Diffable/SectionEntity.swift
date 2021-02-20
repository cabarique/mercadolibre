//
//  SectionEntity.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 20/02/21.
//

import Foundation

class SectionEntity: Hashable {
  var id = UUID()
  var title: String
  var items: [ItemEntity]
  
  init(title: String, items: [ItemEntity]) {
    self.title = title
    self.items = items
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: SectionEntity, rhs: SectionEntity) -> Bool {
    lhs.id == rhs.id
  }
}
