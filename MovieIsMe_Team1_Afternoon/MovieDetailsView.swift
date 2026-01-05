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
    @State private var isBookmarked: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var writeReview = false

    @StateObject private var savedVM = SavedMoviesViewModel()
    private var shareURL: URL {
        URL(string: "https://www.imdb.com/title/\(movie.id)")!
    }
    
    // Custom initializer to inject ReviewViewModel for previews and usage
    init(movie: MovieRecord, reviewVM: ReviewViewModel) {
        self.movie = movie
        _reviewVM = StateObject(wrappedValue: reviewVM)
    }
    
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
                        .frame(width: UIScreen.main.bounds.width, height: 420)
                        .clipped()

//                        .frame(height: 420)
//                        .clipped()

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.85)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(maxWidth: .infinity)   // ✅ أضيفيها هنا
                        .frame(height: 420)
//                        .frame(height: 420)

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
//                من هنا
                subtleDivider

                // MARK: - Rating & Reviews
                section(title: "Rating & Reviews") {

                    VStack(alignment: .leading, spacing: 6) {
                        Text("4.8")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))

                        Text("out of 5")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.bottom, 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(reviewVM.reviews) { review in
                                ReviewCardView(review: review)
                            }
                        }
                        .padding(.vertical, 6)
                    }

                    // Write Review Button
                    NavigationLink(
                        destination: WriteReviewView(
                            movieID: movie.id,
                            userID: userID ?? ""
                        )
                        .environmentObject(reviewVM),
                        isActive: $writeReview
                    ) {
                        HStack(spacing: 10) {
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
                    .disabled(userID == nil) // disable if user is not logged in
                    .padding(.top, 8)
                }

            }
//من هنا
            Spacer(minLength: 40)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .task(id: movie.id) {
            print("Fetching reviews for movieID:", movie.id)
            await reviewVM.fetchReviews(movieID: movie.id)
        }
        .task {
            await vm.load(movieId: movie.id)
            await savedVM.fetchSavedMovies()

            isBookmarked = savedVM.savedMovieIDs.contains(movie.id)

        }
    }
    
    private var userID: String? {
        userViewModel.currentUser?.id
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

// MARK: - Review Card
//
//  ReviewCardView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 15/07/1447 AH.
//


// MARK: - Review Card
struct ReviewCardView: View {
    let review: ReviewRecord

    private var stars: Int {
        review.fields.rate / 2 // convert 10 → 5 stars
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: User + Rating
            HStack(spacing: 10) {
                
                // Profile Image
                if let imageUrlString = review.fields.user_profile_image,
                   let imageURL = URL(string: imageUrlString) {
                    AsyncImage(url: imageURL) { img in
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
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.5))
                        )
                }

                // User Name + Stars
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

            // MARK: Review Text
            Text(review.fields.review_text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(4)
                .lineSpacing(3)

            Spacer(minLength: 0)

            // MARK: Date
            Text(review.createdTime.prefix(10)) // simple formatting
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
//private let sampleReviews: [ReviewRecord] = [
//    ReviewRecord(
//        name: "Afnan Abdullah",
//        rating: 5,
//        text: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief.",
//        date: "Tuesday"
//    ),
//    ReviewModel(
//        name: "Sara",
//        rating: 4,
//        text: "Great performances and a solid story. Worth watching.",
//        date: "Monday"
//    ),
//    ReviewModel(
//        name: "Noura",
//        rating: 5,
//        text: "Loved it. Emotional and well made.",
//        date: "Sunday"
//    )
//]

