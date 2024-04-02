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
            
            TextField(placeholder, text: $textVariable)
                .padding()
                .padding(.bottom, bigContainer == true ? 70 : 0)
                .foregroundStyle(.white)
                .frame(width: 370, height: bigContainer == true ? 135 : 58)
                .background(Color("subViewsBackgroundColor"))
                .clipShape(Rectangle())
                .cornerRadius(15)
            
        }
        .padding(10)
    
    }
}

#Preview {
    TextFieldAndLabel(labelName: "Name", placeholder: "Enter a description", textVariable: .constant("Sex"), bigContainer: true)
}
