require './cpp_regexes.rb'
class Node
   attr_reader :children, :name, :prefix, :type
   
   def initialize (type, name, prefix = '')
      @name     = name 
      @prefix   = prefix
      @children = Array.new
      @type     = type
   end
   
   def complete_name
     @prefix+@name
   end 
   
   # idea: return list of candidates ["foo::bar", "cv::bar"] when an element "bar" is searched
   def find element_name
       if @name === name then 
           return true
       else
           retval = false;
           @children.each do |child|
               retval |= child.find element_name
               return true if retval
           end
       end
   end
   
   def display(indent = 0)
       puts "\s"*indent+"<#{@type} name=\"#{@name}\">"
       @children.each { |c| c.display(indent+1) }
       puts "\s"*indent+"</#{@type} name=\"#{@name}\">"
   end
   
end

class NamespaceNode < Node
    def initialize(name, contents, prefix)
        super 'namespace',name,prefix
        contents.scan(NAMESPACE_DECLARATION) do
            @children << NamespaceNode.new($~[:name],$~[:scope],self.complete_name)
        end
    end
end

class Parser
   def parse_file (file_name)
      parse_text File.open(file_name).read 
   end
   
   protected
   
   def parse_text text
      NamespaceNode.new("::",text,'')
   end
end
