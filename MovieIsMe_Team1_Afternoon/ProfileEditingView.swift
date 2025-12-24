//
//  ProfileEditingView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 04/07/1447 AH.
//

import SwiftUI

struct ProfileEditingView: View {

    @State private var isEditing = false
    @State private var firstName = "Sarah"
    @State private var lastName = "Abdullah"

    var body: some View {
        VStack {
            // MARK: - Custom Navigation Bar
            HStack {
                Button {
                    // back action
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.yellow)
                }

                Spacer()

                Text(isEditing ? "Edit profile" : "Profile info")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button {
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Save" : "Edit")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .overlay(
                Divider()
                    .background(Color.white.opacity(0.1)),
                alignment: .bottom
            )

            // MARK: - Avatar
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 96, height: 96)

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.gray)

                if isEditing {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 96, height: 96)

                    Image(systemName: "camera")
                        .foregroundColor(.yellow)
                        .font(.system(size: 22))
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 16)

            // MARK: - Profile Fields
                      VStack(spacing: 0) {
                          // First name row
                          HStack {
                              Text("First name")
                                  .foregroundColor(.white)
                                  .font(.system(size: 17))
                                  //.padding(.horizontal, 20)
                                  .frame(width: 100, alignment: .leading)
                                  padding()
                                  //.frame(width: 180, alignment: .leading)
                             
                              
                              if isEditing {
                                  TextField("", text: $firstName)
                                      .foregroundColor(.white)
                                      .font(.system(size: 17))
                                    //  .multilineTextAlignment(.trailing)
                              } else {
                                  Text(firstName)
                                      .foregroundColor(.white)
                                      .font(.system(size: 17))
                              }
                          }
                          .padding(.horizontal, 60)
                          .padding(.vertical, 16)
                          .background(Color(white: 0.15))

                          Divider()
                              .background(Color.white.opacity(0.2))
                              .padding(.leading, 20)

                          // Last name row
                          HStack {
                              Text("Last name")
                                  .foregroundColor(.white)
                                  .font(.system(size: 17))

                              //Spacer()
                              
                              if isEditing {
                                  TextField("", text: $lastName)
                                      .foregroundColor(.white)
                                      .font(.system(size: 17))
                                      .multilineTextAlignment(.trailing)
                              } else {
                                  Text(lastName)
                                      .foregroundColor(.white)
                                      .font(.system(size: 17))
                              }
                          }
                          .padding(.horizontal, 20)
                          .padding(.vertical, 16)
                          .background(Color(white: 0.15))
                      }
                      .background(Color(white: 0.15))
                      .cornerRadius(16)
                      .padding(.horizontal, 16)


            Spacer()

            // MARK: - Sign Out
            if(!isEditing){
                Button {
                    // sign out action
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark) // Force Dark Mode
    }
}

#Preview {
    ProfileEditingView()
}
