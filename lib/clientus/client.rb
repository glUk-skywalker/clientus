# frozen_string_literal: true

module Clientus
  # Client that transfers files. The main class.
  class Client
    CHUNK_SIZE = 100 * 1024 * 1024 # 100MB

    def initialize(url, http_params: {})
      @server_uri = URI.parse url
      @http = Net::HTTP.start(@server_uri.host, @server_uri.port, http_params)

      server_options = @http.options(@server_uri.request_uri)
      @server = Server.new(server_options)
    end

    def upload(file_path, additional_headers: {})
      @server.supports_create? || raise(Error, 'the server does not support file creation')

      file = read_file(file_path)

      location = create_file(file, additional_headers: additional_headers)

      start_offset = 0
      loop do
        end_offset = start_offset + CHUNK_SIZE
        chunk_data = file.data[start_offset..end_offset]

        upload_chunk(location, start_offset, chunk_data, additional_headers: additional_headers)
        break if end_offset >= file.size

        start_offset = end_offset + 1
      end
    end

    private

    def read_file(file_path)
      data = File.open(file_path, 'rb', &:read)
      size = File.size(file_path)
      name = File.basename(file_path)
      UploadFile.new(name, size, data)
    end

    def create_file(file, additional_headers: {})
      # TODO: refactor this
      request = Net::HTTP::Post.new(@server_uri.request_uri)

      request['Content-Length'] = 0
      request['Upload-Length'] = file.size
      request['Tus-Resumable'] = @server.tus_version
      request['Upload-Metadata'] = "filename #{file.encoded_name}"
      Clientus.adjust_headers(request, additional_headers)

      res = @http.request(request)
      return res['Location'] if res.is_a?(Net::HTTPCreated)

      raise(Error, "failed to create remote file: bad resonse type: #{res.class}; body: #{res.body}")
    end

    def upload_chunk(uri, offset, chunk, additional_headers: {})
      request = Net::HTTP::Patch.new(uri)
      request['Content-Type'] = 'application/offset+octet-stream'
      request['Upload-Offset'] = offset
      request['Tus-Resumable'] = @server.tus_version
      request.body = chunk
      Clientus.adjust_headers(request, additional_headers)

      @http.request(request)
    end
  end
end