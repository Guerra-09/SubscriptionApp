//
//  IconSelectionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 23-04-24.
//
import SwiftUI


struct IconSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    var iconsToChoose: [String] = ["globe", "car", "fuelpump.fill", "dumbbell.fill", "cart.fill", "stethoscope", "airplane.departure", "tv"]
    
    @Binding var iconSelected: String
    @Binding var textColor: String
    @Binding var backgroundColor: String
    @Binding var logoColor: String
    
    @State var bgColor: Color = Color.white
    @State var txtColor: Color = Color.black
    @State var lgColor: Color = Color.black
    @State var iconSelectioned = "globe"
    
    
    private let adaptiveColumn = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    var body: some View {

        
            
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: 105)
                        
                        Text("Subscription Preview")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.leading, 25)
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Save")
                                .padding(.trailing, 25)
                                
                        }
                    }
                    .padding(.top, 30)
                  
                    
                    SubscriptionViewComponent(logo: iconSelectioned, logoColor: logoColor, backgroundColor: backgroundColor, textColor: textColor, name: "Subscription Name", price: 9.99, cycle: "monthly", startDay: Date(), reminder: true, disableService: false)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Spacer()
                        .frame(height: 50)
                        
                    
                }
                .frame(maxHeight: 160)
                .padding(.bottom, 20)
                
                
                HStack {
                    Text("Colors")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .font(.title)
                    
                    Spacer()
                }
                .padding()
                
                HStack {
                    
                    VStack {
                        Text("Change Background Color")
                            
                        
                        ColorPicker("", selection: $bgColor)
                            .labelsHidden()
                            .onChange(of: bgColor) { oldValue, newValue in
                                backgroundColor = bgColor.toHex() ?? "000000"
                            }
                    }
                    
                    VStack {
                        Text("Change Text Color")
                        ColorPicker("", selection: $txtColor)
                            .labelsHidden()
                            .onChange(of: txtColor) { oldValue, newValue in
                                textColor = txtColor.toHex() ?? "000000"
                            }
                    }
                    
                    VStack {
                        Text("Change Logo Color")
                        ColorPicker("", selection: $lgColor)
                            .labelsHidden()
                            .onChange(of: lgColor) { oldValue, newValue in
                                logoColor = lgColor.toHex() ?? "000000"
                            }
                    }
                }
                .foregroundStyle(.white)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding()
                
                HStack {
                    Text("Icon")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .font(.title)
                    
                    Spacer()
                }
                    .padding()
                
                ScrollView {

                    
                    LazyVGrid(columns: adaptiveColumn, spacing: 8) {
                        
                        ForEach(iconsToChoose, id: \.self) { icon in
                            Image(systemName: icon)
                                .frame(width: 80, height: 80, alignment: .center)
                                .background(Color("buttonBackgroundColor"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .onTapGesture {
                                    self.iconSelectioned = icon
                                    iconSelected = icon
                                }
                            
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                
            }
            
            
            
        }
        .onAppear {
            self.bgColor = Color(hex: backgroundColor)
            self.txtColor = Color(hex: textColor)
            self.lgColor = Color(hex: logoColor)
            self.iconSelectioned = iconSelected
            
            
        }
        
        .navigationTitle("Icon")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Text("Acept")
            }
        }

        
    }
}
