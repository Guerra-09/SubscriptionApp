//
//  ProfileView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI
import PhotosUI
import Photos

struct ProfileView: View {

    //
    @State private var selectedImage: UIImage?
    @ObservedObject var vm = ProfileViewModel()
    @State var imageSelection: PhotosPickerItem? = nil
    
    private var url: URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0].appendingPathComponent("image.jpg")
    }
    //
    @AppStorage("profileName") var profileName: String = "Guest"
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    profilePic

                    
                    Text("\(profileName)")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.bottom, 40)
                    
                    
                    
                    Text("Account Settings")
                        .font(.title2)
                        .frame(width: 370, alignment: .leading)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    
                    
                    
                    NavigationLink {
                        PersonalInformationView()
                    } label: {
                        HStack {
                            Text("Personal information")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        
                    }
                    
                    NavigationLink {
                        PreferencesView()
                    } label: {
                        HStack {
                            Text("Preferences")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        
                    }
                    
            
                    
                    
                    Spacer()
                    
                }

                .onChange(of: imageSelection) {
                    Task { 
                        @MainActor in
                        if let data = try? await imageSelection?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data:data)
                            url.saveImage(selectedImage)
                            return
                            
                        }
                    }
                }
            }
        }
        .onAppear {
            url.loadImage(&selectedImage)
        }
        .navigationTitle("Profile")
        .toolbarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
    }
    
    var profilePic: some View {
        PhotosPicker(
          selection: $imageSelection,
          matching: .images,
          photoLibrary: .shared()) {
              ZStack {
                  
                  if selectedImage != nil {
                      Image(uiImage: selectedImage ?? UIImage() )
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 120, height: 150)
                          .clipShape(.circle)
                  } else {
                      Image(systemName: "person")
                          .resizable()
                          .modifier(ImageWithLogoModifier())
                  }
                  
                  
                  
              }
                
          }
      }

}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
