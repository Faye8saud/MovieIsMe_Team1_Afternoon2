//
//  MovieRowView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 24/12/2025.
//
import SwiftUI

struct MovieRowView: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Button("Show more") {
                    print("Show more \(title)")
                }
                .foregroundColor(.yellowAccent)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: /*MovieDetailView(movie: movie)*/ MovieDetailsView() ) {
                            MoviePosterView(movie: movie)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
