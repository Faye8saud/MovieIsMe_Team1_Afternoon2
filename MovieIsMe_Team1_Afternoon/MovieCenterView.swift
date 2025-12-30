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
                        
                        
                        Text("High rated")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, -20)
                        // Hero Carousel
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            HeroCarouselView(movies: vm.heroMovies)
                        }
                        
                        // Movie Rows
                        MovieRowView(title: "Drama", movies: dramaMovies)
                        MovieRowView(title: "Comedy", movies: comedyMovies)
                        
                    }
                    .padding(.bottom, 20)
                }
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


#Preview {
    MovieCenterView()
        .environmentObject(UserViewModel())
}
