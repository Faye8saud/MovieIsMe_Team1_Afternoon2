//
//  SignInView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 23/12/2025.
//

import SwiftUI

struct SignInView: View {
    @State private var Email: String = ""
    @State private var Password: String = ""
    @State private var isLoading: Bool = false
    var body: some View {
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

                      // inputs
                      Text("Email")
                          .font(.body)
                          .foregroundColor(.lightGrey)
                          .fontWeight(.bold)
                          .padding(.bottom, -10)
                      TextField("Email", text: $Email)
                                 .font(.system(size: 20))
                                 .foregroundColor(.white)
                                 .padding(.horizontal, 149)
                                 .padding(.vertical, 10)
                                 .background(Color.inputField.opacity(0.5))
                                 .cornerRadius(8)
                         
                      Text("Password")
                          .font(.body)
                          .foregroundColor(.lightGrey)
                          .fontWeight(.bold)
                          .padding(.bottom, -10)
                      TextField("password", text: $Password)
                                 .font(.system(size: 20))
                                 .foregroundColor(.white)
                                 .padding(.horizontal, 149)
                                 .padding(.vertical, 10)
                                 .background(Color.inputField.opacity(0.5))
                                 .cornerRadius(8)
                      
                      Button {
                          // sign in action
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
                          
                           
                             /*.font(.headline)
                              .frame(maxWidth: .infinity)
                              .background(Color.yellow)
                              .foregroundColor(.black)
                             .padding(.horizontal, 16)
                             .padding(.vertical, 14)
                              .cornerRadius(14)
                              .frame(height: 50)
                          */
                          
                      }
                      .padding(.top, 10)
                  }
                  .padding(.horizontal, 24)
                  .padding(.bottom, 50)
              }
          }
}

#Preview {
    SignInView()
}
