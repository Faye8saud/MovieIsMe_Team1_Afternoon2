//
//  MovieIsMe_Team1_AfternoonApp.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//

import SwiftUI

@main
struct MovieIsMe_Team1_AfternoonApp: App {
    
    init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor =
                UIColor.white.withAlphaComponent(0.4)
        }

    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}
