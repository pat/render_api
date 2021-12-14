# frozen_string_literal: true

RSpec.describe "Owners" do
  let(:client) { RenderAPI.client "test-api-key" }

  subject { client.owners }

  describe "find" do
    let(:id) { "my-id" }

    before :each do
      stub_request(
        :get, "https://api.render.com/v1/owners/#{id}"
      ).to_return_json(
        body: {
          "id" => id,
          "name" => "Pat Allan",
          "email" => "string",
          "type" => "user"
        }
      )
    end

    it "returns the owner" do
      expect(subject.find(id).name).to eq("Pat Allan")
    end
  end

  describe "list" do
    before :each do
      stub_request(
        :get, "https://api.render.com/v1/owners"
      ).to_return_json(
        body: [
          {
            "owner" => {
              "id" => "me",
              "name" => "string",
              "email" => "string",
              "type" => "user"
            },
            "cursor" => "string"
          }
        ]
      )
    end

    it "returns owner data" do
      response = subject.list

      expect(response.length).to eq(1)
      expect(response.first.id).to eq("me")
    end
  end
end
