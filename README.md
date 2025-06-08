# TaskAway

A simple task management application built with Flutter and Supabase.

## Features

- Add new tasks
- List all tasks
- Mark tasks as complete/incomplete
- Edit task titles
- Delete tasks
- Real-time updates using Supabase

## Setup

1. Clone the repository
2. Run the following commands:
   ```bash
   flutter pub get
   flutter run
   ```

## Architecture

The application follows a clean and modular architecture using Flutter with Riverpod for state management and Supabase as the backend. Here's the breakdown:

### Directory Structure
- `/lib`
  - `/models`: Contains data models (e.g., Task model)
  - `/notifiers`: State management using Riverpod notifiers
  - `/providers`: Dependency injection and state providers
  - `/screens`: UI screens/pages of the application
  - `/services`: Backend services (e.g., Supabase service)

### Key Components
1. **State Management**
   - Uses Riverpod for reactive state management
   - TaskNotifier manages the task state and operations
   - Providers handle dependency injection

2. **Data Layer**
   - Supabase integration for backend storage
   - Models handle data serialization/deserialization
   - Services abstract the backend communication

3. **UI Layer**
   - Material Design 3 with custom theme
   - Modular screen components
   - Reactive UI updates through Riverpod

4. **Dependencies**
   - flutter_riverpod: State management
   - supabase_flutter: Backend integration
   - flutter_material: UI components
