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
    @State private var icon: UIImage? = nil
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            PhotosPicker(selection: $selectedImage) {
                if let iconImage = icon {
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
                    await UploadToStorage.uploadIconImage(selectedItem: selectedImage)
                }
            })
            .onChange(of: userDataStore.signInUser?.iconUrl, {
                getIconUIImage(iconUrl: userDataStore.signInUser?.iconUrl ?? "default")
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
        .onAppear() {
            ObserveToFirestore.observeUserData()
            getIconUIImage(iconUrl: userDataStore.signInUser?.iconUrl ?? "default")
        }
    }
    func toolBarMenu() -> some View {
        Button(action: {
            pathDataStore.navigatetionPath.append(.friend)
        }, label: {
            Image(systemName: "person.2.fill")
        })
    }
    func getIconUIImage(iconUrl: String) {
        if iconUrl != "default" {
            Task {
                guard let imageData = await ReadToStorage.getIconImage(iconUrl: iconUrl) else { return }
                icon = UIImage(data: imageData)
            }
        }
    }
}

#Preview {
    MyPageView(userDataStore: UserDataStore.shared, pathDataStore: PathDataStore.shared)
}
