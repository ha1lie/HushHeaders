//
//  HHNavLink.swift
//  HushHeaders
//
//  Created by Hallie on 2/7/21.
//

import SwiftUI
struct HHNavLink<Content: View>: View {
    
    let content: Content
    
    private var name: String
    
    init(_ title: String, @ViewBuilder _ content: @escaping () -> Content) {
        self.content = content()
        self.name = title
    }
    
    var body: some View {
        NavigationLink(destination: self.content) {
            Text(self.name)
                .foregroundColor(.blue)
                .font(.subheadline)
                .padding(.leading, 8)
                .padding(.vertical, 4)
        }
//        Text("Does this work?")
    }
}
