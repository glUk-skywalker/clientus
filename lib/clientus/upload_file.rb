# frozen_string_literal: true

module Clientus
  # Holds file information
  class UploadFile
    attr_reader :name, :size, :data

    def initialize(name, size, data)
      @name = name
      @data = data
      @size = size
    end

    def encoded_name
      # TODO: investigate why we need to exclude CR/LF in the end of encoded string
      Base64.encode64(@name)[0..-2]
    end
  end
end
