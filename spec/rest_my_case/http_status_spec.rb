require 'spec_helper'

describe RestMyCase::HttpStatus do

  describe "context#http_status" do

    context "when status.not_found! is used" do
      NotFound = Class.new(RestMyCase::HttpStatus) { def perform; status.not_found!; end }

      it "should only list the class's dependencies" do
        expect(NotFound.perform.http_status).to be 404
      end
    end

    context "when failure(:unprocessable_entity) is used" do
      UnprocessableEntity = Class.new(RestMyCase::HttpStatus) { def perform; failure(:unprocessable_entity); end }

      it "should only list the class's dependencies" do
        expect(UnprocessableEntity.perform.http_status).to be 422
      end
    end

    context "when failure!(:internal_server_error) is used" do
      InternalServerError = Class.new(RestMyCase::HttpStatus) { def perform; failure!(:internal_server_error); end }

      it "should only list the class's dependencies" do
        expect(InternalServerError.perform.http_status).to be 500
      end
    end

  end

end
