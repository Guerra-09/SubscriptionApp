//
//  SvgImageView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 28-03-24.
//

import SwiftUI
import UIKit
import SwiftSVG

class MyView: UIView {
    // 1
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = "Hello, UIKit!"
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        
        let fistBump = UIView(svgNamed: "spotify_logo.svg")
        
        super.init(frame: .zero)
        // 2
        backgroundColor = .systemPink
        
        // 3
//        addSubview(label)
        addSubview(fistBump)
        NSLayoutConstraint.activate([
            fistBump.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fistBump.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fistBump.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            fistBump.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





struct SVGImageView: View {
    
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            
            VStack {
                
                
                
//                SVGImage()
//                    .frame(width: 100, height: 100)
                
                Text("Hello, SwiftUI!")
                    .foregroundStyle(.white)
                
                Image("spotify_logo.svg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    
            }
        }
    }
}

#Preview {
    MyView()
}
