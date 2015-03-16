NAMESPACE_DECLARATION = %r{
    (?<vn>:{2}?[A-Za-z_0-9~]+\g<vn>?){0}    #valid-name
    (?<s>{((\g<s>|[^{}]*))*}){0}            #scope
    namespace\s+(?<name>\g<vn>)\s*(?<scope>\g<s>)  
}x

CLASS_DECLARATION = %r{
    (?<vn>:{2}?[A-Za-z_0-9~]+\g<vn>?){0}                      #valid-name
    (?<s>{((\g<s>|[^{}]*))*}){0}                              #scope
    (?<pc>\s*(?:(?:public|protected|private)\s+\g<vn>(?:\s*,\s*\g<pc>)? )){0}  #parent class(es)
    class\s+
    (?<name>\g<vn>)\s*
    (?::\g<pc>)?\s*
    (?<scope>\g<s>)?
    \s*;
}x

METHOD_DECL2 = %r{
        (?<vn>:{2}?(?:[A-Za-z_0-9~]+|operator[^\s])\g<vn>?){0}    #valid-name
        (?<s>{((\g<s>|[^{}]*))*}){0}                              #scope
        (?<ps>\(((\g<ps>|[^\)\(]*))*\)){0}                        #parenthesis scope
        (?<ts>\<((\g<ts>|[^\<\>]*))*\>){0}                        #template scope
        (?<cm>template\s*\<ts>|const|static){0}                   #class modifiers

        (?:\g<cm>\s+)* #[optional] modifiers
        (?:(?<retval>\g<vn>)[\s\*\&]*\s[\s\*\&]*(?<name>\g<vn>)| #retval and funtion name or
              (?<name>\g<vn>)) # just function name (ctors and dtors)
        \s*(?:;|\g<ps>\s*(?:const|:[^\{]+)?\s*       # take into account const, initializer lists... (what else?)
        (?:;|(?<scope>\g<s>)))
}x

METHOD_DECL = %r{
        (?<vn>:{2}?(?:[A-Za-z_0-9~]+|operator[^\s])\g<vn>?){0}    #valid-name
        (?<s>{((\g<s>|[^{}]*))*}){0}                              #scope
        (?<ps>\(((\g<ps>|[^\)\(]*))*\)){0}                        #parenthesis scope
        (?<ts>\<((\g<ts>|[^\<\>]*))*\>){0}                        #template scope
        (?<cm>template\s*\<ts>|const|static){0}                   #class modifiers

        (?:\g<cm>\s+)* #[optional] modifiers
        (?:
           (?<name>\g<vn>)\s*\g<ps>\s*(?:;|(?::[^\{]+)\g<s>) #ctors and dtors
           |
           (?<retval>\g<vn>)[\s\*\&]*\s[\s\*\&]*(?<name>\g<vn>)\s* #functions and variable declarations
            (?:; | #variable
                \g<ps>\s*(?:const)?\s*(?:;|(?<scope>\g<s>)) #method decl / def
            )
        )
}x

COMMENTS = %r{
        (\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|
        (\/\/.*)
}x

