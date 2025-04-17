# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConversationItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe "scopes" do
    describe ".chronological" do
      let!(:old_item) { create(:comment, created_at: 2.days.ago) }
      let!(:new_item) { create(:status_change, created_at: 1.day.ago) }
      let!(:latest_item) { create(:comment, created_at: Time.current) }

      it "returns items in descending order by created_at" do
        expect(described_class.chronological).to eq([latest_item, new_item, old_item])
      end
    end
  end
end
