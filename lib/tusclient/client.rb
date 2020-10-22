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
      data = File.open(file_path, 'rb', &:read)
      size = File.size(file_path)
      name = File.basename(file_path)
      UploadFile.new(name, size, data)
    end

    def create_file(file, additional_headers)
      # TODO: refactor this
      request = Net::HTTP::Post.new(@server_uri.request_uri)

      request['Content-Length'] = 0
      request['Upload-Length'] = file.size
      request['Tus-Resumable'] = @server.tus_version

      request['Cookie'] = additional_headers['Cookie']&.map { |k, v| "#{k}=#{v}"}.join(';')

      request['Upload-Metadata'] = "filename #{file.encoded_name}"
      additional_headers['Upload-Metadata']&.each do |k, v|
        request['Upload-Metadata'] = [request['Upload-Metadata'], "#{k} #{v}"].join(',')
      end

      res = @http.request(request)
      puts res['Location']
      return if res.is_a?(Net::HTTPCreated)

      raise(Error, "bad resonse type: #{res.class}; body: #{res.body}")
    end
  end
end
