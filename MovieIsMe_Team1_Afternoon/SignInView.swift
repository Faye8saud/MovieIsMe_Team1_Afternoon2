//
//  SignInView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    //@StateObject var viewModel = UserViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var signedIn = false
    @State private var isLoading: Bool = false
    
    
    struct PasswordField: View {
        @Binding var password: String
        let isError: Bool
        @State private var isVisible = false

        var body: some View {
            HStack {
                if isVisible {
                    TextField("Password", text: $password)
                        .foregroundColor(isError ? .red : .white)
                        .tint(isError ? .red : .white)
                } else {
                    SecureField("Password", text: $password)
                        .foregroundColor(isError ? .red : .white)
                        .tint(isError ? .red : .white)
                }

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.lightGrey)
                }
            }
            .font(.system(size: 20))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.inputField.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isError ? .red : .clear, lineWidth: 1.5)
            )
            .cornerRadius(8)
        }
    }

    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background image
                Image("signinBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Dark gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.02),
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.9),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // محتوي التسجيل
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    
                    Text("Sign in")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("You'll find what you're looking for in the ocean of movies")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .offset(y:-10)
                    
                    Text("Email")
                        .font(.body)
                        .foregroundColor(.lightGrey)
                        .fontWeight(.bold)
                        .padding(.bottom, -10)

                    TextField("Email", text: $email)
                        .font(.system(size: 20))
                        .foregroundColor(
                                userViewModel.signInError == .email ? .red : .white
                            )
                            .tint(
                                userViewModel.signInError == .email ? .red : .white   // cursor color
                            )
                        .padding(.horizontal, 12)   // internal padding
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity) // fill width
                        .background(Color.inputField.opacity(0.5))
                        .cornerRadius(8)
                        .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        userViewModel.signInError == .email ? .red : .clear,
                                        lineWidth: 1.5
                                    )
                            )


                    Text("Password")
                        .font(.body)
                        .foregroundColor(.lightGrey)
                        .fontWeight(.bold)
                        .padding(.bottom, -10)

                    PasswordField(
                        password: $password,
                        isError: userViewModel.signInError == .password
                    )

                    Button {
                        signedIn = userViewModel.signIn(email: email, password: password)

                    } label: {
                        Text("Sign in")
                            .font(.headline)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 149)
                            .background(Color.yellow)
                            .cornerRadius(8)
                        
                        
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
            .navigationDestination(isPresented: $signedIn) {
                MovieCenterView()
                    .environmentObject(userViewModel)
            }
        }
          }
}

#Preview {
    SignInView()
        .environmentObject(UserViewModel())
}
