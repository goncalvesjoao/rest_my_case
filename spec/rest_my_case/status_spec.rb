require 'spec_helper'

describe RestMyCase::Status do

  describe "context#status" do

    context "when status.not_found! is used" do
      TestCase1 = Class.new(described_class) { def perform; status.accepted!; end }

      before { @context = TestCase1.perform }

      it "@context.status.accepted? should be true" do
        expect(@context.status.accepted?).to be true
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end
    end

    context "when error(:unprocessable_entity) is used" do
      TestCase2 = Class.new(described_class) do
        def perform
          error(:unprocessable_entity)
          context.next_line = true
        end
      end

      before { @context = TestCase2.perform }

      it "@context.status.unprocessable_entity? should be true" do
        expect(@context.status.unprocessable_entity?).to be true
      end

      it "@context.next_line should be true" do
        expect(@context.next_line).to be true
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        message = "unprocessable_entity"

        expect(@context.errors["TestCase2"]).to eq [message]
        expect(@context.errors.messages).to eq [message]
      end
    end

    context "when error!(:internal_server_error) is used" do
      TestCase3 = Class.new(described_class) do
        def perform
          error!(:internal_server_error)
          context.next_line = true
        end
      end

      before { @context = TestCase3.perform }

      it "@context.status.internal_server_error? should be true" do
        expect(@context.status.internal_server_error?).to be true
      end

      it "@context.next_line should be true" do
        expect { context.next_line }.to raise_error
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        message = "internal_server_error"

        expect(@context.errors["TestCase3"]).to eq [message]
        expect(@context.errors.messages).to eq [message]
      end
    end

    context "when failure(:unprocessable_entity) is used" do
      TestCase4 = Class.new(described_class) do
        def perform
          failure(:unprocessable_entity, 'invalid id')
          context.next_line = true
        end
      end

      before { @context = TestCase4.perform }

      it "@context.status.unprocessable_entity? should be true" do
        expect(@context.status.unprocessable_entity?).to be true
      end

      it "@context.next_line should be true" do
        expect(@context.next_line).to be true
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        message = "unprocessable_entity - invalid id"

        expect(@context.errors["TestCase4"]).to eq [message]
        expect(@context.errors.messages).to eq [message]
      end
    end

    context "when failure!(:internal_server_error) is used" do
      TestCase5 = Class.new(described_class) do
        def perform
          failure!(:internal_server_error, 'while saving the resource')
          context.next_line = true
        end
      end

      before { @context = TestCase5.perform }

      it "@context.status.internal_server_error? should be true" do
        expect(@context.status.internal_server_error?).to be true
      end

      it "@context.next_line should be true" do
        expect { context.next_line }.to raise_error
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        message = "internal_server_error - while saving the resource"

        expect(@context.errors["TestCase5"]).to eq [message]
        expect(@context.errors.messages).to eq [message]
      end
    end

  end

end
