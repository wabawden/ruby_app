require_relative './error_handler.rb'
require_relative './classes/Log.rb'
require_relative './classes/PageView.rb'

log = Log.new(handle_errors(ARGV))

log.parse(ARGV)

log.print_report

log.additional_data