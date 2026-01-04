//
//  ReviewCard.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 15/07/1447 AH.
//

//import SwiftUI
//
//struct ReviewCard: View {
//    let review: Review
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//
//            // المستخدم + النجوم
//            HStack(spacing: 10) {
//                Circle()
//                    .fill(Color.gray.opacity(0.4))
//                    .frame(width: 36, height: 36)
//
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(review.name)
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.white)
//
//                    HStack(spacing: 2) {
//                        ForEach(0..<5) { i in
//                            Image(systemName: i < review.rating ? "star.fill" : "star")
//                                .font(.system(size: 12))
//                                .foregroundColor(.yellow)
//                        }
//                    }
//                }
//            }
//
//            Text(review.text)
//                .font(.system(size: 14))
//                .foregroundColor(.white.opacity(0.8))
//                .lineLimit(4)
//
//            Spacer()
//
//            Text(review.date)
//                .font(.system(size: 12))
//                .foregroundColor(.white.opacity(0.4))
//        }
//        .padding()
//        .frame(width: 280, height: 160) // ⭐ حجم ثابت = شكل ثابت
//        .background(Color.white.opacity(0.08))
//        .cornerRadius(16)
//    }
//}
