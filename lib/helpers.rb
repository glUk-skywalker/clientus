# frozen_string_literal: true

# The main module
module Clientus
  def self.adjust_headers(request, additional_headers)
    request['Cookie'] = additional_headers['Cookie']&.map { |k, v| "#{k}=#{v}"}.join(';')
    additional_headers['Upload-Metadata']&.each do |k, v|
      request['Upload-Metadata'] = [request['Upload-Metadata'], "#{k} #{v}"].join(',')
    end
  end
end
