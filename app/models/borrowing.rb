class Borrowing < ApplicationRecord
    belongs_to :user
    belongs_to :book
  
    validates :borrowed_at, presence: true
    validates :due_date, presence: true
    validate :book_must_be_available, on: :create
    validate :return_date_must_be_after_borrowed_at
  
    # Scopes
    scope :current, -> { where(returned_at: nil) }
    scope :overdue, -> { current.where('due_date < ?', Time.current) }
    scope :returned, -> { where.not(returned_at: nil) }
    scope :for_user, ->(user) { where(user: user) }
  
    # Callbacks
    before_validation :set_due_date, on: :create
  
    # Methods
    def return!
      return false if returned?
      
      update!(returned_at: Time.current)
    end
  
    def returned?
      returned_at.present?
    end
  
    def overdue?
      !returned? && due_date < Time.current
    end
  
    def days_overdue
      return 0 if !overdue?
      (Time.current.to_date - due_date.to_date).to_i
    end
  
    private
  
    def set_due_date
      self.due_date ||= 2.weeks.from_now
    end
  
    def book_must_be_available
      return unless book
      
      if book.borrowings.current.exists?
        errors.add(:book, "is already borrowed")
      end
    end
    def return_date_must_be_after_borrowed_at
        return unless returned_at && borrowed_at
        
        if returned_at < borrowed_at
          errors.add(:returned_at, "must be after the borrowed date")
        end
      end
    end