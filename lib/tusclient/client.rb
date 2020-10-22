# frozen_string_literal: true

module Tusclient
  # Client that transfers files. The main class.
  class Client
    def initialize(url, http_params: {})
      @server_uri = URI.parse url
      @http = Net::HTTP.start(@server_uri.host, @server_uri.port, http_params)

      server_options = @http.options(@server_uri.request_uri)
      @server = Server.new(server_options)
    end

    def upload(file_path)
      @server.supports_create? || raise(Error, 'the server does not support file creation')
    end

    private

    def read_file(file_path)
      File.open(file_path, 'rb', &:read)
    end
  end
end
