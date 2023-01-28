The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be
interpreted as described in RFC 2119. 

A compliant Nik implementation MUST recognize any program that matches the
following ABNF grammar, starting at `expr`:

    expr =  ignored expr ignored
    expr =/ list
    expr =/ atom
    expr =/ string
    
    list = "(" 1*(expr) ")"
    
    atom = 1*(atomchar)
    atomchar =  %x00-09
    atomchar =/ %x0b-1f
    atomchar =/ %x21-27
    atomchar =/ %x2a-3a
    atomchar =/ %x3c-ff
    
    string = DQUOTE *stringchar DQUOTE
    stringchar =  %x00-21
    stringchar =/ %x23-5b
    stringchar =/ %x5d-ff
    stringchar =/ BSLASH BSLASH
    stringchar =/ BSLASH DQUOTE
    
    comment = ";" *(%x00-09 / %x0b-ff) LF
    ignored = *(SP / LF / comment)

    BSLASH = %x5d
    SP = %x20
    LF = %x0a
    DQUOTE = %x22

It SHOULD NOT execute any part of a program that does not match this grammar.

When confronted with such a program, it MUST either halt (RECOMMENDED) or loop
infinitely, and SHOULD output the case-insensitive ASCII string `syntax error`
verbaitem to the standard error output stream.

The following atoms MUST be predefined contained within the initial environment
supplied by the implementation: `lambda`, `macro`, `keyword`, `quote`, `car`,
`cdr`, `cons`, `set`, `do`.

The implementation MUST evaluate the program with the following rules:

  1. Any `list` that contains a first element evaluating to the initial environment's
     definition of `lambda`, `quote`, or `keyword` MUST be evaluated to
     itself as-is.
  2. Any `list` that contains a first element evaluating to the initial environment's
     definition of `quote` MUST be evaluated to the second element in that
     list. If the `list` contains more than two elements, the implementation
     SHOULD halt the program, and the implementation SHOULD output the
     case-insensitive ASCII string `quotation error: expected 2 arguments`
     verbaitem to the standard error output stream.
  3. Any `list` that contains a first element evaluating to another `list` that
     contains a first element evaluating to the initial environment's
     definition of `lambda` MUST be transformed into the third element of the
     inner list evaluated inside an environment that is a copy of the initial
     programs environment, but with each additional element of the outer list
     being bound to each atom in the second element of the inner list after
     evaluation.
  4. Any `list` that contains a first element evaluating to another `list` that
     contains a first element evaluating to the initial environment's
     definition of `macro` MUST be transformed into the third element of the
     inner list evaluated once inside an environment that is a copy of the
     initial programs environment, but with each additional element of the
     outer list being bound to each atom in the second element of the inner
     list before evaluation, then be evaluated a second time within the
     environment the outer `list` was contained within.
     However, if the inner `list` originated from one of the additional
     elements mentioned in rule 3, the implementation MAY reject the program.
  5. Any `list` that contains a first element evaluating to an expression not
     covered by rules 1, 2, 3, or 4 MUST cause the implementation to halt, and
     the implementation SHOULD output the case-insensitive ASCII string
     `evaluation error: first element of list not callable` verbaitem to the
     standard error output stream.
  6. Any `atom` that is being evaluated and has name is not contained within
     the current environment SHOULD cause the implementation to halt, and the
     implementation SHOULD output the case-insensitive ASCII string `evaluation
     error: atom not defined` verbaitem to the standard error output stream.
     The implementation SHOULD NOT evaluate the aforementioned atom to garbage
     data.
  7. Any `string` MUST be evaluated to itself as-is.

The following atoms SHOULD be predefined contained within the initial environment
supplied by the implementation: `+`, `-`, `*`, `/`, `++`, any atom matching
the ABNF definition `*1(%x30-39)`, `print`.

If the implementation defines the above atoms, then it MUST also add the
following rules to its evaluation algorithm:

  8. TODO: write more rules

The following atoms MAY be predefined contained within the initial environment
supplied by the implementation: `eval`.

If the implementation defines the above atoms, then it MUST also add the
following rules to its evaluation algorithm:

  9. TODO: write more rules

The implementation MAY define any additional atoms as it sees fit, as long as
said definitions do not conflict with any definition stated in this
specification.