# frozen_string_literal: true

module Tusclient
  # Holds server info
  class Server
    attr_reader :tus_version

    def initialize(http_options)
      @operations = http_options['Tus-Extension'].split(',')
      @tus_version = http_options['tus-version']
      raise(Error, 'The server did not provide the tus version.') unless @tus_version
    end

    def supports_create?
      @operations.include?('creation')
    end
  end
end
