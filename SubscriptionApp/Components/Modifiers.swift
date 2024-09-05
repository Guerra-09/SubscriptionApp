//
//  Modifiers.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//
// This file was created for a certain problems i had with Bindings

import Foundation
import SwiftUI

struct TextFieldCommonModifier: ViewModifier {
    var bigContainer: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.bottom, bigContainer == true ? 70 : 0)
            .foregroundStyle(.white)
            .frame(width: 370, height: bigContainer == true ? 135 : 58)
            .background(Color("subViewsBackgroundColor"))
            .clipShape(Rectangle())
            .cornerRadius(15)
    }
}

struct TextFieldLabelCommonModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .frame(width: 350,alignment: .leading)
            .fontWeight(.bold)
            .font(.system(size: 20))
    }
}

struct ImageWithLogoModifier: ViewModifier {
    
    var backgroundColor: String?
    var tintColor: String?
    
    init(backgroundColor: String? = nil, tintColor: String? = nil) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }

    func body(content: Content) -> some View {
        if (self.backgroundColor != nil) && (self.tintColor != nil) {
            content
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .font(.system(size: 70))
                .frame(width: 120, height: 135)
                .background(Color(hex: backgroundColor ?? "FFFFFF"))
                .foregroundStyle(Color(hex: tintColor ?? "FFFFFF"))
                
                .clipShape(.circle)
            
        } else {
            content
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .font(.system(size: 70))
                .frame(width: 120, height: 135)
                .background(Color("subViewsBackgroundColor"))
                .foregroundStyle(.white)
                .clipShape(.circle)
        }
        
        
    }
}

