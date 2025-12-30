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
        AsyncImage(url: URL(string: movie.posterName)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure(_):
                Color.gray

            case .empty:
                ProgressView()

            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 208, height: 275)
        .cornerRadius(12)
        .clipped()
    }
}
