//
//  MovieDetailsView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieRecord
    @StateObject private var vm = MovieDetailsViewModel()
    @State private var isBookmarked: Bool = false
    @Environment(\.dismiss) private var dismiss

    // ✅ الفيلم اللي نعرضه: أولاً من الـNavigation ثم يتحدث من API
    private var displayedMovie: MovieRecord {
        vm.movie ?? movie
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Poster + Title + Top Buttons
                ZStack(alignment: .top) {

                    // Poster + Title
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: displayedMovie.fields.poster)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "film.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        }
                        .frame(height: 420)
                        .clipped()

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.85)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(height: 420)

                        Text(displayedMovie.fields.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                    }

                    // Top Buttons
                    HStack(spacing: 12) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.yellow)
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.yellow)
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }

                        Button(action: { isBookmarked.toggle() }) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.yellow)
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 52)
                }

                // MARK: - Info Grid
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        InfoText(title: "Duration", value: displayedMovie.fields.runtime)
                        Spacer()
                        InfoText(title: "Language", value: displayedMovie.fields.language.first ?? "—")
                    }

                    HStack {
                        InfoText(title: "Genre", value: displayedMovie.fields.genre.first ?? "—")
                        Spacer()
                        InfoText(title: "Age", value: displayedMovie.fields.rating)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                subtleDivider

                // MARK: - Story
                section(title: "Story") {
                    Text(displayedMovie.fields.story)
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(5)
                }

                subtleDivider

                // MARK: - IMDb Rating
                section(title: "IMDb Rating") {
                    Text("\(displayedMovie.fields.imdbRating, specifier: "%.1f") / 10")
                        .foregroundColor(.white.opacity(0.6))
                }

                subtleDivider

                // MARK: - Director
                section(title: "Director") {
                    if let director = vm.director {
                        VStack(spacing: 8) {
                            AsyncImage(url: director.imageURL) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())

                            Text(director.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 64, height: 64)

                            Text("—")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // MARK: - Stars
                section(title: "Stars") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {

                            if vm.actors.isEmpty {
                                ForEach(0..<3, id: \.self) { _ in
                                    VStack(spacing: 8) {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 64, height: 64)

                                        Text("—")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                            } else {
                                ForEach(vm.actors) { actor in
                                    VStack(spacing: 8) {

                                        AsyncImage(url: actor.imageURL) { img in
                                            img.resizable().scaledToFill()
                                        } placeholder: {
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .overlay(
                                                    Image(systemName: "person.fill")
                                                        .foregroundColor(.white.opacity(0.35))
                                                )
                                        }
                                        .frame(width: 64, height: 64)
                                        .clipShape(Circle())

                                        Text(actor.name)
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.6))
                                            .multilineTextAlignment(.center)
                                            .frame(width: 90)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Spacer(minLength: 40)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await vm.load(movieId: movie.id)
        }
    }

    // MARK: - Subtle Divider (مثل الصورة)
    private var subtleDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(height: 0.5)
            .padding(.horizontal, 20)
            .padding(.top, 24)
    }

    // MARK: - Section Helper
    private func section<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            content()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}

// MARK: - InfoText
struct InfoText: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Text(value)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
#Preview {
    MovieDetailView(movie: previewMovie)
}

// MARK: - Preview Mock Movie
let previewMovie = MovieRecord(
    id: "rec_preview",
    createdTime: "2025-01-01",
    fields: MovieFields(
        name: "The Shawshank Redemption",
        poster: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDI1LWEzNmQtNWYxODhlYzE2OTZiXkEyXkFqcGc@._V1_.jpg",
        story: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
        runtime: "2h 22m",
        genre: ["Drama"],
        rating: "+15",
        imdbRating: 9.3,
        language: ["English"]
    )
)
