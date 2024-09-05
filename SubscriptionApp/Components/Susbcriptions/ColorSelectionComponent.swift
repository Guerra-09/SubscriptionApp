//
//  ColorSelectionComponent.swift
//  SubscriptionApp
//
//  Created by José Guerra on 04-09-24.
//

import SwiftUI

struct ColorSelectionComponent: View {
    
    @State var sheet: Bool = false
    @Binding var selectedColor: String
    
    var body: some View {
        
        ZStack {
            Color(hex: "282828")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#FFFFFF"))
                        .onTapGesture {
                            self.selectedColor = "#FFFFFF"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#AAAAAA"))
                        .onTapGesture {
                            self.selectedColor = "#"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#ff0d00"))
                        .onTapGesture {
                            self.selectedColor = "#ff0d00"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#ff5200"))
                        .onTapGesture {
                            self.selectedColor = "#ff5200"
                        }
                    
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#ffea5e"))
                        .onTapGesture {
                            self.selectedColor = "#ffea5e"
                        }
                    
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#61ea5e"))
                        .onTapGesture {
                            self.selectedColor = "#61ea5e"
                        }
                    
                }
                .padding(10)
                
                HStack {
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#247e22"))
                        .onTapGesture {
                            self.selectedColor = "#247e22"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#1748dc"))
                        .onTapGesture {
                            self.selectedColor = "#1748dc"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#6190ff"))
                        .onTapGesture {
                            self.selectedColor = "#6190ff"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#9317ff"))
                        .onTapGesture {
                            self.selectedColor = "#9317ff"
                        }
                    
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#fd90ff"))
                        .onTapGesture {
                            self.selectedColor = "#fd90ff"
                        }
                    
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(Color(hex: "#000000"))
                        .onTapGesture {
                            self.selectedColor = "#000000"
                        }
                }
                .padding(10)
                
            }
            
            
            
            
        }
        
    }
}



#Preview {
    ColorSelectionComponent(selectedColor: .constant("FFFFFF"))
}
