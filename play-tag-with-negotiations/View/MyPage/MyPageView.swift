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
    @State private var selectedImage: PhotosPickerItem?
    @State private var iconUIImage: UIImage? = nil
    
    var body: some View {
        GeometryReader { geome in
            let size = geome.size.width * 0.6
            VStack {
                Spacer(minLength: 50)
                PhotosPicker(selection: $selectedImage) {
                    if userDataStore.signInUser?.iconUrl == "default" {
                        Image(systemName: "person.circle")
                            .scaledToFit()
                            .font(.system(size: 200.0).weight(.ultraLight))
                    } else if let image = iconUIImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .scaledToFit()
                            .font(.system(size: 200.0).weight(.ultraLight))
                    }
                }
                .onChange(of: selectedImage, {
                    Task {
                        await UploadToStorage.uploadIconImage(selectedItem: selectedImage)
                    }
                })
                .onChange(of: userDataStore.signInUser?.iconUrl, {
                    getIconUIImage()
                })
                .onChange(of: userDataStore.iconImageData, {
                    imageDataToUIImage(data: userDataStore.iconImageData)
                })
                .contentShape(Circle())
                .frame(width: size, height: size, alignment: .center)
                MyPageListView(userDataStore: userDataStore)
                Spacer()
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("マイページ")
        .onAppear() {
            ObserveToFirestore.observeUserData()
            getIconUIImage()
        }
    }
    func getIconUIImage() {
        Task {
            guard let iconUrl = userDataStore.signInUser?.iconUrl else { return }
            await ReadToStorage.getMyIconImage(iconUrl: iconUrl)
        }
    }
    func imageDataToUIImage(data: Data?) {
        guard let imageData = data else { return }
        guard let iconImage = UIImage(data: imageData) else { return }
        iconUIImage = iconImage
    }
}

#Preview {
    MyPageView(userDataStore: UserDataStore.shared)
}
