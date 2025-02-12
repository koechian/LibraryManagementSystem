# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Clear existing data
puts "Clearing existing data..."
Borrowing.destroy_all
Book.destroy_all
User.destroy_all

# Create users
puts "Creating users..."
users = [
  {
    name: "John Doe",
    email: "john@example.com",
    password_digest: "password123"
  },
  {
    name: "Jane Smith",
    email: "jane@example.com",
    password_digest: "password123"
  },
  {
    name: "Admin User",
    email: "admin@example.com",
    password_digest: "admin123"
  }
].map do |user_attributes|
  User.create!(user_attributes)
end

# Create books
puts "Creating books..."
books = [
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    isbn: "0743273567"
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    isbn: "0446310786"
  },
  {
    title: "1984",
    author: "George Orwell",
    isbn: "0451524934"
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    isbn: "0141439518"
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    isbn: "0547928227"
  },
  {
    title: "The Catcher in the Rye",
    author: "J.D. Salinger",
    isbn: "0316769488"
  },
  {
    title: "The Lord of the Rings",
    author: "J.R.R. Tolkien",
    isbn: "0544003415"
  },
  {
    title: "Brave New World",
    author: "Aldous Huxley",
    isbn: "0060850523"
  }
].map do |book_attributes|
  Book.create!(book_attributes)
end

# Create some borrowings (some current, some returned)
puts "Creating borrowings..."

# Current borrowings
2.times do |i|
  Borrowing.create!(
    user: users[i],
    book: books[i],
    borrowed_at: Time.current - 1.week,
    due_date: Time.current + 1.week
  )
end

# Overdue borrowing
Borrowing.create!(
  user: users[0],
  book: books[2],
  borrowed_at: Time.current - 3.weeks,
  due_date: Time.current - 1.week
)

# Returned borrowings
3.times do |i|
  Borrowing.create!(
    user: users[i],
    book: books[i + 3],
    borrowed_at: Time.current - 2.months,
    due_date: Time.current - 6.weeks,
    returned_at: Time.current - 7.weeks
  )
end

# Print summary
puts "\nSeeding completed!"
puts "Created:"
puts "- #{User.count} users"
puts "- #{Book.count} books"
puts "- #{Borrowing.count} borrowings"
puts "  - #{Borrowing.current.count} current borrowings"
puts "  - #{Borrowing.overdue.count} overdue borrowings"
puts "  - #{Borrowing.returned.count} returned borrowings"
puts "\nSample user login:"
puts "Email: john@example.com"
puts "Password: password123"