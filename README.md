isbn
====

Version 2.0


This library provides methods to manipulate isbns. As of version 2.0 there has been a near complete rewrite of this library but this time there are tests. A few methods have been removed. Here is what remains:

* `ISBN.ten` will return a 10 digit isbn if you give it a 10 or 13 digit isbn
 - it will raise a `No10DigitISBNAvailable` error if given an isbn starting with 979
   because 979 isbns do NOT have a 10 digit counterpart.
* `ISBN.thirteen` will return a 13 digit isbn if you give it 10 or thirteen digit isbn

* `ISBN.as_new` will convert an isbn into the used book version for that isbn
 - for isbns starting with 978 it returns an isbn starting with 290
 - for isbns starting with 979 it returns an isbn starting with 291

* `ISBN.as_used` will convert an isbn into the new book version for that isbn
 - for isbns starting with 290 it returns an isbn starting with 978
 - for isbns starting with 291 it returns an isbn starting with 979

* `ISBN.valid?` will compare the check digit of the passed in isbn with that of one it computes

* `ISBN.from_image` accept a jpeg of an isbn and OCR it into an isbn.
 - it depends on the LibJpeg and Gocr libraries. I recommend [Homebrew](http://github.com/mxcl/homebrew).
 
* `ISBN.from_string` fetches isbn from string
