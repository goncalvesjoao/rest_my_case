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

    context "when failure(:unprocessable_entity) is used" do
      TestCase2 = Class.new(described_class) do
        def perform
          failure(:unprocessable_entity)
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
        expect(@context.errors["TestCase2"]).to eq ["unprocessable_entity"]
      end
    end

    context "when failure!(:internal_server_error) is used" do
      TestCase3 = Class.new(described_class) do
        def perform
          failure!(:internal_server_error)
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
        expect(TestCase3.perform.errors["TestCase3"]).to eq ["internal_server_error"]
      end
    end

  end

end
