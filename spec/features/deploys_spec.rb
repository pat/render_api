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

    it "sends no payload by default" do
      subject.create(service_id)

      expect(
        a_request(
          :post, "https://api.render.com/v1/services/#{service_id}/deploys"
        ).with { |request| request.body == "" }
      ).to have_been_made
    end

    it "sends a payload if clearing the cache" do
      subject.create(service_id, clear_cache: "clear")

      expect(
        a_request(
          :post, "https://api.render.com/v1/services/#{service_id}/deploys"
        ).with_json_body do |json|
          json == { "clearCache" => "clear" }
        end
      ).to have_been_made
    end

    it "returns the new deploy details" do
      response = subject.create(service_id)

      expect(response.id).to eq("new-deploy")
    end

    it "parses timestamps" do
      expect(subject.create(service_id).finished_at).to eq(
        Time.utc(2021, 12, 12, 8, 34, 38, 327_000)
      )
    end
  end

  describe "find" do
    let(:id) { "my-deploy" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{service_id}/deploys/#{id}"
      ).to_return_json(
        body: {
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
        }
      )
    end

    it "returns deploy data" do
      response = subject.find(service_id, id)

      expect(response.id).to eq(id)
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
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns deploy data" do
      response = subject.list(service_id)

      expect(response.length).to eq(1)
      expect(response.first.id).to eq("my-deploy")
    end

    it "returns the cursor" do
      expect(subject.list(service_id).first.cursor).to eq("the-cursor")
    end
  end
end
