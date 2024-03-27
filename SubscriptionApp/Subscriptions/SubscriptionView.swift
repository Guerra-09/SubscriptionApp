//
//  SubscriptionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct SubscriptionView: View {
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                
                
                VStack {
                    Text("Subscription View")
                        .foregroundStyle(Color(.white))
                    
                  
                }

                
                
                .overlay {
                    NavigationLink {
                        NewSubscriptionView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 35))
                            .frame(width: 70, height: 150)
                            .background(Color("buttonBackgroundColor"))
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            
                    }
                    .position(CGPoint(x: 210.0, y: 275.0))
                }
                
                
                
                
                
                
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                
                Button(action: {}, label: {
                    Text("All Subscriptions   \(Image(systemName: "chevron.down"))")
                        .frame(width: 250, height: 35)
                        .foregroundStyle(.white)
                        .background(Color("SecondaryBackgroundColor"))
                        .clipShape(.capsule)
                })
                
            }
        }
        
        
        
    }

}

#Preview {
    NavigationStack {
        SubscriptionView()
    }
}
