//
//  MovieDetailsView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//

import SwiftUI

struct MovieDetailView: View {

    let movie: MovieRecord

    @EnvironmentObject var userViewModel: UserViewModel

    @StateObject private var reviewVM: ReviewViewModel
    @StateObject private var vm = MovieDetailsViewModel()
    @StateObject private var savedVM = SavedMoviesViewModel()

    @State private var isBookmarked = false
    @State private var writeReview = false

    @Environment(\.dismiss) private var dismiss

    init(movie: MovieRecord, reviewVM: ReviewViewModel) {
        self.movie = movie
        _reviewVM = StateObject(wrappedValue: reviewVM)
    }

    private var displayedMovie: MovieRecord {
        vm.movie ?? movie
    }

    private var userID: String? {
        userViewModel.currentUser?.id
    }

    private var shareURL: URL {
        URL(string: "https://www.imdb.com/title/\(movie.id)")!
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                headerSection
                infoGrid
                subtleDivider
                storySection
                subtleDivider
                imdbSection
                subtleDivider
                directorSection
                actorsSection
                subtleDivider
                reviewsSection

                Spacer(minLength: 40)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)

        .task(id: movie.id) {
            await reviewVM.fetchReviews(movieID: movie.id)
        }

        .task {
            await vm.load(movieId: movie.id)
            await savedVM.fetchSavedMovies()
            isBookmarked = savedVM.savedMovieIDs.contains(movie.id)
        }
    }
}

// Header
private extension MovieDetailView {

    var headerSection: some View {
        ZStack(alignment: .top) {

            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: displayedMovie.fields.poster)) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "film.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.5))
                        )
                }
                .frame(width: UIScreen.main.bounds.width, height: 420)
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

            HStack(spacing: 12) {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.yellow)
                        .padding(10)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }

                Spacer()

                ShareLink(
                    item: shareURL,
                    subject: Text(displayedMovie.fields.name),
                    message: Text("Check out \(displayedMovie.fields.name) on IMDb")
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.yellow)
                        .padding(10)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }

                Button {
                    Task {
                        await savedVM.saveMovie(movieID: displayedMovie.id)
                        isBookmarked = true
                    }
                } label: {
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
    }
}

// Info / Story
private extension MovieDetailView {

    var infoGrid: some View {
        VStack(spacing: 20) {
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
    }

    var storySection: some View {
        section(title: "Story") {
            Text(displayedMovie.fields.story)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(5)
        }
    }

    var imdbSection: some View {
        section(title: "IMDb Rating") {
            Text("\(displayedMovie.fields.imdbRating, specifier: "%.1f") / 10")
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

// Director & Actors
private extension MovieDetailView {

    var directorSection: some View {
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
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 64, height: 64)
            }
        }
    }

    var actorsSection: some View {
        section(title: "Stars") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.actors) { actor in
                        VStack(spacing: 8) {
                            AsyncImage(url: actor.imageURL) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())

                            Text(actor.name)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 90)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
    }
}

// Reviews
private extension MovieDetailView {

    var reviewsSection: some View {
        section(title: "Rating & Reviews") {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(reviewVM.reviews) { review in
                        ReviewCardView(review: review)
                    }
                }
            }

            NavigationLink(
                destination: WriteReviewView(
                    movieID: movie.id,
                    userID: userID ?? ""
                )
                .environmentObject(reviewVM),
                isActive: $writeReview
            ) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Write a review")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.yellow)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.yellow, lineWidth: 1)
                )
            }
            .disabled(userID == nil)
        }
    }
}

// Helpers
private extension MovieDetailView {

    var subtleDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(height: 0.5)
            .padding(.horizontal, 20)
            .padding(.top, 24)
    }

    func section<Content: View>(
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

// InfoText
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
        }
    }
}

// Review Card
struct ReviewCardView: View {

    let review: ReviewRecord

    private var stars: Int {
        review.fields.rate / 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 10) {

                if let urlString = review.fields.user_profile_image,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.35))
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.35))
                        .frame(width: 36, height: 36)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.fields.user_name ?? "Anonymous")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: i < stars ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }

            Text(review.fields.review_text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(4)

            Text(review.createdTime.prefix(10))
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.45))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .frame(width: 320, height: 160)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    let reviewVM = ReviewViewModel() // create a local instance
    let userVM = UserViewModel()     // if MovieDetailView uses userViewModel
    NavigationStack {
        MovieDetailView(movie: previewMovie, reviewVM: reviewVM)
            .environmentObject(userVM)
    }
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

