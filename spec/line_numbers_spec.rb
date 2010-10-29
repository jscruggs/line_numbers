require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe LineNumbers do
  before do
    @ln = LineNumbers.new(File.expand_path(File.dirname(__FILE__) + "/resources/foo.rb"))
  end
  
  describe "in_method" do
    it "should know if a line is NOT in a method" do
      @ln.in_method?(2).should == false
    end
  
    it "should know if a line is in an instance method" do
      @ln.in_method?(8).should == true
    end
  
    it "should know if a line is in an class method" do
      @ln.in_method?(3).should == true
    end
  end
  
  describe "method_at_line" do
    it "should know the name of an instance method at a particular line"do
      @ln.method_at_line(8).should == "Foo#what"
    end
    
    it "should know the name of a class method at a particular line"do
      @ln.method_at_line(3).should == "Foo::awesome"
    end
    
    it "should know the name of a private method at a particular line"do
      @ln.method_at_line(28).should == "Foo#whoop"
    end
    
    it "should know the name of a class method defined in a 'class << self block at a particular line"do
      @ln.method_at_line(23).should == "Foo::neat"
    end
    
    it "should know the name of an instance method at a particular line in a file with two classes" do
      ln = LineNumbers.new(File.expand_path(File.dirname(__FILE__) + "/resources/two_classes.rb"))
      ln.method_at_line(3).should == "Foo#stuff"
      ln.method_at_line(9).should == "Bar#stuff"
    end
  end
  
end