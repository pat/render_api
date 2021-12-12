# frozen_string_literal: true

RSpec.describe "Services" do
  let(:client) { RenderAPI.client "test-api-key" }

  subject { client.services }

  describe "find" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{id}"
      ).to_return_json(
        body: {
          "id" => "string",
          "autoDeploy" => "yes",
          "branch" => "string",
          "createdAt" => "2021-12-12T08:02:47.138Z",
          "name" => "my-service-name",
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
            "buildCommand" => "my-command",
            "parentServer" => {
              "id" => "string",
              "name" => "string"
            },
            "publishPath" => "string",
            "pullRequestPreviewsEnabled" => "yes",
            "url" => "string"
          }
        }
      )
    end

    it "returns service data" do
      response = subject.find(id)

      expect(response.name).to eq("my-service-name")
      expect(response.service_details.build_command).to eq("my-command")
    end
  end

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

      expect(response.length).to eq(1)
      expect(response.first.name).to eq("my-service")
    end
  end
end
