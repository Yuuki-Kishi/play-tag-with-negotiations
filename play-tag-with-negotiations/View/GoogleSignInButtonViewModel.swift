//
//  GoogleSignInButtonViewModel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/18.
//

import Foundation
import GoogleSignInSwift

public class GoogleSignInButtonViewModel: ObservableObject {
    @Published public var scheme: GoogleSignInButtonColorScheme
    @Published public var style: GoogleSignInButtonStyle
    @Published public var state: GoogleSignInButtonState
    
    var buttonStyle: SwiftUIButtonStyle {
        return SwiftUIButtonStyle(style: style, state: state, scheme: scheme)
    }
    
    public init(
        scheme: GoogleSignInButtonColorScheme = .light,
        style: GoogleSignInButtonStyle = .standard,
        state: GoogleSignInButtonState = .normal) {
            self.scheme = scheme
            self.style = style
            self.state = state
        }
}
