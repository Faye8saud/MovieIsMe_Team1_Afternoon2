//
//  MovieDetailsView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//
import SwiftUI

struct MovieDetailView: View {
    let movie: MovieRecord

    @State private var isBookmarked: Bool = false
    @State private var actors: [Actor] = []
    @State private var director: Director?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Header with Poster and Title
                ZStack(alignment: .bottomLeading) {

                    // Poster Image
                    AsyncImage(url: URL(string: movie.fields.poster)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "film.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.5))
                            )
                    }
                    .frame(height: 300)
                    .clipped()

                    // Bottom Gradient
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.8)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 300)

                    // Movie Title
                    VStack(alignment: .leading) {
                        Text(movie.fields.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // Top Buttons
                    VStack {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.yellow)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.yellow)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }

                            Button {
                                isBookmarked.toggle()
                            } label: {
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.yellow)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 50)

                        Spacer()
                    }
                }

                // MARK: - Info Grid
                VStack(spacing: 16) {
                    HStack(spacing: 40) {
                        InfoText(title: "Duration", value: movie.fields.runtime)
                        InfoText(title: "Language", value: movie.fields.language.first ?? "—")
                    }

                    HStack(spacing: 40) {
                        InfoText(title: "Genre", value: movie.fields.genre.first ?? "—")
                        InfoText(title: "Age", value: movie.fields.rating)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Divider().padding(.top, 24)

                // MARK: - Story
                VStack(alignment: .leading, spacing: 12) {
                    Text("Story")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Text(movie.fields.story)
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                Divider().padding(.top, 24)

                // MARK: - IMDb Rating
                VStack(alignment: .leading, spacing: 12) {
                    Text("IMDb Rating")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Text("\(movie.fields.imdbRating, specifier: "%.1f") / 10")
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                Divider().padding(.top, 24)

                // MARK: - Director
                VStack(alignment: .leading, spacing: 12) {
                    Text("Director")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    if let director {
                        HStack(spacing: 12) {
                            AsyncImage(url: director.imageURL) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                            Text(director.name)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                Divider().padding(.top, 24)

                // MARK: - Stars
                VStack(alignment: .leading, spacing: 12) {
                    Text("Stars")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(actors) { actor in
                                StarCard(name: actor.name)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .task {
            await loadPeople()
        }
    }
}
struct InfoText: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.white)

            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct StarCard: View {
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 32))
                )

            Text(name)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
}
extension MovieDetailView {

    func loadPeople() async {
        do {
            let movieActors: MovieActorsResponse =
            try await APIClient.shared.fetch(
                "movie_actors",
                queryItems: [
                    URLQueryItem(
                        name: "filterByFormula",
                        value: "{movie_id}=\"\(movie.id)\""
                    )
                ]
            )

            let actorIds = Set(movieActors.records.map { $0.fields.actor_id })

            let allActors: ActorsResponse =
            try await APIClient.shared.fetch("actors")

            self.actors = allActors.records
                .filter { actorIds.contains($0.id) }
                .map {
                    Actor(
                        id: $0.id,
                        name: $0.fields.name,
                        imageURL: URL(string: $0.fields.image)
                    )
                }

            let movieDirectors: MovieDirectorsResponse =
            try await APIClient.shared.fetch(
                "movie_directors",
                queryItems: [
                    URLQueryItem(
                        name: "filterByFormula",
                        value: "{movie_id}=\"\(movie.id)\""
                    )
                ]
            )

            if let directorId = movieDirectors.records.first?.fields.director_id {
                let allDirectors: DirectorsResponse =
                try await APIClient.shared.fetch("directors")

                if let match = allDirectors.records.first(where: { $0.id == directorId }) {
                    self.director = Director(
                        id: match.id,
                        name: match.fields.name,
                        imageURL: URL(string: match.fields.image)
                    )
                }
            }

        } catch {
            print(error)
        }
    }
}

#Preview {
    MovieDetailView(movie: previewMovie)
}

// MARK: - Preview Mock Movie
let previewMovie = MovieRecord(
    id: "preview_id",
    createdTime: "2025-01-01",
    fields: MovieFields(
        name: "The Shawshank Redemption",
        poster: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDI1LWEzNmQtNWYxODhlYzE2OTZiXkEyXkFqcGc@._V1_.jpg",
        story: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
        runtime: "2h 22m",
        genre: ["Drama"],
        rating: "15",
        imdbRating: 9.3,
        language: ["English"]
    )
)

