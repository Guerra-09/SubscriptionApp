////
////  ColorPickerCustom.swift
////  SubscriptionApp
////
////  Created by José Guerra on 23-04-24.
////
//
//import SwiftUI
//
//struct ColorPickerCustom: View {
//    
//    var label: String = ""
//    @Binding var colorSelection: Color
//    
//    var body: some View {
//        
//        Text(label)
//            .foregroundStyle(.white)
//        
//        ColorPicker(selection: colorSelection)
//            .labelsHidden()
//            .onChange(of: bgColor) { oldValue, newValue in
//                backgroundColor = bgColor.toHex() ?? "000000"
//            }
//    }
//}
//
//#Preview {
//    ColorPickerCustom()
//}
