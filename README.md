# Project Flow

A project management application built with Ruby on Rails, featuring real-time updates with Turbo Streams.

## Features

- Project management with different statuses (Not Started, In Progress, On Hold, Completed)
- Real-time status updates using Turbo Streams
- Role-based access control (Admin, Project Manager, Project Member)
- Project conversations with comments
- Status change history tracking
- Responsive design with Tailwind CSS

## Prerequisites

- Ruby 3.2.2
- PostgreSQL 14.0 or higher
- Node.js 18.0 or higher
- Yarn 1.22.0 or higher

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd project_flow
   ```

2. **Install dependencies**

   ```bash
   bundle install
   yarn install
   ```

3. **Setup database**

   ```bash
   rails db:setup
   ```

4. **Start the development server**
   ```bash
   ./bin/dev
   ```

The application will be available at `http://localhost:3000`

## Seed Data

The application comes with seed data for testing and development:

### Admin User

- Email: admin@example.com
- Password: password

### Regular Users

- Email: user1@example.com through user5@example.com
- Password: password

Each user is assigned as a manager to at least one project, and the admin user is a manager of all projects.

## Testing

Run the test suite with:

```bash
bundle exec rspec
```
