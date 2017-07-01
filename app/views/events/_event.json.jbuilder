# frozen_string_literal: true

json.(event, :created_at, :type)

json.source do
  src_type = event.source_type.downcase
  json.partial! "#{src_type.tableize}/#{src_type}", src_type.to_sym => event.source
end

json.resource do
  rsrc_type = event.resource_type.downcase
  json.partial! "#{rsrc_type.tableize}/#{rsrc_type}", rsrc_type.to_sym => event.resource
end
