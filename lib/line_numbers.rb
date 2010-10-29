require 'ruby_parser'

class LineNumbers

  def initialize(path)
    rp = RubyParser.new
    file_sexp = rp.parse(File.read(path))
    @locations = {}
    case file_sexp[0]
    when :class
      process_class(file_sexp)
    when :block
      file_sexp.each_of_type(:class) { |sexp| process_class(sexp) }
    else
    end
  end
  
  def in_method? line_number
    !!@locations.detect do |method_name, line_number_range|
      line_number_range.include?(line_number)
    end
  end
  
  def method_at_line line_number
    @locations.detect do |method_name, line_number_range|
      line_number_range.include?(line_number)
    end.first
  end
  
  private
  
  def process_class(sexp)
    class_name = sexp[1]
    sexp.each_of_type(:defn) { |s| @locations["#{class_name}##{s[1]}"] = (s.line)..(s.last.line) }
    sexp.each_of_type(:defs) { |s| @locations["#{class_name}::#{s[2]}"] = (s.line)..(s.last.line) }
  end
  
end