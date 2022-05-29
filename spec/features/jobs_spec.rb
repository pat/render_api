# frozen_string_literal: true

RSpec.describe "Jobs" do
  let(:client) { RenderAPI.client "test-api-key" }
  let(:service_id) { "random-string" }

  subject { client.jobs }

  describe "create" do
    before :each do
      stub_request(
        :post, "https://api.render.com/v1/services/#{service_id}/jobs"
      ).to_return_json(
        body: {
          "id" => "new-job",
          "serviceId" => "my-service",
          "startCommand" => "whoami",
          "planId" => "my-plan",
          "status" => "succeeded",
          "finishedAt" => "2021-12-12T08:34:38.327Z",
          "createdAt" => "2021-12-12T08:34:38.327Z",
          "startedAt" => "2021-12-12T08:34:38.327Z"
        }
      )
    end

    it "sends the provided payload" do
      subject.create(service_id, start_command: "whoami")

      expect(
        a_request(
          :post, "https://api.render.com/v1/services/#{service_id}/jobs"
        ).with_json_body do |json|
          json == { "startCommand" => "whoami" }
        end
      ).to have_been_made
    end

    it "includes the plan id if provided" do
      subject.create(service_id, start_command: "whoami", plan_id: "a-plan")

      expect(
        a_request(
          :post, "https://api.render.com/v1/services/#{service_id}/jobs"
        ).with_json_body do |json|
          json == { "startCommand" => "whoami", "planId" => "a-plan" }
        end
      ).to have_been_made
    end

    it "returns the new job details" do
      response = subject.create(service_id, start_command: "whoami")

      expect(response.id).to eq("new-job")
    end

    it "parses timestamps" do
      expect(
        subject.create(service_id, start_command: "whoami").finished_at
      ).to eq(
        Time.utc(2021, 12, 12, 8, 34, 38, 327_000)
      )
    end
  end

  describe "find" do
    let(:id) { "my-job" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{service_id}/jobs/#{id}"
      ).to_return_json(
        body: {
          "id" => "my-job",
          "serviceId" => "my-service",
          "startCommand" => "whoami",
          "planId" => "my-plan",
          "status" => "succeeded",
          "finishedAt" => "2021-12-12T08:34:38.327Z",
          "createdAt" => "2021-12-12T08:34:38.327Z",
          "startedAt" => "2021-12-12T08:34:38.327Z"
        }
      )
    end

    it "returns job data" do
      response = subject.find(service_id, id)

      expect(response.id).to eq(id)
    end
  end

  describe "list" do
    before :each do
      stub_request(
        :get, "https://api.render.com/v1/services/#{service_id}/jobs"
      ).to_return_json(
        body: [
          {
            "job" => {
              "id" => "my-job",
              "serviceId" => "my-service",
              "startCommand" => "whoami",
              "planId" => "my-plan",
              "status" => "succeeded",
              "finishedAt" => "2021-12-12T08:34:38.327Z",
              "createdAt" => "2021-12-12T08:34:38.327Z",
              "startedAt" => "2021-12-12T08:34:38.327Z"
            },
            "cursor" => "the-cursor"
          }
        ]
      )
    end

    it "returns job data" do
      response = subject.list(service_id)

      expect(response.length).to eq(1)
      expect(response.first.id).to eq("my-job")
    end

    it "returns the cursor" do
      expect(subject.list(service_id).first.cursor).to eq("the-cursor")
    end
  end
end
