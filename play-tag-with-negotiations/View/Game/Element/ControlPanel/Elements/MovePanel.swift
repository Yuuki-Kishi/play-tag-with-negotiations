//
//  MovePanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct MovePanel: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.left.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.left.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "octagon.fill")
                        .font(.system(size: 90).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.left.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.right.square.fill")
                        .font(.system(size: 100).weight(.semibold))
                })
            }
        }
    }
}

#Preview {
    MovePanel()
}
