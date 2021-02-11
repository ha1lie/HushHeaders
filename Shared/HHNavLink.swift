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
        #if os(macOS)
        NavigationLink(destination: self.content) {
            Text(self.name)
                .foregroundColor(.blue)
                .font(.subheadline)
                .padding(.vertical, 4)
        }.buttonStyle(LinkButtonStyle())
        #else
        NavigationLink(destination: self.content) {
            Text(self.name)
                .foregroundColor(.blue)
                .font(.subheadline)
                .padding(.vertical, 4)
        }
        #endif
//        Text("Does this work?")
    }
}
