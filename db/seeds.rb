# frozen_string_literal: true

# Clear existing data
puts "Clearing existing data..."
ProjectMembership.destroy_all
Project.destroy_all
User.destroy_all

# Create admin user
puts "Creating admin user..."
User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  role: "admin"
)

# Create regular users
puts "Creating regular users..."
users = Array.new(5) do |i|
  User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password",
    role: "member"
  )
end

# Create projects with different statuses
puts "Creating projects..."
projects = [
  { name: "Website Redesign", status: "in_progress" },
  { name: "Mobile App Development", status: "not_started" },
  { name: "Database Migration", status: "completed" },
  { name: "API Integration", status: "on_hold" },
  { name: "Security Audit", status: "not_started" }
].map do |attrs|
  Project.create!(attrs)
end

# Add members to projects
puts "Adding members to projects..."

users.each_with_index do |user, index|
  # Assign each user as a manager to one project
  project_index = index % projects.length
  ProjectMembership.create!(
    user:,
    project: projects[project_index],
    role: "manager"
  )
end

projects.each do |project|
  # Add some regular users to each project as members
  # Skip users who are already managers of this project
  existing_managers = project.project_memberships.where(role: "manager").pluck(:user_id)
  available_users = users.reject { |u| existing_managers.include?(u.id) }

  # Add 0-2 additional members to each project
  users_to_add = available_users.sample(rand(0..2))
  users_to_add&.each do |user|
    ProjectMembership.create!(
      user:,
      project:,
      role: "member"
    )
  end
end

# Add some comments and status changes to projects
puts "Adding comments and status changes..."
projects.each do |project|
  project_members = project.members

  # Add some comments
  3.times do |i|
    Comment.create!(
      user: project_members.sample,
      project:,
      content: "Comment #{i + 1} on #{project.name}"
    )
  end

  # Add status changes if project is not in initial state
  next unless project.status != "not_started"
  previous_status = "not_started"
  current_status = project.status

  StatusChange.create!(
    user: project_members.sample,
    project:,
    from_status: previous_status,
    to_status: current_status
  )
end

puts "Seeding completed!"
puts "Admin user: admin@example.com / password"
puts "Regular users: user1@example.com through user5@example.com / password"
