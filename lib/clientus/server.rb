# frozen_string_literal: true

module Clientus
  # Holds server info
  class Server
    attr_reader :tus_version

    def initialize(http_options)
      @operations = http_options['Tus-Extension'].split(',')
      @tus_version = http_options['tus-version']
      raise(Error, 'The server did not provide the tus version.') unless @tus_version
    end

    def raise_if_unsupported(extension)
      ext = extension.to_s
      return if @operations.include?(ext)
      raise(Error, "The server does not support #{ext}")
    end
  end
end
