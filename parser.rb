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
       puts "\s"*indent+"</#{@type}>"
   end
   
end

class NamespaceNode < Node
    def initialize(name, contents, prefix)
        puts "+ namespace +"
        super 'namespace',name,prefix
        contents.gsub!(NAMESPACE_DECLARATION) do
            @children << NamespaceNode.new($~[:name],$~[:scope],self.complete_name)
            ''
        end
        contents.gsub!(CLASS_DECLARATION) do 
            @children << ClassNode.new($~[:name],$~[:scope],self.complete_name) 
            ''
        end
        contents.gsub!(METHOD_DECL) do
          @children << MethodNode.new($~[:name],$~[:scope],self.complete_name) 
          ''
        end
    end
end

class ClassNode < Node
   def initialize(name, contents, prefix)
       puts "+ class #{name}+"
      super 'class', name, prefix
      contents.gsub!(METHOD_DECL) do
          @children << MethodNode.new($~[:name],$~[:scope],self.complete_name) 
          ''
      end
   end
end

class MethodNode < Node
    def initialize (name,contents,prefix)
        puts "+ method #{name}+"
        super 'method', name, prefix
    end
end

class Parser
   def parse_file (file_name)
      parse_text File.open(file_name).read 
   end
   
   protected
   
   def parse_text text
       # first remove comments 
       text.gsub!(COMMENTS) do |m| '' end
       # then begin populating the node tree
       NamespaceNode.new("::",text,'')
   end
end
