//
//  MovieCenterView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//


import SwiftUI


struct MovieCenterView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var searchText = ""
    @State private var navigateToProfile = false

    @StateObject private var vm = MovieViewModel()
    
    var searchResults: [CarouselItem] {
        vm.searchResults(for: searchText)
    }
    
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
                                navigateToProfile = true
                            }
                            label: {AsyncImage(url: URL(string: userViewModel.currentUser?.fields.profile_image ?? "")) { image in
                                    image
                                         .resizable()
                                        .scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                          }
                           .frame(width: 41, height: 41)
                           .background(Color.dark1)
                         .clipShape(Circle())
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        NavigationLink(
                            destination: ProfileView()
                                .environmentObject(userViewModel), // pass ViewModel
                            isActive: $navigateToProfile
                        ) {
                            EmptyView()
                        }
                        
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
                        
                        
                        if !searchText.isEmpty {
                            
                            if searchResults.isEmpty {
                                Text("No results found")
                                    .foregroundColor(.gray)
                                    .padding(.top, 80)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Search Results")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                MovieSearchGrid(movies: searchResults)
                            }
                            
                        } else {
                            
                            // Normal Movie Center UI
                            Text("High rated")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, -20)
                            
                            if vm.isLoading {
                                ProgressView()
                            } else {
                                HeroCarouselView(movies: vm.heroMovies)
                            }
                            
                            MovieRowView(title: "Drama", movies: vm.heroMovies)
                            MovieRowView(title: "Comedy", movies: vm.heroMovies)

                        }
                    }
                        .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            if let userID = SessionManager.getUserID() {
                print("🎬 MovieCenterView userID:", userID)
            } else {
                print("❌ No userID found in MovieCenterView")
            }
        }
        .task {
            await vm.fetchMovies()
        }
    }
}
//وسن اضفت
extension Movie {
    func toRecord() -> MovieRecord {
        MovieRecord(
            id: UUID().uuidString,
            createdTime: "",
            fields: MovieFields(
                name: self.title,
                poster: self.posterName,      // إذا posterName عندك رابط URL استمري، إذا اسم صورة محلية راح نضبطها تحت
                story: "",
                runtime: "",
                genre: [],
                rating: "",
                imdbRating: 0.0,
                language: []
            )
        )
    }
}

//search view
struct MovieSearchGrid: View {
let movies: [CarouselItem]

let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
]

var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
        ForEach(movies) { movie in
            NavigationLink {
                // MovieDetailsView(movie: movie)
            } label: {
                AsyncImage(url: URL(string: movie.imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    .padding(.horizontal)
}
}

#Preview {
    MovieCenterView()
        .environmentObject(UserViewModel())
}
