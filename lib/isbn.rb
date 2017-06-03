module ISBN
  extend self
  
  def ten(isbn)
    raise InvalidISBNError unless isbn.is_a? String
    isbn = isbn.delete("-")
    raise No10DigitISBNAvailable if isbn =~ /^979/
    case isbn.size
    when 10 then isbn = isbn[0..8]
    when 13 then isbn = isbn[/(?:^978|^290)*(.{9})\w/,1]
    else raise Invalid10DigitISBN
    end
    case ck = (11 - (isbn.split(//).zip((2..10).to_a.reverse).inject(0) {|s,n| s += n[0].to_i * n[1]} % 11))
    when 10 then isbn << "X"
    when 11 then isbn << "0"
    else isbn << ck.to_s
    end
  end
  alias :as_ten :ten
  
  def thirteen(isbn)
    raise InvalidISBNError unless isbn.is_a? String
    isbn = isbn.delete("-")
    raise Invalid13DigitISBN unless (isbn.size == 10 || isbn.size == 13)
    isbn = isbn.rjust(13,"978")[/(.+)\w/,1] # adjust to 13 digit isbn and remove check digit
    raise Invalid13DigitISBN unless isbn.size == 12 # after adjustments isbn should be 12 digits
    case ck = (10 - (isbn.split(//).zip([1,3]*6).inject(0) {|s,n| s += n[0].to_i * n[1]} % 10))
    when 10 then isbn << "0"
    else isbn << ck.to_s
    end
  end
  alias :as_thirteen :thirteen
  
  def as_used(isbn)
    case isbn.size
    when 13
      case isbn
      when /^978/ then thirteen("290#{isbn[3..-1]}")
      when /^290/ then isbn
      when /^979/ then thirteen("291#{isbn[3..-1]}")
      when /^291/ then isbn
      end
    when 10 then thirteen("290#{isbn}")
    else raise ISBN::InvalidISBNError
    end
  end
  alias :used :as_used

  def as_new(isbn)
    case isbn.size
    when 13
      case isbn
      when /^978/ then isbn
      when /^290/ then thirteen("978#{isbn[3..-1]}")
      when /^979/ then isbn
      when /^291/ then thirteen("979#{isbn[3..-1]}")
      end
    when 10 then ten(isbn)
    else raise ISBN::InvalidISBNError
    end
  end
  
  alias :unused :as_new

  def valid?(isbn)
    return false unless isbn.is_a?(String)
    isbn = isbn.delete("-")
    case isbn.size
    when 13 then isbn[-1] == thirteen(isbn)[-1]
    when 10 then isbn[-1].upcase == ten(isbn)[-1]
    else false
    end
  end
  
  def from_image(url)
    require "open-uri"
    require "tempfile"
    tmp = Tempfile.new("tmp")
    tmp.write(open(url, "rb:binary").read)
    tmp.close
    isbn = %x{djpeg -pnm #{tmp.path} | gocr -}
    isbn.strip.gsub(" ", "").gsub(/o/i, "0").gsub("_", "2").gsub(/2J$/, "45")
  end
  
  def from_string(source)
    regex = /(?:ISBN[- ]*13|ISBN[- ]*10|)\s*((?:(?:9[\s-]*7[\s-]*[89])?[ -]?(?:[0-9][ -]*){9})[ -]*(?:[0-9xX]))/
    match = source.scan(regex).flatten
    match.map! { |i| i.gsub(/[\s-]+/, "-") }
    match = match.find {|i| ISBN.valid?(i) }
    raise InvalidSourceString unless match
    match
  end

  def with_dashes(isbn)
    s = isbn.gsub("-", "")
    return s.scan(/(...)(.)(....)(....)(.)/).join('-') if s.size == 13
    return s.scan(/(.)(....)(....)(.)/).join('-') if s.size == 10
    raise InvalidSourceString
  end
  
  class InvalidISBNError < RuntimeError; end
  class No10DigitISBNAvailable < RuntimeError; end
  class Invalid10DigitISBN < RuntimeError; end
  class Invalid13DigitISBN < RuntimeError; end
  class InvalidSourceString < RuntimeError; end
end
