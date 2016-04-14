require "minitest/spec"
require_relative "../lib/isbn"

MiniTest::Unit.autorun

describe ISBN do
  ISBNS = [ ["0820472670","9780820472676"], ["0763740381","9780763740382"], ["0547168292","9780547168296"],
            ["0415990793","9780415990790"], ["1596670274","9781596670273"], ["0618800565","9780618800568"],
            ["0812971256","9780812971255"], ["0465032117","9780465032112"], ["0721606318","9780721606316"],
            ["0887273939","9780887273933"], ["012781910X","9780127819105"], ["0736061819","9780736061810"],
            ["0763748951","9780763748951"], ["0470196181","9780470196182"], ["0736064036","9780736064033"],
            ["0743488040","9780743488044"], ["0470130733","9780470130735"], ["0816516502","9780816516506"],
            ["074324382X","9780743243827"], ["0887401392","9780887401398"], ["0582404800","9780582404809"],
            ["2906571385","9782906571389"]]
            
  ISBN13DASH = [ ["978-1-934356-47-0", "9781934356470"], ["0-13-532762-8","9780135327623"]]
  
  it "should respond with a ten digit isbn" do
    ISBNS.each do |isbn|
      ISBN.ten(isbn[1]).must_equal isbn[0]
      ISBN.ten(isbn[0]).must_equal isbn[0]
    end
    proc { ISBN.ten("9790879392788") }.must_raise ISBN::No10DigitISBNAvailable
    proc { ISBN.ten("074324382") }.must_raise ISBN::Invalid10DigitISBN
    proc { ISBN.ten("") }.must_raise ISBN::Invalid10DigitISBN
    proc { ISBN.ten(nil) }.must_raise ISBN::InvalidISBNError
  end

  it "should respond with a thirteen digit isbn" do
    ISBNS.each do |isbn|
      ISBN.thirteen(isbn[0]).must_equal isbn[1]
      ISBN.thirteen(isbn[1]).must_equal isbn[1]
    end
    proc { ISBN.thirteen("97908793927888") }.must_raise ISBN::Invalid13DigitISBN
    proc { ISBN.thirteen(nil) }.must_raise ISBN::InvalidISBNError
    proc { ISBN.thirteen("") }.must_raise ISBN::Invalid13DigitISBN

    ISBN13DASH.each do |isbn|
      ISBN.thirteen(isbn[0]).must_equal isbn[1]
    end
    proc { ISBN.thirteen("1978-1-934356-47-0") }.must_raise ISBN::Invalid13DigitISBN
    proc { ISBN.thirteen("978-1-934356-47") }.must_raise ISBN::Invalid13DigitISBN

  end
  
  it "should convert a NEW isbn into USED" do
    ISBN.as_used("9780820472676").must_equal "2900820472675"
    ISBN.as_used("2900820472675").must_equal "2900820472675"
    ISBN.as_used("9790879392788").must_equal "2910879392787"
    ISBN.as_used("2910879392787").must_equal "2910879392787"
    ISBN.as_used("0820472670").must_equal "2900820472675"
    proc { ISBN.as_used("082047267") }.must_raise ISBN::InvalidISBNError
  end
  
  it "should convert a USED isbn into NEW" do
    ISBN.as_new("2900820472675").must_equal "9780820472676"
    ISBN.as_new("2910879392787").must_equal "9790879392788"
    ISBN.as_new("9780820472676").must_equal "9780820472676"
    ISBN.as_new("9790879392788").must_equal "9790879392788"
    ISBN.as_new("0820472670").must_equal "0820472670"
    proc { ISBN.as_new("082047267") }.must_raise ISBN::InvalidISBNError
  end
  
  it "should test the validity of an isbn" do
    ISBN.valid?("9780763740382").must_equal true
    ISBN.valid?("9790879392788").must_equal true
    ISBN.valid?("2900820472675").must_equal true
    ISBN.valid?("012781910X").must_equal true
    ISBN.valid?("9887401392").must_equal false
    ISBN.valid?("082047267").must_equal false
    ISBN.valid?("3-540-49698-X").must_equal true
    ISBN.valid?("3-540-49698-x").must_equal true
    ISBN.valid?(nil).must_equal false
  end
  
  it "should get isbn from source string" do
    ISBN.from_string("ISBN:9-7883-7659-303-6\nmore of content").must_equal "9-7883-7659-303-6"
    ISBN.from_string("ISBN:97-908-7939-278-8\nmore of content").must_equal "97-908-7939-278-8"
    ISBN.from_string("ISBN:978-83-7659-303-6\nmore of content").must_equal "978-83-7659-303-6"
    ISBN.from_string("ISBN-13 978-3-540-49698-4 and more content").must_equal "978-3-540-49698-4"
    ISBN.from_string("ISBN-10 3-921099-34-X and more content").must_equal "3-921099-34-X"
    ISBN.from_string("ISBN-10 3-921099-34- x and more content").must_equal "3-921099-34-x"
  end

  it "should add dashes to isbn 13 without dashes" do
    ISBN.with_dashes("9780763740382").must_equal "978-0-7637-4038-2"
  end

  it "should add dashes to isbn 10 without dashes" do
    ISBN.with_dashes("0763740382").must_equal "0-7637-4038-2"
  end
end
