//
//  MovieRowView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 24/12/2025.
//
import SwiftUI

struct MovieRowView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    let title: String
    let movies: [CarouselItem]

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
                        NavigationLink {
                            MovieDetailView(
                                movie: movie.toMovieRecord(),
                                reviewVM: reviewVM
                            )
                        } label: {
                            AsyncImage(url: URL(string: movie.imageName)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 140, height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
