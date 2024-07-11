//
//  FieldMap.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import SwiftUI

struct FieldMap: View {
    @State private var horizontalCount: Int = 10
    @State private var verticalCount: Int = 10
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: horizontalCount)
        
        ScrollView([.horizontal, .vertical]) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0 ..< horizontalCount * verticalCount) { num in
                    Text(changeToCoordinate(num: num))
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .background(Color.gray)
                }
            }
            .padding()
        }
    }
    func changeToCoordinate(num: Int) -> String {
        let x = num % horizontalCount
        let y = num / horizontalCount
        let coordinate = "(" + String(x) + ", " + String(y) + ")"
        return coordinate
    }
}

#Preview {
    FieldMap()
}
