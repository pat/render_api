# frozen_string_literal: true

RSpec.describe "Services" do
  let(:client) { RenderAPI.client "test-api-key" }

  subject { client.services }

  describe "create" do
    before :each do
      stub_request(
        :post, "https://api.render.com/v1/services"
      ).to_return_json(
        body: {
          "service" => {
            "id" => "new-service",
            "autoDeploy" => "yes",
            "branch" => "string",
            "createdAt" => "2022-05-29T09:50:05.354Z",
            "name" => "my-service",
            "notifyOnFail" => "default",
            "ownerId" => "string",
            "repo" => "https://github.com/render-examples/flask-hello-world",
            "slug" => "string",
            "suspended" => "suspended",
            "suspenders" => [
              "admin"
            ],
            "type" => "static_site",
            "updatedAt" => "2022-05-29T09:50:05.354Z",
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
          "deployId" => "the-deploy"
        }
      )
    end

    it "sends the provided payload" do
      subject.create(
        type: "web_service",
        name: "my-service",
        owner_id: "my-owner-id",
        repo: "https://github.com/render-examples/flash-hello-world"
      )

      expect(
        a_request(:post, "https://api.render.com/v1/services")
          .with_json_body do |json|
            json == {
              "type" => "web_service",
              "name" => "my-service",
              "ownerId" => "my-owner-id",
              "repo" => "https://github.com/render-examples/flash-hello-world"
            }
          end
      ).to have_been_made
    end

    it "returns the new service and deploy details" do
      response = subject.create(
        type: "web_service",
        name: "my-service",
        owner_id: "my-owner-id",
        repo: "https://github.com/render-examples/flash-hello-world"
      )

      expect(response.service.id).to eq("new-service")
      expect(response.deploy_id).to eq("the-deploy")
    end

    it "parses timestamps" do
      response = subject.create(
        type: "web_service",
        name: "my-service",
        owner_id: "my-owner-id",
        repo: "https://github.com/render-examples/flash-hello-world"
      )

      expect(response.service.created_at)
        .to eq(Time.utc(2022, 5, 29, 9, 50, 5, 354_000))
    end
  end

  describe "delete" do
    let(:id) { "my-service" }

    before :each do
      stub_request(:delete, "https://api.render.com/v1/services/#{id}")
        .to_return(status: 204)
    end

    it "returns true if successful" do
      response = subject.delete(id)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(:delete, "https://api.render.com/v1/services/#{id}")
        .to_return_json(
          status: 404,
          body: {
            "id" => "not-found",
            "message" => "Not Found"
          }
        )

      expect { subject.delete(id) }.to raise_error(RenderAPI::RequestError)
    end
  end

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
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns service data" do
      response = subject.list

      expect(response.length).to eq(1)
      expect(response.first.name).to eq("my-service")
    end

    it "returns the cursor" do
      expect(subject.list.first.cursor).to eq("the-cursor")
    end
  end

  describe "list_headers" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{id}/headers"
      ).to_return_json(
        body: [
          {
            "headers" => {
              "path" => "my-path",
              "name" => "my-name",
              "value" => "my-value"
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns the header data" do
      response = subject.list_headers(id)

      expect(response.first.name).to eq("my-name")
      expect(response.first.value).to eq("my-value")
    end

    it "returns the cursor" do
      expect(subject.list_headers(id).first.cursor).to eq("the-cursor")
    end
  end

  describe "list_routes" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{id}/routes"
      ).to_return_json(
        body: [
          {
            "routes" => {
              "type" => "redirect",
              "source" => "my-source",
              "destination" => "my-destination"
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns the route data" do
      response = subject.list_routes(id)

      expect(response.first.type).to eq("redirect")
      expect(response.first.source).to eq("my-source")
    end

    it "returns the cursor" do
      expect(subject.list_routes(id).first.cursor).to eq("the-cursor")
    end
  end

  describe "list_variables" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{id}/env-vars"
      ).to_return_json(
        body: [
          {
            "envVar" => {
              "key" => "env-key",
              "value" => "env-val"
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns the variable data" do
      response = subject.list_variables(id)

      expect(response.first.key).to eq("env-key")
      expect(response.first.value).to eq("env-val")
    end

    it "returns the cursor" do
      expect(subject.list_variables(id).first.cursor).to eq("the-cursor")
    end
  end

  describe "resume" do
    let(:id) { "my-service" }

    before :each do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/resume")
        .to_return(status: 202)
    end

    it "returns true if successful" do
      response = subject.resume(id)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/resume")
        .to_return_json(
          status: 404,
          body: {
            "id" => "not-found",
            "message" => "Not Found"
          }
        )

      expect { subject.resume(id) }
        .to raise_error(RenderAPI::RequestError)
    end
  end

  describe "scale" do
    let(:id) { "my-service" }

    before :each do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/scale")
        .to_return(status: 202)
    end

    it "sends the provided payload" do
      subject.scale(id, num_instances: 3)

      expect(
        a_request(:post, "https://api.render.com/v1/services/#{id}/scale")
          .with_json_body do |json|
            json == { "numInstances" => 3 }
          end
      ).to have_been_made
    end

    it "returns true if successful" do
      response = subject.scale(id, num_instances: 3)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/scale")
        .to_return_json(
          status: 404,
          body: {
            "id" => "not-found",
            "message" => "Not Found"
          }
        )

      expect { subject.scale(id, num_instances: 3) }
        .to raise_error(RenderAPI::RequestError)
    end
  end

  describe "suspend" do
    let(:id) { "my-service" }

    before :each do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/suspend")
        .to_return(status: 202)
    end

    it "returns true if successful" do
      response = subject.suspend(id)

      expect(response).to eq(true)
    end

    it "raises an exception if the request failed" do
      stub_request(:post, "https://api.render.com/v1/services/#{id}/suspend")
        .to_return_json(
          status: 404,
          body: {
            "id" => "not-found",
            "message" => "Not Found"
          }
        )

      expect { subject.suspend(id) }
        .to raise_error(RenderAPI::RequestError)
    end
  end

  describe "update" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :patch, "https://api.render.com/v1/services/#{id}"
      ).to_return_json(
        body: {
          "id" => id,
          "autoDeploy" => "yes",
          "branch" => "string",
          "createdAt" => "2022-05-29T09:50:05.354Z",
          "name" => "my-service",
          "notifyOnFail" => "default",
          "ownerId" => "string",
          "repo" => "https://github.com/render-examples/flask-hello-world",
          "slug" => "string",
          "suspended" => "suspended",
          "suspenders" => [
            "admin"
          ],
          "type" => "static_site",
          "updatedAt" => "2022-05-29T09:50:05.354Z",
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
        }
      )
    end

    it "sends the provided payload" do
      subject.update(id, name: "edited-service")

      expect(
        a_request(:patch, "https://api.render.com/v1/services/#{id}")
          .with_json_body do |json|
            json == { "name" => "edited-service" }
          end
      ).to have_been_made
    end

    it "returns the update service" do
      response = subject.update(id, name: "edited-service")

      expect(response.name).to eq("my-service")
    end

    it "parses timestamps" do
      response = subject.update(id, name: "edited-service")

      expect(response.updated_at)
        .to eq(Time.utc(2022, 5, 29, 9, 50, 5, 354_000))
    end
  end

  describe "update_variables" do
    let(:id) { "my-service" }

    before :each do
      stub_request(
        :put, "https://api.render.com/v1/services/#{id}/env-vars"
      ).to_return_json(
        body: [
          {
            "envVar" => {
              "key" => "env-key",
              "value" => "env-val"
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "sends the provided payload" do
      subject.update_variables(
        id,
        [
          { key: "foo", value: "test" },
          { key: "bar", generate_value: "yes" }
        ]
      )

      expect(
        a_request(:put, "https://api.render.com/v1/services/#{id}/env-vars")
          .with_json_body do |json|
            json == [
              { "key" => "foo", "value" => "test" },
              { "key" => "bar", "generateValue" => "yes" }
            ]
          end
      ).to have_been_made
    end

    it "returns the variable data" do
      response = subject.update_variables(
        id,
        [
          { key: "foo", value: "test" },
          { key: "bar", generate_value: "yes" }
        ]
      )

      expect(response.first.key).to eq("env-key")
      expect(response.first.value).to eq("env-val")
    end

    it "returns the cursor" do
      response = subject.update_variables(
        id,
        [
          { key: "foo", value: "test" },
          { key: "bar", generate_value: "yes" }
        ]
      )

      expect(response.first.cursor).to eq("the-cursor")
    end
  end
end
