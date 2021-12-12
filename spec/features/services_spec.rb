# frozen_string_literal: true

RSpec.describe "Services" do
  let(:client) { RenderAPI.client "test-api-key" }

  subject { client.services }

  describe "list" do
    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services"
      ).to_return_json(
        body: [
          {
            "service" => {
              "id" => "string",
              "autoDeploy" => "yes",
              "branch" => "string",
              "createdAt" => "2021-12-12T08:02:47.138Z",
              "name" => "my-service",
              "notifyOnFail" => "default",
              "ownerId" => "string",
              "repo" => "string",
              "slug" => "string",
              "suspended" => "suspended",
              "suspenders" => [
                "admin"
              ],
              "type" => "static_site",
              "updatedAt" => "2021-12-12T08:02:47.138Z",
              "serviceDetails" => {
                "buildCommand" => "string",
                "parentServer" => {
                  "id" => "string",
                  "name" => "string"
                },
                "publishPath" => "string",
                "pullRequestPreviewsEnabled" => "yes",
                "url" => "string"
              }
            },
            "cursor" => "string"
          }
        ]
      )
    end

    it "returns service data" do
      response = subject.list

      expect(response.data.length).to eq(1)
      expect(response.data.first["service"]["name"]).to eq("my-service")
    end
  end
end
