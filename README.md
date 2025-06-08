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
2. Create a new project in Supabase
3. Copy `.env.example` to `.env` and fill in your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_url_here
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   ```
4. Create a `tasks` table in Supabase with the following columns:
   - `id` (uuid, primary key)
   - `title` (text, not null)
   - `is_completed` (boolean, default: false)
   - `created_at` (timestamp with time zone, default: now())

5. Run the following commands:
   ```bash
   flutter pub get
   flutter run
   ```

## Dependencies

- flutter_riverpod: State management
- supabase_flutter: Backend and real-time updates
- uuid: Generating unique IDs
- intl: Date formatting
