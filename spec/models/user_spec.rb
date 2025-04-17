# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:project_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:projects).through(:project_memberships) }
    it { is_expected.to have_many(:conversation_items) }
  end

  describe "devise modules" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "#admin?" do
    let(:user) { create(:user) }

    context "when user is an admin" do
      before { user.update(role: "admin") }

      it "returns true" do
        expect(user.admin?).to be true
      end
    end

    context "when user is not an admin" do
      before { user.update(role: "member") }

      it "returns false" do
        expect(user.admin?).to be false
      end
    end
  end

  describe "#project_role" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    context "when user is a member of the project" do
      before do
        create(:project_membership, user:, project:, role: "manager")
      end

      it "returns the user's role in the project" do
        expect(user.project_role(project)).to eq("manager")
      end
    end

    context "when user is not a member of the project" do
      it "returns nil" do
        expect(user.project_role(project)).to be_nil
      end
    end
  end

  describe "#project_manager?" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    context "when user is an admin" do
      before { user.update(role: "admin") }

      it "returns true" do
        expect(user.project_manager?(project)).to be true
      end
    end

    context "when user is a project manager" do
      before do
        create(:project_membership, user: user, project: project, role: "manager")
      end

      it "returns true" do
        expect(user.project_manager?(project)).to be true
      end
    end

    context "when user is neither admin nor project manager" do
      before do
        create(:project_membership, user: user, project: project, role: "member")
      end

      it "returns false" do
        expect(user.project_manager?(project)).to be false
      end
    end
  end

  describe "#project_member?" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    context "when user is an admin" do
      before { user.update(role: "admin") }

      it "returns true" do
        expect(user.project_member?(project)).to be true
      end
    end

    context "when user is a project member" do
      before do
        create(:project_membership, user: user, project: project)
      end

      it "returns true" do
        expect(user.project_member?(project)).to be true
      end
    end

    context "when user is not a project member" do
      it "returns false" do
        expect(user.project_member?(project)).to be false
      end
    end
  end
end
