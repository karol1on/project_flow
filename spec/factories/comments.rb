# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { "Test comment" }
    association :project
    association :user

    trait :with_attachments do
      after(:build) do |comment|
        comment.attachments.attach(
          io: Rails.root.join("spec/fixtures/files/test.txt").open,
          filename: "test.txt",
          content_type: "text/plain"
        )
      end
    end
  end
end
