# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProjectMembership, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:role).in_array(described_class::ROLES) }
  end

  describe "constants" do
    it "defines available roles" do
      expect(described_class::ROLES).to eq(%w[manager member])
    end
  end
end
