import SwiftUI
//movie posters
struct ProfileView: View {
    @StateObject private var savedVM = SavedMoviesViewModel()
    @StateObject private var movieVM = MovieViewModel()
   
    var savedMovies: [CarouselItem] {
        movieVM.heroMovies.filter {
            savedVM.savedMovieIDs.contains($0.id)
        }
    }
    
@EnvironmentObject var userViewModel: UserViewModel

    let movies = [
        "poster1",
       "poster2",
       "poster3"
   ]
    //let movies: [String] = []
@State private var backButton = false
    
  
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            // back action
                            backButton = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.yellowAccent)
                        }
                        
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    NavigationLink(destination: MovieCenterView()
                        .environmentObject(userViewModel)
                        .navigationBarBackButtonHidden(true),
                        isActive: $backButton
                    ) {}
                    
                    HStack(spacing: 16) {
                        AsyncImage(
                            url: URL(string: userViewModel.currentUser?.fields.profile_image ?? "")
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())

                        
                        //user name and email
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userViewModel.currentUser?.fields.name ?? "")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            //.offset(y:-10)
                            
                            Text(userViewModel.currentUser?.fields.email ?? "")
                                .foregroundStyle(.gray)
                                .font(.system(size: 12))
                                //.foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            ProfileEditingView()
                            .environmentObject(userViewModel)
                            .navigationBarBackButtonHidden(true)

                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .tint(.gray)

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 358, height: 80)
                        
                    )
                    
                    
                    Text("Saved movies")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    //movie posters
                    // Saved movies content
                    if savedMovies.isEmpty {
                        VStack(spacing: 16) {
                            Image("LogoBlack")
                            Text("No saved movies yet")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 130)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(savedMovies) { movie in
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
                                    .frame(width: 172, height: 237)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        }
                    }


                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
        }
        .task {
            await movieVM.fetchMovies()
            await savedVM.fetchSavedMovies()
        }

    }
   
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
