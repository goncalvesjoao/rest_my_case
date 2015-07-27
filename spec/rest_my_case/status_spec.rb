require 'spec_helper'

describe RestMyCase::Status do

  describe "context#status" do

    context "when status.not_found! is used" do
      StatusTestCase1 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          status.accepted!
        end
      end

      before { @context = StatusTestCase1.perform }

      it "@context.status.accepted? should be true" do
        expect(@context.status.accepted?).to be true
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end
    end

    context "when error(:unprocessable_entity) is used" do
      StatusTestCase2 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          error(:unprocessable_entity)
          context.next_line = true
        end
      end

      before { @context = StatusTestCase2.perform }

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
        expect(@context.errors).to match [a_hash_including({ status: 'unprocessable_entity', message: nil, class_name: "StatusTestCase2" })]
      end
    end

    context "when error!(:internal_server_error) is used" do
      StatusTestCase3 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          error!(:internal_server_error)
          context.next_line = true
        end
      end

      before { @context = StatusTestCase3.perform }

      it "@context.status.internal_server_error? should be true" do
        expect(@context.status.internal_server_error?).to be true
      end

      it "@context.next_line should raise an error" do
        expect { context.next_line }.to raise_error
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        expect(@context.errors).to match [a_hash_including({ status: 'internal_server_error', message: nil, class_name: "StatusTestCase3" })]
      end
    end

    context "when error!(status: :internal_server_error, message: 'something bad') is used" do
      StatusTestCase4 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          error!(status: :internal_server_error, message: 'something bad', yada: true)
          context.next_line = true
        end
      end

      before { @context = StatusTestCase4.perform }

      it "@context.status.internal_server_error? should be true" do
        expect(@context.status.internal_server_error?).to be true
      end

      it "@context.next_line should raise an error" do
        expect { context.next_line }.to raise_error
      end

      it "@context.status.ok? should be false" do
        expect(@context.status.ok?).to be false
      end

      it "context's errors should have a proper message" do
        expect(@context.errors).to match [a_hash_including({ status: 'internal_server_error', message: 'something bad', class_name: "StatusTestCase4", yada: true })]
      end
    end

    context "when failure(:unprocessable_entity) is used" do
      StatusTestCase5 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          failure(:unprocessable_entity, 'invalid id')
          context.next_line = true
        end
      end

      before { @context = StatusTestCase5.perform }

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
        expect(@context.errors).to match [a_hash_including({ status: 'unprocessable_entity', message: 'invalid id', class_name: "StatusTestCase5" })]
      end
    end

    context "when failure!(:internal_server_error) is used" do
      StatusTestCase6 = Class.new(RestMyCase::Base) do
        include RestMyCase::Status
        def perform
          failure!(:internal_server_error, 'while saving the resource')
          context.next_line = true
        end
      end

      before { @context = StatusTestCase6.perform }

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
        expect(@context.errors).to match [a_hash_including({ status: 'internal_server_error', message: 'while saving the resource', class_name: "StatusTestCase6" })]
      end
    end

  end

end
