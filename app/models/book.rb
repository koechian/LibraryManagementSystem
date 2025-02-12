class Book < ApplicationRecord
    has_many :borrowings, dependent: :restrict_with_error
    has_many :users, through: :borrowings
  
    validates :title, presence: true
    validates :author, presence: true
    validates :isbn, presence: true, uniqueness: true,
              format: { with: /\A(?:\d[- ]?){9}[\dX]\z/, message: "must be a valid ISBN-10" }
  
    # Scopes
    scope :available, -> { 
      where.not(id: Borrowing.current.select(:book_id))
    }
    
    scope :borrowed, -> {
      where(id: Borrowing.current.select(:book_id))
    }
  
    # Methods
    def available?
      !borrowings.current.exists?
    end
  
    def current_borrowing
      borrowings.current.first
    end
  
    def current_borrower
      current_borrowing&.user
    end
  
    def borrow(user)
      return false unless available?
  
      borrowings.create(
        user: user,
        borrowed_at: Time.current,
        due_date: 2.weeks.from_now
      )
    end
  end
  