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

    @State private var selectedImage: UIImage?
    @State private var showVersionDetails: Bool = false
    @State var imageSelection: PhotosPickerItem? = nil
    @State var showToolbar: Bool = true
    
    private var url: URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0].appendingPathComponent("image.jpg")
    }
    
    
    @AppStorage("profileName") var profileName: String = "Guest"
    @ObservedObject var versionViewModel = VersionDetailsViewModel()
    
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
                        PersonalInformationView(showToolbar: $showToolbar)
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
                        PreferencesView(showToolbar: $showToolbar)
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
                    
                    
                    
                    Button {
                        showVersionDetails.toggle()
                    } label: {
                        Text("\(Image(systemName: "globe")) ver \(versionViewModel.notes[0].version)")
                            .underline()
                            .foregroundStyle(.gray)
                            .padding(.bottom, 25)
                    }

                    
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
            showToolbar = true
            
            url.loadImage(&selectedImage)
        }
        .sheet(isPresented: $showVersionDetails, content: {
            VersionDetails()
        })
        .toolbar(showToolbar ? .visible : .hidden, for: .tabBar)
        .navigationTitle("Profile")
        .toolbarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
        
    }
    
    // Vista que es un PhotosPicker que muestra la imagen seleccionada.
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

struct VersionDetails: View {
    
    @ObservedObject var versionViewModel = VersionDetailsViewModel()
    @AppStorage("languageSelected") var languageSelected: String = "English"
    @State var content: LocalizedStringKey = ""
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                Text("Geld version \(versionViewModel.notes[0].version)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                
                Text(content)
                    .frame(width: 320, alignment: .leading)
                    .padding(20)
                
                
            }
            .foregroundStyle(.white)
            
        }
        .onAppear {
            
            for note in versionViewModel.notes {
                content = LocalizedStringKey(languageSelected == "English" ? note.en : note.es)
            }

        }
    }
}


class VersionDetailsViewModel: ObservableObject {
    @Published var notes = [NotesModel]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "VersionDescription", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)

                let notes = try JSONDecoder().decode([NotesModel].self, from: data)
                self.notes = notes
            } catch {
                print("Error al cargar los datos del archivo JSON:", error)
            }
        } else {
            print("No se encontró el archivo JSON")
        }
    }
    
}

struct NotesModel: Decodable {
    let version: String
    let en: String
    let es: String
}

#Preview {
    VersionDetails()
}
