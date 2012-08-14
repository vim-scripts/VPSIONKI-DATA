
" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 
" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 
"
" Plugin name :    VPSIONKI DATA
" Plugin function: CSV Contact - VIM Plugin
"
" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 
" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 


" Version: 
" Code version : 0.0099

" Current status:
"    First Initial Basic version (under work)

" Author:  
" Initially started by Patrick295767 </\at/\> gmail <\{dot}> com
" Help, patches, comments, add-ons, flowers, ...  in further progressing welcome anytime. 

" Goal:
"      (for some day future features): 
"      
"      Create a portable program for database such as the one 
"      of the PSION 5 MX, which has been so much useful and famous !!
"       
"      Format to be handled in one soon future: CSV (Windows) and dbf
"      Allow the multi-lines for the NOTES + being compatible with the use of 
"      mutt and mutt-query.

" INSTALL: 
"
" Add this code to your vim configuration
" and edit the variable with your CSV contact file:  g:myvarabookvimcsvfile 

" Use: 
" To start the CSV Contact plugin
"    Press \ followed by k
"    Once pressed, you may see your CSV file, and you can press
"    h to display the previous record number
"    j for going down to select the data (ex. address, name, surname, ...)
"    k for going up to select the data (ex. address, name, surname, ...)
"    l to display the next record number
"    / to start the search

" Tips: You could for instance use the unison program to sync this csv file. 

" Dependencies:
"    Does not need python
"    Does not need perl
"    ...
"    Does only require Vim or Gvim :):)
"    -> Remains Portable


" Variables:
" Please edit this line to setup your txt (csv file)"
"     It might look like :   "record1","bla","bla" \n  "record2","bla","bla"
let g:myvarabookvimcsvfile='c:\docs\outlook-contacts.txt'
if has("unix")
  let g:myvarabookvimcsvfile='~/contacts/outlook-contacts.txt'
endif


" Add. Variables: 
let g:csvsearchstring = ""  




" Main: 
map <Leader>k  :call FunctionVimContacts()<CR>

function!  FunctionVimContacts()
  let g:counterpos = 1 
  tabnew
  call s:renderView()
endfunction


function! s:renderView()
    setlocal modifiable
    "remember the top line of the buffer and the current line so we can
    "restore the view exactly how it was
    let curLine = line(".")
    let curCol = col(".")
    let topLine = line("w0")

    "delete all lines in the buffer (being careful not to clobber a register)
    silent 1,$delete _

    "draw the header line
    let header = 'Hello' 
    call setline(line(".")+1, header)
    call cursor(line(".")+1, col("."))
    call setline(line(".")+1, "Hello")
    call setline(line(".")+1, "Hello")
    call setline(line(".")+1, "Hello")
    call setline(line(".")+1, "Hello")
    call setline(line(".")+1, "Hello")


    let g:myvarcontactnbr = 1 
    call FunctionDrawAbookFile()
    call setline(2,"< Info : ** Please press: hjkl, o to open, q to exit ** >")
    redraw 

        let testescape = 0
        while testescape != 1
            let key = nr2char(getchar())
	    let testescape = s:handleKeypress(key)
	    if testescape == 2
	      exec("tabnew " . g:myvarabookvimcsvfile)
	      let testescape = 1
	      return
	    endif
        endwhile
       echo("Operation done")
	" setlocal nomodifiable
endfunction


function! FunctionReadit()
      let filelist = readfile(g:myvarabookvimcsvfile)
      let counter = 1
      for l in filelist
	let confirmResponse  = confirm( l  , "&Ok", 0)
	if counter == 5 
	  break 
	  return
	endif
	let counter = counter +1
      endfor
endfunc 


function!  FunctionDrawAbookFile()
   " Introduction
   let header="The Contact File - Item Number [". g:myvarcontactnbr ."]"
   " '  .  g:myvarcontactnbr .  " ]: "
   call setline(1,"")
   call setline(2,"")
   call setline(3,header) 
   call setline(4,"")
   call setline(5,s:functionAbookGetLine(g:myvarcontactnbr))
   return
endfunction


" From OUTLOOK or other
" to export the file do: Kommagetrennte Werte Windows gives a TXT 
function! s:functionAbookGetLine(item)
      let filelist = readfile(g:myvarabookvimcsvfile)
      let counter = 1
      for l in filelist
	  if a:item ==  counter
	    return l
	  endif
      let counter = counter +1
      endfor
endfunc 


function! FunctionDrawAbookSearchInFile(item)
      let filelist = readfile(g:myvarabookvimcsvfile)
      let counter = 1
      " let g:counterpos = 1
      "
      "	 execute "let @/=" . '"' a:item .'"'
      execute "let @/=" . '"' . a:item . '"'
      
      for l in filelist
           if counter >= g:counterpos
                  let matchit = matchstr(l,a:item) 
                  if matchit != ""
                    let g:myvarcontactnbr = counter 
                    call FunctionDrawAbookFile()
                    call setline(1,"Found item matching : " . counter . "!")
                    let g:counterpos = counter
                    redraw
                    set ignorecase
                    set hlsearch 
                    return 
                  endif
           endif
          let counter = counter +1
      endfor
      call setline(1,"Search result: no item found")
      redraw
endfunc 


function! s:handleKeypress(key)
    if a:key == 'j'
      let g:myvarcontactnbr = g:myvarcontactnbr -1 
      call FunctionDrawAbookFile()
      set nohlsearch
      redraw
    elseif a:key == 'k'
      let g:myvarcontactnbr = g:myvarcontactnbr +1 
      call FunctionDrawAbookFile()
      set nohlsearch
      redraw
    elseif a:key == 'h'
      let g:myvarcontactnbr = g:myvarcontactnbr -1 
      call FunctionDrawAbookFile()
      set nohlsearch
      redraw
    elseif a:key == 'l'
      let g:myvarcontactnbr = g:myvarcontactnbr +1 
      call FunctionDrawAbookFile()
      set nohlsearch
      redraw
    elseif a:key == 'o'
      return 2
    elseif a:key == 'n'
      let g:counterpos = g:counterpos +1
      let nsearch = g:csvsearchstring 
      call FunctionDrawAbookSearchInFile(nsearch)
    elseif a:key == '/'
      let g:counterpos = 1 
      let nsearch = input("enter search pattern: ")
      if nsearch == "" 
        echo "Search cancelled"
        set hlsearch
        return
      endif
      let g:csvsearchstring = nsearch 
      call FunctionDrawAbookSearchInFile(nsearch)
      set hlsearch
      set smartcase 
    elseif a:key == nr2char(27) || a:key == 'q'
        call setline(1,"Escape")
        redraw
        return 1
    endif
    return 0
endfunction


" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-   
"
"



