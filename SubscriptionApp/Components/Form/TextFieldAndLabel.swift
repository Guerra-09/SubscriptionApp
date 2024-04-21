//
//  TextFieldAndLabel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import SwiftUI

struct TextFieldAndLabel: View {
    
    let labelName: String
    
    @State var placeholder: String
    @Binding var textVariable: String
    
    
    let bigContainer: Bool
    
    
    var body: some View {
    
        VStack{
            Text(labelName)
                .foregroundStyle(.white)
                .frame(width: 350,alignment: .leading)
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            if bigContainer {
                
               
                TextEditor(text: $textVariable)
                    .foregroundStyle(.white)
                    .frame(height: 135)
                    .padding(10)
                    .scrollContentBackground(.hidden)
                    .background(Color("subViewsBackgroundColor"))
                    .clipShape(Rectangle())
                    .cornerRadius(15)
                    .padding(.horizontal, 10)

                        

                
            } else {
                TextField("", text: $textVariable, prompt: Text("\(placeholder)")
                    .foregroundColor(Color(hex: "a39e9e")))
                
                    .padding()
                    .foregroundStyle(.white)
                    .frame(width: 370, height: 58)
                    .background(Color("subViewsBackgroundColor"))
                    .clipShape(Rectangle())
                    .cornerRadius(15)
                    .submitLabel(.done)

            }
            
        }
        .padding(10)
    
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
            .ignoresSafeArea()
        
        TextFieldAndLabel(labelName: "Name", placeholder: "Enter a description", textVariable: .constant(""), bigContainer: true)
    }
}
