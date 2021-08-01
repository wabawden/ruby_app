# error handling

def handle_errors(params)
    # check that arguments have been provided
    if params.length < 1 
        raise ArgumentError, 'At least one log file must be provided'
    end
    
    params.each do |log_file|
        # check file exists
        if !File.file?("./#{log_file}")
            raise StandardError, "#{log_file} does not exist"
        # check file extension
        elsif !log_file.match(/^.*\.(log|LOG)$/)
            raise StandardError, "#{log_file} does not appear to be a valid log file"
        else logs = File.readlines "./#{log_file}"
            logs.each do |line|
                line_array = line.split(" ")
                # check that log file contains valid routes
                if !line_array[0].match(/^\/.*/)
                    raise StandardError, "file #{log_file} contains invalid route #{line_array[0]}"
                # check that log file contains valid IP addresses
                elsif !line_array[1].match(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/)
                    raise StandardError, "file #{log_file} contains invalid IPv4 address #{line_array[1]}"
                end
            end
        end
    end
    return params
end