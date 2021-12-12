# frozen_string_literal: true

RSpec.describe "Deploys" do
  let(:client) { RenderAPI.client "test-api-key" }
  let(:service_id) { "random-string" }

  subject { client.deploys }

  describe "create" do
    before :each do
      stub_request(
        :post, "https://api.render.com/v1/services/#{service_id}/deploys"
      ).to_return_json(
        body: {
          "id" => "new-deploy",
          "commit" => {
            "id" => "string",
            "message" => "string",
            "createdAt" => "2021-12-12T08:34:38.327Z"
          },
          "status" => "created",
          "finishedAt" => "2021-12-12T08:34:38.327Z",
          "createdAt" => "2021-12-12T08:34:38.327Z",
          "updatedAt" => "2021-12-12T08:34:38.327Z"
        }
      )
    end

    it "returns the new deploy details" do
      response = subject.create(service_id)

      expect(response.data["id"]).to eq("new-deploy")
    end
  end

  describe "list" do
    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{service_id}/deploys"
      ).to_return_json(
        body: [
          {
            "deploy" => {
              "id" => "my-deploy",
              "commit" => {
                "id" => "string",
                "message" => "string",
                "createdAt" => "2021-12-12T08:31:33.669Z"
              },
              "status" => "created",
              "finishedAt" => "2021-12-12T08:31:33.670Z",
              "createdAt" => "2021-12-12T08:31:33.670Z",
              "updatedAt" => "2021-12-12T08:31:33.670Z"
            },
            "cursor" => "string"
          }
        ]
      )
    end

    it "returns deploy data" do
      response = subject.list(service_id)

      expect(response.data.length).to eq(1)
      expect(response.data.first["deploy"]["id"]).to eq("my-deploy")
    end
  end
end
