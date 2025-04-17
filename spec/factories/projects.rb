# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    status { :not_started }

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end

    trait :with_members do
      after(:create) do |project|
        create_list(:project_membership, 3, project: project)
      end
    end
  end
end
