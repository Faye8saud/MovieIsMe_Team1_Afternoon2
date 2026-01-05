# 🎬 MovieISMe

**MovieISMe** is an iOS movie discovery application built with **SwiftUI**.  
It allows users to browse movies, view detailed information, save favorite movies, and manage their personal profile — all with a modern, smooth iOS experience.

The app uses **Airtable as a backend**, follows **MVVM architecture**, and leverages **Swift Concurrency (async/await)** for clean and efficient networking.

---

## ✨ Features

- 🔍 **Browse Movies**
  - Fetch movies from a remote API
  - High-rated movies carousel
  - Genre-based sections (Drama, Comedy, etc.)

- 📄 **Movie Details**
  - Poster, title, story, runtime, genre, and age rating
  - IMDb rating
  - Director and cast information
  - Native iOS share sheet (AirDrop, Messages, Mail, Notes)

- 🔖 **Save Movies**
  - Bookmark movies using the bookmark button
  - Saved movies are linked to the logged-in user
  - Saved movies appear in the Profile page

- 👤 **User Profile**
  - Displays user name, email, and profile image
  - Grid view of saved movies
  - Profile editing support

- 🔎 **Search**
  - Search movies by title
  - Real-time filtering

---

## 🛠️ Tech Stack

- **SwiftUI**
- **MVVM Architecture**
- **Swift Concurrency (async/await)**
- **Combine**
- **Airtable REST API**
- **ShareLink (iOS Share Sheet)**

---

## 🧱 Architecture Overview

The app follows the **MVVM (Model–View–ViewModel)** pattern.

### Models
- `MovieModel`
- `MovieActorModels`
 - `MovieDirectorModels`
- `MovieAPiModel`
- `SavedMoviesModel`
- `UserAPiModel`
- `ReviewAPiModel`

### ViewModels
- `MovieViewModel` – Fetches and filters movies
- `MovieDetailsViewModel` – Handles movie details, cast, and director
- `SavedMoviesViewModel` – Fetches and saves bookmarked movies
- `UserViewModel` – Manages user session and profile data
-  `ReviewViewModel` – fetches and manages reviews
-  `sessionManager` – keeps track of user sessions
-  `APIconstants` – to store API reusable constants

### Views
- `MovieCenterView`
- `MovieDetailView`
- `ProfileView`
- `SignInView`
-  `ProfileEditingView`
- `MovieRowView`
- `MoviePosterView`
- `writeReviewView`
- `MovieIsMeAPP`


## 👩‍💻 Code by Team 1

- [Fay](https://github.com/Faye8saud)
- [Hissah](https://github.com/hessah404)
- [Wasan](https://github.com/itWasan7)
