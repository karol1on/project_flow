# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conversation::ChangeStatus do
  subject(:service) { described_class.new(user:, project:, params:) }

  let(:user) { create(:user) }
  let(:project) { create(:project, status: "in_progress") }
  let(:params) { { to_status: "completed" } }

  describe "#call" do
    context "when the status change is valid" do
      it "creates a status change record" do
        expect { service.call }.to change(StatusChange, :count).by(1)
      end

      it "updates the project status" do
        service.call
        expect(project.reload.status).to eq("completed")
      end

      it "returns a success result" do
        result = service.call
        expect(result).to be_success
        expect(result.object).to be_a(StatusChange)
      end

      it "broadcasts status badge update" do
        expect(Turbo::StreamsChannel).to receive(:broadcast_update_to).with(
          "project_#{project.id}",
          target: "project_status_badge",
          partial: "projects/status_badge",
          locals: { project: }
        )
        service.call
      end

      it "broadcasts conversation item update" do
        expect(Turbo::StreamsChannel).to receive(:broadcast_prepend_to).with(
          "project_#{project.id}_conversation",
          target: "conversation_items",
          partial: "conversation_items/item",
          locals: { item: kind_of(StatusChange) }
        )
        service.call
      end
    end

    context "when the status change is invalid" do
      let(:params) { { to_status: nil } }

      it "does not create a status change record" do
        expect { service.call }.not_to change(StatusChange, :count)
      end

      it "does not update the project status" do
        service.call
        expect(project.reload.status).to eq("in_progress")
      end

      it "returns a failure result" do
        result = service.call
        expect(result).to be_failure
        expect(result.errors).to include(:status)
      end

      it "does not broadcast any updates" do
        expect(Turbo::StreamsChannel).not_to receive(:broadcast_update_to)
        expect(Turbo::StreamsChannel).not_to receive(:broadcast_prepend_to)
        service.call
      end
    end

    context "when the project status update fails" do
      before do
        allow(project).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(project))
      end

      it "rolls back the transaction" do
        expect { service.call }.not_to change(StatusChange, :count)
        expect(project.reload.status).to eq("in_progress")
      end
    end
  end
end
