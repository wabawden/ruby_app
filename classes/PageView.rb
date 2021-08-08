class PageView
    attr_accessor :page, :ip
    def initialize(page, ip)
        @page = page
        @ip = ip
    end
end