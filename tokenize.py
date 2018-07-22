#!/usr/bin/env python3

from sys import stdin, stdout

# Tokenizer function from https://github.com/cophi-wue/cophi-toolbox

def tokenize(document, pattern=r'\p{L}+\p{P}?\p{L}+', lower=True):
    """Tokenizes with Unicode regular expressions.

    With this function you can tokenize a ``document`` with a regular expression. \
    You also have the ability to commit your own regular expression. The default \
    expression is ``\p{Letter}+\p{Punctuation}?\p{Letter}+``, which means one or \
    more letters, followed by one or no punctuation, followed by one or more \
    letters. So, one letter words will not match. In case you want to lower \
    all tokens, set the argument ``lower`` to True (it is by default).
    Use the functions :func:`read_from_pathlist()` to read your text files.

    Args:
        document (str): Document text.
        pattern (str, optional): Regular expression to match tokens.
        lower (boolean, optional): If True, lowers all characters. Defaults to True.

    Yields:
        All matching tokens in the ``document``.

    Example:
        >>> list(tokenize("This is 1 example text."))
        ['this', 'is', 'example', 'text']
    """
    log.debug("Tokenizing document ...")
    if lower:
        log.debug("Lowering all characters ...")
        document = document.lower()
    compiled_pattern = regex.compile(pattern)
    tokenized_document = compiled_pattern.finditer(document)
    for match in tokenized_document:
        yield match.group()

stdout.write(tokenize(stdin))
