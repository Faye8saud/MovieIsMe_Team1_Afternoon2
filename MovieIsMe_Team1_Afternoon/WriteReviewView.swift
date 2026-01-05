//
//  WriteReviewView.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//

import SwiftUI

struct WriteReviewView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    @Environment(\.dismiss) private var dismiss

    let movieID: String
    let userID: String

    @State private var reviewText = ""
    @State private var rating = 0
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    reviewSection
                    ratingSection
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
                }
                .padding(24)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    //Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.yellowAccent)
            }

            Spacer()

            Text("Write a review")
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Button(action: submitReview) {
                Text("Add")
                    .foregroundColor(.yellowAccent)
            }
        }
        .padding()
        .overlay(
            Divider().background(Color.white.opacity(0.1)),
            alignment: .bottom
        )
    }
    
    //Review Section
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Review")
                .foregroundColor(.seconderyText)
                .font(.system(size: 18, weight: .medium))
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $reviewText)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .scrollContentBackground(.hidden)
                    .frame(height: 146)
                    .padding(12)
                    .background(Color(white: 0.15))
                    .cornerRadius(8)
                
                if reviewText.isEmpty {
                    Text("Enter your review")
                        .foregroundColor(.gray)
                        .font(.system(size: 17))
                        .padding(.leading, 16)
                        .padding(.top, 20)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    //Rating Section (stars)
    private var ratingSection: some View {
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
                                .foregroundColor(.yellowAccent)
                        }
                    }
                }
            }
        }
    }

    //Submit Review
    private func submitReview() {
                guard !reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    errorMessage = "Please enter a review."
                    return
                }
                guard rating > 0 else {
                    errorMessage = "Please select a rating."
                    return
                }
                errorMessage = nil
                reviewVM.selectedStars = rating
                reviewVM.reviewText = reviewText
                // Make it async so it waits for API
                Task {
                    await reviewVM.submitReview(movieID: movieID, userID: userID)
                    //reviewVM.fetchReviews(movieID: movieID) // refresh reviews
                    dismiss()
                }
            }
}

// Preview
#Preview {
    let reviewVM = ReviewViewModel()
    
    WriteReviewView(movieID: "movie123", userID: "user123")//for testing
        .environmentObject(reviewVM)
}
