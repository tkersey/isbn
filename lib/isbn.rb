module ISBN
  extend self
  
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
    case check_digit = (mod - (isbn.chars.zip(weight).inject(0) {|s,i| s += i[0].to_i * i[1]} % mod))
    when 10 then  isbn << check
    when 11 then  isbn << '0'
    else          isbn << check_digit.to_s
    end
    isbn
	end
	
  def from_13_to_10(isbn)
    isbn = isbn.delete("-")
    raise "NOT 13 Digit ISBN" if isbn.size != 13
    calculate(isbn[/\d{3}(\d{9})(?:\d|X)/i, 1])
  end

  def from_10_to_13(isbn, used=false)
    isbn = isbn.delete("-")
    raise "NOT 10 Digit ISBN" if isbn.size != 10
    calculate("#{used ? '290' : '978'}#{isbn}")	   
  end
  
  def between_new_and_used(isbn)
    case isbn[0..2]
    when '978' then calculate(isbn.sub(/^978/, "290"))
    when '290' then calculate(isbn.sub(/^290/, "978"))
    end
  end

  def thirteen(isbn)
    case isbn.size
    when 13 then isbn
    when 10 then from_10_to_13(isbn)
    else raise InvalidISBNError
    end
  end

  def valid?(isbn)
    begin
      isbn[-1,1] == calculate(isbn)[-1,1]
    rescue InvalidISBNError => isbn_error
      false
    end
  end
  
  class InvalidISBNError < RuntimeError
  end
end