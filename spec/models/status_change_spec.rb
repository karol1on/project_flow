# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatusChange, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:from_status) }
    it { is_expected.to validate_presence_of(:to_status) }
  end
end
