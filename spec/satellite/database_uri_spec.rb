require "spec_helper"

describe Satellite::DatabaseURI do
  def connection_hash(options = {})
    options.reverse_merge({ adapter: "postgresql",
                            username: "user",
                            password: "secret",
                            host: "localhost",
                            database: "mydatabase" })
  end

  it 'returns uri with database attributes' do
    url = "mysql2://user:secret@localhost/mydatabase"
    uri = Satellite::DatabaseURI.parse(url)
    expect(uri.adapter).to eq("mysql2")
    expect(uri.username).to eq("user")
    expect(uri.password).to eq("secret")
    expect(uri.host).to eq("localhost")
    expect(uri.database).to eq("mydatabase")
  end

  it 'returns hash of database-connection-friendly attributes' do
    url = "mysql2://user:secret@localhost/mydatabase"
    uri = Satellite::DatabaseURI.parse(url)
    connection = uri.to_hash

    expect(connection[:adapter]).to eq("mysql2")
    expect(connection[:username]).to eq("user")
    expect(connection[:password]).to eq("secret")
    expect(connection[:host]).to eq("localhost")
    expect(connection[:database]).to eq("mydatabase")
  end

  it "translates postgres" do
    url  = "postgres://user:secret@localhost/mydatabase"
    uri = Satellite::DatabaseURI.parse(url)
    expect(uri.adapter).to eq("postgresql")
  end

  it "supports additional options" do
    url  = "postgresql://user:secret@remotehost.example.org:3133/mydatabase?encoding=utf8&random_key=blah"
    uri = Satellite::DatabaseURI.parse(url)
    connection = uri.to_hash
    expect(connection[:encoding]).to eq("utf8")
    expect(connection[:random_key]).to eq("blah")
    expect(connection[:port]).to eq(3133)
  end

  it "drops empty values" do
    url  = "postgresql://localhost/mydatabase"
    uri = Satellite::DatabaseURI.parse(url)
    connection = uri.to_hash
    expect(connection.slice(:user, :password, :port)).to be_empty
  end
end
