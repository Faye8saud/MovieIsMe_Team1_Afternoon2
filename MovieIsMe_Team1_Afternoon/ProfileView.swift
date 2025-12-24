import SwiftUI
//movie posters
struct ProfileView: View {
//    let movies = [
//        "poster1",
//        "poster2",
//        "poster3"
//    ]
    let movies: [String] = []

    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            // back action
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.yellow)
                        }
                        
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")//will replace latter with the profile pic
                            .resizable()
                            .frame(width: 56, height: 56)
                            .foregroundColor(.gray)
                        
                        //user name and email
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sarah Abdullah")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            //.offset(y:-10)
                            
                            Text("Xxxx234@gmail.com")
                                .font(.system(size: 12))
                                .foregroundColor(Color.dark3)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            ProfileEditingView()
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }

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
                    if movies.isEmpty {

                        VStack(spacing: 16) {
                            Image("LogoBlack")
                                .font(.system(size: 44))
                                .foregroundColor(.gray.opacity(0.6))

                            Text("No saved movies yet, start save\nyour favourites")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
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
                            ForEach(movies, id: \.self) { movie in
                                NavigationLink {
                                    // MovieDetailsView(movie: movie)
                                } label: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 172, height: 237)
                                        .aspectRatio(2/3, contentMode: .fit)
                                        .overlay(
                                            Text("Poster")
                                                .foregroundColor(.white.opacity(0.6))
                                        )
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
    }
}

#Preview {
    ProfileView()
}
