# frozen_string_literal: true

RSpec.describe "Domains" do
  let(:client) { RenderAPI.client "test-api-key" }
  let(:service_id) { "random-string" }

  subject { client.domains }

  describe "create" do
    before :each do
      stub_request(
        :post, "https://api.render.com/v1/services/#{service_id}/custom-domains"
      ).to_return_json(
        body: {
          "id" => "new-domain",
          "name" => "my-domain",
          "domainType" => "apex",
          "publicSuffix" => "string",
          "redirectForName" => "string",
          "verificationStatus" => "verified",
          "createdAt" => "2022-05-29T09:50:05.354Z",
          "server" => {
            "id" => "server-id",
            "name" => "my-server"
          }
        }
      )
    end

    it "returns the new domain details" do
      response = subject.create(service_id, name: "my-domain")

      expect(response.id).to eq("new-domain")
    end

    it "parses timestamps" do
      expect(
        subject.create(service_id, name: "my-domain").created_at
      ).to eq(
        Time.utc(2022, 5, 29, 9, 50, 5, 354_000)
      )
    end
  end

  describe "delete" do
    let(:id) { "my-domain" }

    before :each do
      stub_request(
        :delete,
        "https://api.render.com/v1/services/#{service_id}/custom-domains/#{id}"
      ).to_return(
        status: 204
      )
    end

    it "returns true if successful" do
      response = subject.delete(service_id, id)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(
        :delete,
        "https://api.render.com/v1/services/#{service_id}/custom-domains/#{id}"
      ).to_return_json(
        status: 404,
        body: {
          "id" => "not-found",
          "message" => "Not Found"
        }
      )

      expect { subject.delete(service_id, id) }
        .to raise_error(RenderAPI::RequestError)
    end
  end

  describe "find" do
    let(:id) { "my-domain" }

    before :each do
      stub_request(
        :get,
        "https://api.render.com/v1/services/#{service_id}/custom-domains/#{id}"
      ).to_return_json(
        body: {
          "id" => id,
          "name" => "my-domain",
          "domainType" => "apex",
          "publicSuffix" => "string",
          "redirectForName" => "string",
          "verificationStatus" => "verified",
          "createdAt" => "2022-05-29T09:50:05.354Z",
          "server" => {
            "id" => "server-id",
            "name" => "my-server"
          }
        }
      )
    end

    it "returns domain data" do
      response = subject.find(service_id, id)

      expect(response.id).to eq(id)
    end
  end

  describe "list" do
    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{service_id}/custom-domains"
      ).to_return_json(
        body: [
          {
            "customDomain" => {
              "id" => "a-domain",
              "name" => "my-domain",
              "domainType" => "apex",
              "publicSuffix" => "string",
              "redirectForName" => "string",
              "verificationStatus" => "verified",
              "createdAt" => "2022-05-29T09:50:05.354Z",
              "server" => {
                "id" => "server-id",
                "name" => "my-server"
              }
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns domain data" do
      response = subject.list(service_id)

      expect(response.length).to eq(1)
      expect(response.first.id).to eq("a-domain")
    end

    it "returns the cursor" do
      expect(subject.list(service_id).first.cursor).to eq("the-cursor")
    end
  end

  describe "verify" do
    let(:id) { "my-domain" }

    before :each do
      stub_request(
        :post,
        "https://api.render.com/v1/services/#{service_id}/custom-domains/#{id}/verify"
      ).to_return(
        status: 202
      )
    end

    it "returns true if successful" do
      response = subject.verify(service_id, id)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(
        :post,
        "https://api.render.com/v1/services/#{service_id}/custom-domains/#{id}/verify"
      ).to_return_json(
        status: 404,
        body: {
          "id" => "not-found",
          "message" => "Not Found"
        }
      )

      expect { subject.verify(service_id, id) }
        .to raise_error(RenderAPI::RequestError)
    end
  end
end
