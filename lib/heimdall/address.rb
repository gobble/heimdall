module Heimdall
  class Address
    include Comparable

    attr_accessor :line1, :line2, :city, :state, :zip_code, :country,
                  :commercial

    def initialize(line1:, line2: "", city:, state:,
                   zip_code:, country: "USA", commercial: false)
      @line1 = line1
      @line2 = line2
      @city = city
      @state = state
      @zip_code = zip_code
      @country = country
      @commercial = commercial
    end

    def <=>(an_other)
      for_comparison <=> an_other.for_comparison
    end

    def for_comparison
      [line1, zip_code].compact.join(", ")
    end

    def to_s
      "#{line1}, #{line2}, #{city}, #{state} #{zip_code}"
    end
  end
end
