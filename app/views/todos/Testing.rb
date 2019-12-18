require 'byebug'
class Student
  attr_accessor :first_name, :last_name
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def method_missing(method_name, *args, &block)
    #method_name = method_name.to_s  # "is_Prajit?"\
    return  super unless method_name.to_sym.start_with?("is_") && method_name.end_with?("?")
    self.class.define_method method_name.to_sym do  # def :is_Prajit? end
      method_name.include? self.first_name
    end
    self.send(method_name, *args, &block) #invoking a method
    # else
    #     puts "Say not a missing method"
    # end
  end
end

s1 = Student.new("prajit", "bhandari")
# s2 = Student.new("saroj", "khatiwada")
# s3 = Student.new("anuj", "shilpakar")
# puts s1.is_prajit? #true
# puts s1.is_prajitaman? #true
# puts s1.send("is_prajit?") #true
# 2.Hello
s1.Hello
# puts s1.is_saroj? #false
# puts s2.is_saroj? #true

# puts Student.superclass
