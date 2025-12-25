import SwiftUI

struct ProfileEditingView: View {

    // MARK: - Navigation
    @State private var navigateToProfile = false

    // MARK: - State
    @State private var isEditing = false

    @State private var firstName = "Sarah"
    @State private var lastName = "Abdullah"

    // Draft values (used only while editing)
    @State private var draftFirstName = ""
    @State private var draftLastName = ""

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                navigationBar
                avatarView
                profileFields

                Spacer()

                if !isEditing {
                    signOutButton
                }

                // Hidden navigation trigger
                NavigationLink(
                    destination: ProfileView(),
                    isActive: $navigateToProfile
                ) {
                    EmptyView()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
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
                .foregroundColor(.yellow)
            }

            Spacer()

            Text(isEditing ? "Edit profile" : "Profile info")
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Button {
                if isEditing {
                    // ✅ Save changes
                    firstName = draftFirstName
                    lastName = draftLastName
                    isEditing = false
                } else {
                    // Enter edit mode
                    draftFirstName = firstName
                    draftLastName = lastName
                    isEditing = true
                }
            } label: {
                Text(isEditing ? "Save" : "Edit")
                    .foregroundColor(.yellow)
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
                    .font(.system(size: 22))
                    .foregroundColor(.yellow)
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    // MARK: Profile Fields
    private var profileFields: some View {
        VStack(spacing: 0) {
            profileRow(
                title: "First name",
                text: isEditing ? $draftFirstName : $firstName
            )

            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 8)

            profileRow(
                title: "Last name",
                text: isEditing ? $draftLastName : $lastName
            )
        }
        .background(Color(white: 0.15))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }

    // MARK: Sign Out
    private var signOutButton: some View {
        Button {
            // sign out action
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
}
