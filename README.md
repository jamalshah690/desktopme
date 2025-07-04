# 📝 Flutter To-Do App (Desktop)

A clean and minimal To-Do List desktop application built with **Flutter**, featuring full CRUD functionality, drag-and-drop task reordering, beautiful animations, and local data persistence using **sqflite**.

 

## 🚀 Features

- ✅ Add, edit, delete tasks
- 🔄 Reorder tasks via drag-and-drop
- 💾 Local data persistence using `sqflite`
- 🎨 Smooth animations using `flutter_staggered_animations`
- 📅 Date formatting with `intl`
- ☁️ Clean and scalable folder structure (clean architecture)
- 🖥️ Flutter Desktop (Windows)

---

## 📁 Project Structure
lib/
├── core/ # Global configs, theme, assets, etc.
├── feature/
│ └── Auth/
│ ├── domain/ # userModel
│ ├── data/ # Local DB (sqflite)
│ ├── presentation/ # UI & widgets
| |__ provider/ # Bussiness Logic
│ └── todo/
│ ├── domain/ # TodoModel
│ ├── data/ # Local DB (sqflite)
│ ├── presentation/ # UI & widgets
| |__ provider/ # Bussiness Logic
├── main.dart
