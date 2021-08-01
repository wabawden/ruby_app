require_relative '../classes/Log.rb'
require_relative '../classes/PageView.rb'
require_relative '../error_handler.rb'
require 'rspec/autorun'

describe Log do
    it "raises an ArgumentError if no arguments are passed" do
        expect { Log.new(handle_errors([])) }.to raise_error(ArgumentError, "At least one log file must be provided")
    end

    it "raises an error if log file cannot be found" do
        expect { Log.new(handle_errors(['../webserver.log', '../foo.log'])) }.to raise_error(StandardError, "../foo.log does not exist")
    end

    it "raises an error if argument is not a .log file" do
        expect { Log.new(handle_errors(['not_a_log.txt'])) }.to raise_error(StandardError, "not_a_log.txt does not appear to be a valid log file")
    end

    it "raises an error if file contains an invalid route" do
        expect { Log.new(handle_errors(['webserver_invalid_route.log'])) }.to raise_error(StandardError, "file webserver_invalid_route.log contains invalid route about")
    end

    it "raises an error if file contains an invalid IP" do
        expect { Log.new(handle_errors(['webserver_invalid_ip.log'])) }.to raise_error(StandardError, "file webserver_invalid_ip.log contains invalid IPv4 address 646.865.545")
    end
end

log = Log.new(handle_errors(['test_log.log']))
log.parse(['test_log.log'])

describe Log, '#sort_by_views' do
    it "returns a sorted hash of page views" do
        expect(log.sort_by_views()).to eq([["/help_page/1", 3], ["/contact", 1], ["/home", 1], ["/about/2", 1]])
    end
end

describe Log, '#sort_by_unique_views' do
    it "returns a sorted hash of unique page views" do
        expect(log.sort_by_unique_views()).to eq([["/help_page/1", 2], ["/contact", 1], ["/home", 1], ["/about/2", 1]])
    end
end

describe Log, '#sort_by_user' do
    it "returns a sorted hash of users by number of page views" do
        expect(log.sort_by_user()).to eq([["126.318.035.038", 2], ["184.123.665.067", 2], ["444.701.448.104", 1], ["929.398.951.889", 1]])
    end
end

describe Log, '#sort_by_unique_user_views' do
    it "returns a sorted hash of users by number of unique page views" do
        expect(log.sort_by_unique_user_views()).to eq([["184.123.665.067", 2], ["126.318.035.038", 1], ["444.701.448.104", 1], ["929.398.951.889", 1]])
    end
end

describe Log, '#sort_by_entry_views' do
    it "returns a sorted hash of page visits where the page was the first visited by a user" do
        expect(log.sort_by_entry_views()).to eq([["/help_page/1", 2], ["/contact", 1], ["/about/2", 1]])
    end
end

describe Log, '#sort_by_exit_views' do
    it "returns a sorted hash of page visits where the page was the last visited by a user" do
        expect(log.sort_by_exit_views()).to eq([["/help_page/1", 2], ["/about/2", 1], ["/home", 1]]
        )
    end
end