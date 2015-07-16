require 'spec_helper'

describe RestMyCase::HttpStatus do

  context "when status.not_found! is used" do
    NotFound = Class.new(RestMyCase::HttpStatus) { def perform; status.not_found!; end }

    before { @context = NotFound.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 404
    end

    it "@context.error_message should only list the class's dependencies" do
      expect(@context.error_message).to match a_hash_including({:message=>"unknown error"})
    end
  end

  context "when failure(:unprocessable_entity) is used" do
    UnprocessableEntity = Class.new(RestMyCase::HttpStatus) { def perform; failure(:unprocessable_entity); end }

    before { @context = UnprocessableEntity.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 422
    end

    it "@context.error_message should only list the class's dependencies" do
      expect(@context.error_message).to match a_hash_including({:message=>"unprocessable_entity"})
    end
  end

  context "when failure!(:internal_server_error) is used" do
    InternalServerError = Class.new(RestMyCase::HttpStatus) { def perform; failure!(:internal_server_error, 'failed to save'); end }

    before { @context = InternalServerError.perform }

    it "@context.http_status should only list the class's dependencies" do
      expect(@context.http_status).to be 500
    end

    it "@context.error_message should only list the class's dependencies" do
      expect(@context.error_message).to match a_hash_including({:message=>"internal_server_error - failed to save"})
    end
  end

end
