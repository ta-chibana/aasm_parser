# frozen_string_literal: true

class Task < ApplicationRecord
  include AASM

  aasm column: :status do
    state :waiting, initial: true
    state :in_progress, :in_review
    state :finished

    event :start do
      transitions from: :waiting, to: :in_progress
    end

    event :finish do
      transitions from: :in_progress, to: :finished
    end
  end
end
