//
//  WriteReviewView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//


import SwiftUI

struct WriteReviewView: View {
    @State private var navigateToMovieView = false
    @State private var reviewText = ""
    @State private var rating = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Navigation Bar
            HStack {
                Button {
                    navigateToMovieView = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.yellow)
                }

                Spacer()

                Text("Write a review")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button {
                    // Add review action
                } label: {
                    Text("Add")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .overlay(
                Divider().background(Color.white.opacity(0.1)),
                alignment: .bottom
            )

            
            // MARK: - Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Review Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Review")
                            .foregroundColor(.seconderyText)
                            .font(.system(size: 18, weight: .medium))
                        
                        TextEditor(text: $reviewText)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .scrollContentBackground(.hidden)
                            .frame(height: 146)
                            .padding(12)
                            .background(Color(white: 0.15))
                            .cornerRadius(8)
                            .overlay(
                                Group {
                                    if reviewText.isEmpty {
                                        Text("Enter your review")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 17))
                                            .padding(.leading, 16)
                                            .padding(.top, 20)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .allowsHitTesting(false)
                                    }
                                }
                            )
                    }
                    
                    // Rating Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Rating")
                                .foregroundColor(.seconderyText)
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                            
                            HStack(spacing: 3) {
                                ForEach(1...5, id: \.self) { star in
                                    Button {
                                        rating = star
                                    } label: {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.system(size: 21))
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WriteReviewView()
}
