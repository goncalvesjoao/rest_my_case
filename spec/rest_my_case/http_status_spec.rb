require 'spec_helper'

describe RestMyCase::HttpStatus do

  context "when status.not_found! is used" do
    NotFound = Class.new(RestMyCase::Base) do
      include RestMyCase::HttpStatus
      def perform; status.not_found!; end
    end

    before { @context = NotFound.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 404
    end

    it "@context.error_response should only list the class's dependencies" do
      expect(@context.error_response).to match a_hash_including({ message: 'unkown error' })
    end
  end

  context "when failure(:unprocessable_entity) is used" do
    UnprocessableEntity = Class.new(RestMyCase::Base) do
      include RestMyCase::HttpStatus
      def perform; failure(:unprocessable_entity); end
    end

    before { @context = UnprocessableEntity.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 422
    end

    it "@context.error_response should only list the class's dependencies" do
      expect(@context.error_response).to match a_hash_including({ status: 'unprocessable_entity', http_status: 422, message: nil })
    end
  end

  context "when failure!(:service_unavailable) is used" do
    InternalServerError = Class.new(RestMyCase::Base) do
      include RestMyCase::HttpStatus
      def perform; failure!(:service_unavailable, { code: 404, message: 'github could not found repo' }); end
    end

    before { @context = InternalServerError.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 503
    end

    it "@context.error_response should only list the class's dependencies" do
      expect(@context.error_response).to match a_hash_including({ status: 'service_unavailable', http_status: 503, code: 404, message: "github could not found repo" })
    end
  end

  context "When a class inherits from another" do
    HttpStatusTestCase1 = Class.new(RestMyCase::Base) do
      include RestMyCase::HttpStatus
    end

    HttpStatusTestCase2 = Class.new(HttpStatusTestCase1)

    before { @context = HttpStatusTestCase2.perform }

    it "context should be Context::HttpStatus" do
      expect(@context.class).to be RestMyCase::Context::HttpStatus
    end
  end

end
