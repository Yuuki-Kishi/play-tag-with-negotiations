//
//  MyPageView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/13.
//

import SwiftUI
import PhotosUI

struct MyPageView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var selectedImage: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            PhotosPicker(selection: $selectedImage) {
                if let iconImage = getIconUIImage() {
                    Image(uiImage: iconImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .scaledToFit()
                        .font(.system(size: 200.0).weight(.ultraLight))
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6, alignment: .center)
            .onChange(of: selectedImage, {
                Task {
                    await Upload.uploadIconImage(selectedItem: selectedImage)
                }
            })
            MyPageListView(userDataStore: userDataStore)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("マイページ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            UserRepository.observeUserData()
        }
        .onDisappear() {
            userDataStore.listeners.remove(listenerType: .myUserData)
        }
    }
    func toolBarMenu() -> some View {
        Button(action: {
            pathDataStore.navigatetionPath.append(.friend)
        }, label: {
            Image(systemName: "person.2.fill")
        })
    }
    func getIconUIImage() -> UIImage? {
        if let iconData = userDataStore.signInUser?.iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
}

#Preview {
    MyPageView(userDataStore: UserDataStore.shared, pathDataStore: PathDataStore.shared)
}
