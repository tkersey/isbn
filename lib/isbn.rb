module ISBN
  extend self
  
  def ten(isbn)
    isbn = isbn.delete("-")
    raise No10DigitISBNAvailable if isbn =~ /^979/
    isbn = isbn[/(?:978|290)*(.+)\w/,1] # remove 978, 979 or 290 and check digit
    raise Invalid10DigitISBN unless isbn.size == 9 # after removals isbn should be 9 digits
    case ck = (11 - (isbn.split(//).zip((2..10).to_a.reverse).inject(0) {|s,n| s += n[0].to_i * n[1]} % 11))
    when 10 then isbn << "X"
    when 11 then isbn << "0"
    else isbn << ck.to_s
    end
  end
  
  def thirteen(isbn)
    isbn = isbn.delete("-")
    isbn = isbn.rjust(13,"978")[/(.+)\w/,1] # adjust to 13 digit isbn and remove check digit
    raise Invalid13DigitISBN unless isbn.size == 12 # after adjustments isbn should be 12 digits
    case ck = (10 - (isbn.split(//).zip([1,3]*6).inject(0) {|s,n| s += n[0].to_i * n[1]} % 10))
    when 10 then isbn << "0"
    else isbn << ck.to_s
    end
  end

  def between_new_and_used(isbn)
    case isbn[0..2]
    when '978' then calculate(isbn.sub(/^978/, "290"))
    when '290' then calculate(isbn.sub(/^290/, "978"))
    end
  end

  def valid?(isbn)
    begin
      isbn[-1,1] == calculate(isbn)[-1,1]
    rescue InvalidISBNError => isbn_error
      false
    end
  end
  
  def book?(isbn)
    begin
      true if (isbn =~ /^(978|290)/i && ten(isbn)) || ten(isbn)
    rescue InvalidISBNError => isbn_error
      false
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
  
  class InvalidISBNError < RuntimeError
  end
  
  private
  def calculate(isbn)
	  isbn = isbn.delete("-")
    isbn = isbn[0...-1] unless (isbn.size == 9 || isbn.size == 12)
    case isbn.size
    when 9
      weight  = (2..10).to_a.reverse
      mod     = 11
      check   = 'X'
    when 12
      weight  = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3]
      mod     = 10
      check   = '0'
    else
      raise InvalidISBNError
    end
    case check_digit = (mod - (isbn.split(//).zip(weight).inject(0) {|s,i| s += i[0].to_i * i[1]} % mod))
    when 10 then  isbn << check
    when 11 then  isbn << '0'
    else          isbn << check_digit.to_s
    end
    isbn
	end
end