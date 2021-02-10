//
//  HushHeadersApp.swift
//  Shared
//
//  Created by Hallie on 2/8/21.
//

import SwiftUI

@main
struct HushHeadersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ToggleStyle {
    associatedtype Body : View

    func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ToggleStyleConfiguration
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
