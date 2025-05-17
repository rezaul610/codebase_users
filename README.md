# codebase_users

# 🧑‍💼 Flutter User List App

A Flutter application that displays a list of users from the [Reqres API](https://reqres.in/api/users).  
It features infinite scrolling, pull-to-refresh, and real-time search functionality — all built using **Flutter BLoC**, **http**, and **pull_to_refresh** packages.

---

## 📦 Features

✅ Fetch user list from REST API  
✅ Infinite scroll (pagination)  
✅ Pull to refresh  
✅ Real-time search (first name & last name)  
✅ Clean BLoC-based architecture  
✅ Reusable components  

---

## 🛠️ Tech Stack

- **Flutter** 🐦  
- **BLoC (flutter_bloc)** – State management  
- **HTTP** – API requests  
- **pull_to_refresh** – Refresh & load more list  
- **Dart** – Programming language  

---

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rezaul610/codebase_users.git
   cd codebase_users
2. **Install dependencies**
    ```bash
    flutter pub get
3. **Run the app**
    ```bash
    flutter run


# 📁 Project Structure
    ```bash
    lib/
    ├── bloc/                               # BLoC logic (events, states, bloc)
    │   ├── user_bloc.dart
    │   ├── user_event.dart
    │   └── user_state.dart
    ├── models/                             # Data models
    │   └── user_model.dart
    ├── data/                               # API calls & Local Server Access
    │   ├── repository/
    │   │   └── user_repository.dart
    │   └── data_provider/             
    │       ├── user_data_provider.dart     # API calls
    │       └── user_local_provider.dart    # Local server 
    ├── presentation/                       # UI screens
    │   ├── user_list_screen.dart
    │   └── user_detail_screen.dart
    ├── services/                           # Service call 
    │   └── connectivity_service.dart
    └── main.dart                           # App entry point


