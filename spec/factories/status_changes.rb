# frozen_string_literal: true

FactoryBot.define do
  factory :status_change do
    association :project
    association :user
    from_status { :not_started }
    to_status { :in_progress }
  end
end
