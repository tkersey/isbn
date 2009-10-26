require File.dirname(__FILE__) + '/test_helper'

class IsbnTest < Test::Unit::TestCase

  context "given an ISBN 13" do

    setup do
      @isbn = "9780060976255"
    end

    should "handle ISBN 13" do
      assert_equal "9780060976255", ISBN.thirteen(@isbn)
    end

    should "handle ISBN 10" do
      assert_equal "006097625X", ISBN.ten(@isbn)
    end

    should "handle used ISBN" do
      assert_equal "2900060976254", ISBN.between_new_and_used(@isbn)
    end
  end

  context "given an ISBN 10" do

    setup do
      @isbn = "2900060976254"
    end

    # should "handle ISBN 13" do
    #   assert_equal "9780060976255", ISBN.thirteen(@isbn)
    # end

    should "handle ISBN 10" do
      assert_equal "006097625X", ISBN.ten(@isbn)
    end

    # should "handle used ISBN" do
    #   assert_equal "2900060976254", ISBN.between_new_and_used(@isbn)
    # end
  end

  context "given a used ISBN" do

    setup do
      @isbn = "2900060976254"
    end

    # should "handle ISBN 13" do
    #   assert_equal "9780060976255", ISBN.thirteen(@isbn)
    # end

    should "handle ISBN 10" do
      assert_equal "006097625X", ISBN.ten(@isbn)
    end

    should "handle new ISBN" do
      assert_equal "9780060976255", ISBN.between_new_and_used(@isbn)
    end
  end
end