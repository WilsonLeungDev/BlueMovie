//
//  MainView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 30/1/2022.
//

import SwiftUI

struct MainView: View {
    
    init() {
        let textColor = UIColor(Color("Blue")) // UIColor.white //
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        shadow.shadowColor = UIColor(Color.white.opacity(0.5))
        let backgroundColor = UIColor.black // UIColor(Color("Gray").opacity(0.35))
        
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .clear
        appearance.backgroundColor = backgroundColor
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 32)!,
            .foregroundColor: textColor,
            .shadow: shadow,
            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        appearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 24)!,
            .foregroundColor: textColor,
            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // Tab Bar Color
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = backgroundColor
    }
    
    var body: some View {
//        ZStack {
//            futureGradient
//                .ignoresSafeArea()
//            VStack {
//
//            }
//        }
        TabView {
            NavigationView {
                MovieHomeView()
            }
                .tabItem {
                    Label("Home", systemImage: "film")
                }
                .tag(0)

            NavigationView {
                MovieSearchView()
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
        }
        .accentColor(Color("Blue"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
