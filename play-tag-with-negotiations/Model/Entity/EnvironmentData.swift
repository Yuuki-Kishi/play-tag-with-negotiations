//
//  EnvironmentData.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/10.
//

import Foundation
import SwiftUI

class EnvironmentData: ObservableObject {
    @Published var isNavigationFromPublicRoomsView: Binding<Bool> = Binding<Bool>.constant(false)
}
