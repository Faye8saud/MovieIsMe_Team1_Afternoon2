//
//  imageCarousel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 24/12/2025.
//
import SwiftUI

struct CarouselItem: Identifiable {
    let id: String
    let imageName: String
    let title: String
    let rating: Double
    let genre: String
    let duration: String
}

struct RatingStars: View {
      let rating: Double
       let maxRating: Double = 5
       let size: CGFloat = 10

       var body: some View {
           ZStack(alignment: .leading) {

               // ⭐ Empty stars — yellow outline
               HStack(spacing: 4) {
                   ForEach(0..<5, id: \.self) { _ in
                       Image(systemName: "star")
                           .foregroundColor(.yellow)
                           .font(.system(size: size))
                   }
               }

               // ⭐ Filled stars — solid yellow
               HStack(spacing: 4) {
                   ForEach(0..<5, id: \.self) { _ in
                       Image(systemName: "star.fill")
                           .foregroundColor(.yellow)
                           .font(.system(size: size))
                   }
               }
               .mask(
                   GeometryReader { geo in
                       Rectangle()
                           .frame(
                               width: geo.size.width * CGFloat(rating / maxRating)
                           )
                   }
               )
           }
           .frame(height: size)
       }
   }

struct CarouselIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                    .frame(
                        width: index == currentIndex ? 10 : 6,
                        height: index == currentIndex ? 10 : 6
                    )
                    .animation(.easeInOut(duration: 0.25), value: currentIndex)
            }
        }
    }
}
struct HeroCarouselView: View {

    let movies: [CarouselItem]
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 16) {

            TabView(selection: $currentIndex) {
                ForEach(movies) { movie in

                    ZStack(alignment: .bottomLeading) {

                        AsyncImage(url: URL(string: movie.imageName)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                              //      .scaledToFill()

                            case .failure(_):
                                Color.gray

                            case .empty:
                                ProgressView()

                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()

                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.3),
                                .black.opacity(0.7)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        )

                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.title)
                                .font(.title.bold())

                            RatingStars(rating: movie.rating)

                            HStack {
                                Text(String(format: "%.1f", movie.rating))
                                    .font(.system(size: 25, weight: .bold))
                                Text("out of 5")
                            }

                            Text("\(movie.genre) • \(movie.duration)")
                                .font(.system(size: 16))
                                .opacity(0.8)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .frame(height: 480)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            CarouselIndicator(
                count: movies.count,
                currentIndex: currentIndex
            )
        }
    }
}
extension CarouselItem {
    func toMovieRecord() -> MovieRecord {
        MovieRecord(
            id: self.id,                 // هذا مهم
            createdTime: "",
            fields: MovieFields(
                name: self.title,
                poster: self.imageName,
                story: "",
                runtime: self.duration,
                genre: [self.genre],
                rating: "",
                imdbRating: self.rating * 2, // تحويل 5 → 10
                language: []
            )
        )
    }
}
