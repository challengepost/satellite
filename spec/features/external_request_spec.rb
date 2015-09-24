require "spec_helper"

feature "External request" do
  it "queries challenges on ChallengePost" do
    stub_request(:get, /api.devpost.com/).
      with(headers: {"Accept"=>"*/*", "User-Agent"=>"Ruby"}).
      to_return(status: 200, body: "stubbed response", headers: {})

    uri = URI("https://api.devpost.com/challenges")

    response = Net::HTTP.get(uri)

    expect(response).to eq "stubbed response"
  end
end
