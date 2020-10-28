# frozen_string_literal: true

module Clientus
  # Client that transfers files. The main class.
  class Client
    CHUNK_SIZE = 100 * 1024 * 1024 # 100MB

    def initialize(url, http_params: {}, additional_headers: {})
      @server_uri = URI.parse url
      @http = Net::HTTP.start(@server_uri.host, @server_uri.port, http_params)
      @additional_headers = additional_headers

      server_options = @http.options(@server_uri.request_uri)
      @server = Server.new(server_options)
    end

    def upload(file_path)
      # checking here instead of checking in 'create!' to avoid wasting time
      # for needless file reading
      @server.raise_if_unsupported(:creation)

      file = read_file(file_path)

      location = create!(file)

      start_offset = 0
      loop do
        end_offset = start_offset + CHUNK_SIZE
        chunk_data = file.data[start_offset..end_offset]

        upload_chunk(location, start_offset, chunk_data)
        break if end_offset >= file.size

        start_offset = end_offset + 1
      end
      terminate!(location)
    end

    private

    def read_file(file_path)
      data = File.open(file_path, 'rb', &:read)
      size = File.size(file_path)
      name = File.basename(file_path)
      UploadFile.new(name, size, data)
    end

    def create!(file)
      # TODO: refactor this
      request = default_request(:post, @server_uri.request_uri)
      request['Content-Length'] = 0
      request['Upload-Length'] = file.size
      request['Upload-Metadata'] ||= "filename #{file.encoded_name}"
      unless request['Upload-Metadata'].include?('filename ')
        request['Upload-Metadata'] += ",filename #{file.encoded_name}"
      end

      res = @http.request(request)
      return res['Location'] if res.is_a?(Net::HTTPCreated)

      raise(Error, "failed to create remote file: bad resonse type: #{res.class}; body: #{res.body}")
    end

    def upload_chunk(uri, offset, chunk)
      request = default_request(:patch, uri)
      request['Content-Type'] = 'application/offset+octet-stream'
      request['Upload-Offset'] = offset
      request.body = chunk
      @http.request(request)
    end

    def terminate!(uri)
      @server.raise_if_unsupported(:termination)
      request = default_request(:delete, uri)
      @http.request(request)
    end

    def default_request(method, uri)
      request_class = Object.const_get "Net::HTTP::#{method.to_s.capitalize}"
      request = request_class.new(uri)
      @additional_headers.each { |k, v| request[k] = v }
      request['Tus-Resumable'] = @server.tus_version
      request
    end
  end
end
