//
//  MoviePosterView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 24/12/2025.
//

import SwiftUI

struct MoviePosterView: View {
    let movie: Movie

    var body: some View {
        Image(movie.posterName)
            .resizable()
            .scaledToFill()
            .frame(width: 208, height: 275)
            .cornerRadius(12)
            .clipped()
    }
}
