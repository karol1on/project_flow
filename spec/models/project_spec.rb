# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:project_memberships) }
    it { is_expected.to have_many(:members).through(:project_memberships) }
    it { is_expected.to have_many(:conversation_items) }
    it { is_expected.to have_many(:status_changes) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe "enums" do
    it do
      expect(subject).to define_enum_for(:status).with_values(
        "not_started" => 0,
        "in_progress" => 1,
        "on_hold" => 2,
        "completed" => 3,
        "cancelled" => 4
      )
    end
  end
end
