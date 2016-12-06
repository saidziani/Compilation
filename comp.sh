#!/bin/bash
flex lex.l && bison -d syn.y && gcc *.c -o out && ./out

