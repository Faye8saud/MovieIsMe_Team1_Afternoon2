//
//  MovieCenterView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//


import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let posterName: String   // asset name or URL later
}

struct MovieCenterView: View {
    @State private var searchText = ""
    
    let heroMovies = [
        CarouselItem(
            imageName: "poster1",
            title: "Top Gun",
            rating: 4,
            genre: "Action",
            duration: "2 hr 9 min"
        ),
        CarouselItem(
            imageName: "poster2",
            title: "Inception",
            rating: 4.7,
            genre: "Sci-Fi",
            duration: "2 hr 28 min"
        )
    ]
    
    let dramaMovies = [
        Movie(title: "The Shawshank Redemption", posterName: "poster1"),
        Movie(title: "A Star Is Born", posterName: "poster2"),
        Movie(title: "A Star Is", posterName: "poster1")
    ]
    
    let comedyMovies = [
        Movie(title: "World's Greatest Dad", posterName: "poster2"),
        Movie(title: "House Party", posterName: "poster1"),
        Movie(title: "House", posterName: "poster1")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 28) {
                        
                        // Header
                        HStack {
                            Text("Movies Center")
                                .font(.system(size: 34, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                // profile action
                            } label: {
                                Image("userIcon1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
                                    .padding(10)
                                    .background(Color.dark1)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Search field
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField(
                                "",
                                text: $searchText,
                                prompt: Text("Search for Movie name, actors...")
                                    .foregroundColor(.gray.opacity(0.7))
                            )
                            .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Color.dark1)
                        )
                        .padding(.horizontal)
                        
                        
                        Text("High rated")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, -20)
                        // Hero Carousel
                        HeroCarouselView(movies: heroMovies)
                        
                        // Movie Rows
                        MovieRowView(title: "Drama", movies: dramaMovies)
                        MovieRowView(title: "Comedy", movies: comedyMovies)
                        
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    MovieCenterView()
}
