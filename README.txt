

                                    kissgen

                      KISS-Inspired Static Site GENerator
          

kissgen renders plain text source files AS-IS to HTML.  There is no syntax, no 
formatting, no schematic meanings, you do whatever you want with plain text 
files, and it will be displayed the same in web browser as in your text editor.


                                    WARNING


This project is for my personal use, therefore the documentation and options 
are severely lacking and limited, feel free to create feature requests or 
report any bugs in issue tracker [1].

[1] https://github.com/livibetter/kissgen/issues/new


                                 THE BEGINNING


For a very long time, I've grown to dislike how the web has become with all the 
fanciness but very little informative.  That's when I attempted to write in 
plain text [1] in late 2016, but that didn't go very far, because the media -- 
GitHub README/text render -- does not work for my needs, there is no 
linkification for text files except README.txt.

[1] https://github.com/lbarchive/w.txt

I have thought about using any static site generator or Jekyll to produce a 
plain-text-like view in web browser, but again, they all have too many features 
and dependencies that I don't need and don't want to install.

Finally in March, 2018, I started to work on my own very specific static site 
generator, coding in Bash.


                                  PHILOSOPHY


* KISS principle [K] and Unix philosophy [U]

    Well, attempting to follow them.

    [K] https://en.wikipedia.org/wiki/KISS_principle
    [U] https://en.wikipedia.org/wiki/Unix_philosophy

* All About Text

    * Render AS-IS (WYSIWYG) in HTML <pre>

    * No modifications of the text

* Less is More


                                    SCRIPTS


kissgen consists of a set of scripts:

- bin/gen generates static site HTML pages, using t2h to convert each text

- bin/idx generates directory listing, using t2h to form 00INDEX.html

- bin/t2h converts plain text file to HTML


                                 INSTALLATION


There is no installation at the moment and probably would never have if only I 
use them, you need to manually set $PATH:

    PATH=/path/to/kissgen/bin:$PATH


                                     USAGE


    $ gen text.dir html.dir
    $ idx html.dir


[G] ./doc/gen.html
[I] ./doc/idx.html
[T] ./doc/t2h.html


                                   COPYRIGHT


kissgen is licensed under the MIT License [L].

[L] ./LICENSE.html
