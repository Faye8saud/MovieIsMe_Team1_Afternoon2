import SwiftUI

struct ProfileEditingView: View {

    @EnvironmentObject var userViewModel: UserViewModel

    // MARK: - Navigation
    @State private var navigateToProfile = false

    // MARK: - State
    @State private var isEditing = false
    @State private var signedOut = false
    
    @State private var draftFirstName = ""
    @State private var draftLastName = ""

    // MARK: - Body
    var body: some View {
            VStack {
                navigationBar
                avatarView
                profileFields

                Spacer()

                if !isEditing {
                    signOutButton
                }
                NavigationLink(
                    destination: SignInView()
                        .environmentObject(userViewModel)
                        .navigationBarBackButtonHidden(true),
                        isActive: $signedOut
                    ) {
                            EmptyView()
                    }

                // Hidden navigation trigger
                NavigationLink(
                    destination: ProfileView()
                        .environmentObject(userViewModel)
                        .navigationBarBackButtonHidden(true),
                    isActive: $navigateToProfile
                ) {
                    EmptyView()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .onAppear {
            if let user = userViewModel.currentUser?.fields {
                let nameParts = user.name.split(separator: " ", maxSplits: 1).map(String.init)
                draftFirstName = nameParts.first ?? ""
                draftLastName = nameParts.count > 1 ? nameParts[1] : ""
            }
        }

    }
}

// MARK: - Subviews
extension ProfileEditingView {

    // MARK: Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button {
                if isEditing {
                    // ❌ Discard changes
                    isEditing = false
                } else {
                    // ✅ Navigate to ProfileView
                    navigateToProfile = true
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.yellowAccent)
            }

            Spacer()

            Text(isEditing ? "Edit profile" : "Profile info")
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Button {
                if isEditing {
                    // ✅ Save changes
                    userViewModel.updateProfile(
                            firstName: draftFirstName,
                            lastName: draftLastName
                        )
                        isEditing = false
                } else {
                    // Enter edit mode
//                    draftFirstName = firstName
//                    draftLastName = lastName
                    isEditing = true
                }
            } label: {
                Text(isEditing ? "Save" : "Edit")
                    .foregroundColor(.yellowAccent)
            }
        }
        .padding()
        .overlay(
            Divider().background(Color.white.opacity(0.1)),
            alignment: .bottom
        )
    }

    // MARK: Avatar
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 96, height: 96)

            AsyncImage(
                url: URL(string: userViewModel.currentUser?.fields.profile_image ?? "")
            ) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 96, height: 96)
            .clipShape(Circle())


            if isEditing {
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 96, height: 96)

                Image(systemName: "camera")
                    .font(.system(size: 22))
                    .foregroundColor(.yellowAccent)
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    // MARK: Profile Fields
    private var profileFields: some View {
        VStack(spacing: 0) {
            profileRow(title: "First name", text: $draftFirstName)


            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 8)

            profileRow(title: "Last name", text: $draftLastName)
        }
        .background(Color(white: 0.15))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }

    // MARK: Sign Out
    private var signOutButton: some View {
        Button {
            // sign out action
            signedOut = true
            userViewModel.signOut()
            
        } label: {
            Text("Sign Out")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(white: 0.15))
                )
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
    }
}

// MARK: - Reusable Row
extension ProfileEditingView {

    private func profileRow(
        title: String,
        text: Binding<String>
    ) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 18))
                .frame(width: 100, alignment: .leading)

            if isEditing {
                TextField("", text: text)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            } else {
                Text(text.wrappedValue)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(white: 0.15))
    }
}

// MARK: - Preview
#Preview {
    ProfileEditingView()
        .environmentObject(UserViewModel())
}
