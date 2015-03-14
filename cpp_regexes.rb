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
    ;
}x

METHOD_DECL = %r{
        (?<vn>:{2}?[A-Za-z_0-9~]+\g<vn>?){0}    #valid-name
        (?<s>{((\g<s>|[^{}]*))*}){0}            #scope
        (?<ps>\(((\g<ps>|[^\)\(]*))*\)){0}      #parenthesis scope
        # TODO: clean this 
        (?<method_declaration>
        (?:\s+(?<return_value>\g<vn>)\s+(?<method_name>\g<vn>)|
                                     \s+(?<method_name>\g<vn>))
        \s*\g<ps>\s*
        (?:;|(?<scope>\g<s>))
        )
}x
