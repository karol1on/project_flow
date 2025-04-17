# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conversation::CreateComment do
  subject { described_class.new(user:, project:, params:) }

  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:params) do
    {
      content: "Test comment",
      attachments: []
    }
  end

  describe "#call" do
    context "with valid parameters" do
      it "creates a new comment" do
        expect do
          subject.call
        end.to change(Comment, :count).by(1)
      end

      it "returns a success result" do
        result = subject.call
        expect(result).to be_success
      end

      it "returns the created comment" do
        result = subject.call
        expect(result.object).to be_a(Comment)
      end

      it "broadcasts the comment" do
        expect(Turbo::StreamsChannel).to receive(:broadcast_prepend_to).with(
          "project_#{project.id}_conversation",
          target: "conversation_items",
          partial: "conversation_items/item",
          locals: { item: kind_of(Comment) }
        )

        subject.call
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          content: "",
          attachments: []
        }
      end

      it "does not create a new comment" do
        expect do
          subject.call
        end.not_to change(Comment, :count)
      end

      it "returns a failure result" do
        result = subject.call
        expect(result).to be_failure
      end

      it "returns error messages" do
        result = subject.call
        expect(result.errors).to have_key(:content)
      end
    end
  end
end
