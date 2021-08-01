class Log
    def initialize(source, content = [])
        @source = source
        @content = content
    end

    def source
        # retains a list of the source files used
        @source
    end

    def content
        @content
    end

    def parse(params)
        # parses log data and creates PageView instances
        params.each do |log_file|
            logs = File.readlines "./#{log_file}"
            logs.each do |line|
                line_array = line.split(" ")
                page_view = PageView.new(line_array[0], line_array[1])
                self.content.push(page_view)
            end
        end
    end

    def sort_by_views(content = @content)
        # returns a sorted hash of pages by total number of views
        view_count_list = {}
        content.each do |page_view|
            view_count_list[page_view.page]? view_count_list[page_view.page] += 1 : view_count_list[page_view.page] = 1
        end
        return view_count_list.sort_by {|k, v| -v}
    end

    def remove_duplicates(content = @content, memo = [])
        # helper method to filter out duplicate page/user combinations
        unique_content = []
        content.each do |page_view|
            if !(memo.include? [page_view.page, page_view.ip])
                unique_content.push(page_view)
                memo.push([page_view.page, page_view.ip])
            end
        end
        return unique_content
    end

    def sort_by_unique_views
        # returns a sorted hash of pages by number of unique views
        return self.sort_by_views(self.remove_duplicates)
    end

    def print_report
        puts ""
        puts "Page view report for:"
        self.source.each{|source| puts source}
        puts ""
        puts "Pages sorted by view count"
        puts "--------------------------"
        self.sort_by_views.each{|page, views| puts "#{page}: #{views} visits"}
        puts ""
        puts "Pages sorted by unique views"
        puts "--------------------------"
        self.sort_by_unique_views.each{|page, views| puts "#{page}: #{views} unique views"}
    end


    # Extra functionality


    def sort_by_user(content = @content)
        # returns a sorted hash of user by total number of page views
        user_list = {}
        content.each do |page_view|
            user_list[page_view.ip]? user_list[page_view.ip] += 1 : user_list[page_view.ip] = 1
        end
        return user_list.sort_by {|k, v| -v}
    end

    def sort_by_unique_user_views
        # returns a sorted hash of pages by number of unique views
        return self.sort_by_user(self.remove_duplicates)
    end

    def find_entry_pages(content = @content, memo = [])
        # helper method to filter log by first instance of each user
        entry_views = []
        content.each do |page_view|
            if !(memo.include? page_view.ip)
                entry_views.push(page_view)
                memo.push(page_view.ip)
            end
        end
        return entry_views
    end

    def sort_by_entry_views
        # returns a sorted hash of page visits where the page was the first visited by a user
        return self.sort_by_views(self.find_entry_pages)
    end

    def sort_by_exit_views
        # returns a sorted hash of page visits where the page was the last visited by a user
        return self.sort_by_views(self.find_entry_pages(@content.reverse))
    end

    def additional_data
        # displays options for additional data to view
        puts ""
        puts "View Additional Data:"
        puts "1. Users sorted by number of page views"
        puts "2. Users sorted by unique page views"
        puts "3. Entry nodes (pages viewed first by each user)"
        puts "4. Exit nodes (pages viewed last by each user"
        puts "5. Exit"

        response = $stdin.gets.chomp

        case response
        when "1"
            puts ""
            puts "Users sorted by view count"
            puts "--------------------------"
            self.sort_by_user.each{|ip, views| puts "#{ip}: #{views} visits"}
            self.additional_data
        when "2"
            puts ""
            puts "Users sorted by unique page views"
            puts "--------------------------"
            self.sort_by_unique_user_views.each{|ip, views| puts "#{ip}: #{views} unique views"}
            self.additional_data
        when "3"
            puts ""
            puts "Entry nodes"
            puts "--------------------------"
            self.sort_by_entry_views.each{|page, views| puts "#{page}: #{views} users"}
            self.additional_data
        when "4"
            puts ""
            puts "Exit nodes"
            puts "--------------------------"
            self.sort_by_exit_views.each{|page, views| puts "#{page}: #{views} users"}
            self.additional_data
        when "5"
            exit
        else self.additional_data
        end
    end

end