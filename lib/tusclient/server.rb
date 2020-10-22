# frozen_string_literal: true

module Tusclient
  # Holds server info
  class Server
    def initialize(http_options)
      @operations = http_options['Tus-Extension'].split(',')
      puts @operations
    end

    def supports_create?
      @operations.include?('creation')
    end
  end
end
