# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatusChangeForm, type: :model do
  subject { described_class.new(params) }

  let(:user) { create(:user) }
  let(:project) { create(:project, status: "not_started") }
  let(:params) do
    {
      project_id: project.id,
      user_id: user.id,
      to_status: "in_progress"
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:project_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:to_status) }
  end

  describe "#save" do
    context "with valid parameters" do
      it "creates a new status change" do
        expect { subject.save }.to change(StatusChange, :count).by(1)
      end

      it "sets the correct from_status" do
        subject.save
        expect(subject.status_change.from_status).to eq("not_started")
      end

      it "sets the correct to_status" do
        subject.save
        expect(subject.status_change.to_status).to eq("in_progress")
      end

      it "returns true" do
        expect(subject.save).to be true
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          project_id: project.id,
          user_id: user.id,
          to_status: ""
        }
      end

      it "does not create a new status change" do
        expect { subject.save }.not_to change(StatusChange, :count)
      end

      it "returns false" do
        expect(subject.save).to be false
      end

      it "adds error messages" do
        subject.save
        expect(subject.errors).to have_key(:to_status)
      end
    end
  end
end
