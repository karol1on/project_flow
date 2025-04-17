# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentForm, type: :model do
  subject { described_class.new(params) }

  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:params) do
    {
      content: "Test comment",
      project_id: project.id,
      user_id: user.id,
      attachments: []
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:project_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe "#save" do
    context "with valid parameters" do
      it "creates a new comment" do
        expect do
          subject.save
        end.to change(Comment, :count).by(1)
      end

      it "sets the correct attributes" do
        subject.save
        comment = subject.comment
        expect(comment.content.to_s.strip).to eq(
          "<div class=\"trix-content\">\n  Test comment\n</div>"
        )
        expect(comment.project_id).to eq(project.id)
        expect(comment.user_id).to eq(user.id)
      end

      it "returns true" do
        expect(subject.save).to be true
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          content: "",
          project_id: project.id,
          user_id: user.id,
          attachments: []
        }
      end

      it "does not create a new comment" do
        expect { subject.save }.not_to change(Comment, :count)
      end

      it "returns false" do
        expect(subject.save).to be false
      end

      it "adds error messages" do
        subject.save
        expect(subject.errors).to have_key(:content)
      end
    end
  end
end
