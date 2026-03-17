//
//  ARCMenu+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 28/01/26.
//

import SwiftUI

// MARK: - Previews

#Preview("ARCMenu - Native Sheet") {
    @Previewable @State var showMenu = true
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            avatarImage: .initials("CR")
        ),
        menuItems: ARCMenuItem.defaultItems(actions: .empty)
    )

    NavigationStack {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Text("ARCMenu Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Button("Show Menu") {
                    showMenu = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .arcMenu(isPresented: $showMenu, viewModel: viewModel)
    }
}

#Preview("ARCMenu - Trailing Panel") {
    @Previewable @State var showMenu = true
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Jane Cooper",
            subtitle: "Premium Member",
            avatarImage: .initials("JC")
        ),
        menuItems: ARCMenuItem.defaultItems(actions: .empty),
        configuration: .trailingPanel
    )

    ZStack {
        Color.indigo.opacity(0.3).ignoresSafeArea()

        VStack {
            Text("Trailing Panel Demo")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Toggle Menu") {
                showMenu.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}

#Preview("ARCMenu - With Title") {
    @Previewable @State var showMenu = true
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Alex Morgan",
            subtitle: "Gold Member",
            avatarImage: .systemImage("person.circle.fill")
        ),
        menuItems: ARCMenuItem.defaultItems(actions: .empty),
        configuration: ARCMenuConfiguration(sheetTitle: "Account")
    )

    ZStack {
        Color.orange.opacity(0.2).ignoresSafeArea()

        Text("With Title Demo")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}
