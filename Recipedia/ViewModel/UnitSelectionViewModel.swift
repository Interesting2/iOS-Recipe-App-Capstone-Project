//
//  UnitSelectionViewModel.swift
//  Recipedia
//
//  Created by Lawrence Wang on 12/10/2022.
//

import Foundation

final class UnitSelectionViewModel: ObservableObject {
    @Published var currentSelection = UserDefaults.standard.integer(forKey: "unit")
}
