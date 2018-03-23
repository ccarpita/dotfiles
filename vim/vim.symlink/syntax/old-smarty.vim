" Vim syntax file
" Language:	Smarty Templates
" Maintainer:	Manfred Stienstra manfred.stienstra@dwerg.net
" Last Change:  Fri Apr 12 10:33:51 CEST 2002 
" Filenames:    *.tpl
" URL:		http://www.dwerg.net/download/vim/smarty.vim

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
	if version < 600
		syntax clear
	elseif exists("b:current_syntax")
		"finish
	endif
	let main_syntax = 'smarty'
endif

syn case ignore
syn include @phpSmarty syntax/php.vim

runtime! syntax/html.vim


"syn cluster htmlPreproc add=smartyUnZone
syn match smartyNumeric contained "\<[0-9]\+\>"
syn match smartyBlock contained "[[\]]"
syn match smartyRef contained "->"
syn match smartyPipe contained "|"
syn match smartyLogic contained "||" "&&"
syn match smartyVariable  contained "$[a-zA-Z_][->a-zA-Z0-9_\.]\+"
syn match smartyString contained '"[^"]*"'
syn match smartyString contained "'[^']*'"

syn keyword smartyTagName capture config_load include include_php contained
syn keyword smartyTagName insert if elseif else ldelim rdelim literal contained
syn keyword smartyTagName php section sectionelse foreach foreachelse contained
syn keyword smartyTagName strip assign contained

syn keyword smartyControlTag if elseif else  contained

syn keyword smartyInFunc ne eq  contained

syn keyword smartyProperty contained "file="
syn keyword smartyProperty contained "loop="
syn keyword smartyProperty contained "name="
syn keyword smartyProperty contained "include="
syn keyword smartyProperty contained "skip="
syn keyword smartyProperty contained "section="

syn keyword smartyConstant "\$smarty" 

syn keyword smartyDot .

syn region smartyZone start="{" end="}" contains=smartyProperty, smartyString, smartyBlock, smartyTagName, smartyConstant, smartyInFunc, smartyLogic, smartyRef, smartyPipe, smartyVariable, smartyControlTag, smartyNumeric,smartyString 

syn region smartyZonePHP start="{php}" end="{/php}" 


syn region smartyZoneComment start="{\*" end="\*}"  

syn cluster htmlTop contains=@htmlTop,smartyZone

syn region  htmlString   contained start=+"+ end=+"+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,smartyZone,smartyZoneComment
  syn region htmlLink start="<a\>\_[^>]*\<href\>" end="</a>"me=e-4 contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript,@htmlPreproc,smartyZone,smartyZoneComment
syn region  htmlTag                start=+<[^/!]+   end=+>+ contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster,smartyZone,smartyZoneComment

syn region  javaScript start=+<script[^>]*>+ keepend end=+</script>+me=s-1 contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc,smartyZone,smartyZoneComment

syntax cluster javaScriptAll       contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptStringD,javaScriptStringS,javaScriptRegexpString,javaScriptNumber,javaScriptFloat,javaScriptLabel,javaScriptSource,javaScriptType,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFunction,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptGlobalObjects,javaScriptExceptions,javaScriptFutureKeys,javaScriptDomErrNo,javaScriptDomNodeConsts,javaScriptHtmlEvents,javaScriptDotNotation,smartyZone,smartyZoneComment

syntax region  javaScriptParen     matchgroup=javaScriptParen   transparent start="("  end=")"  contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrC,javaScriptParen,javaScriptBracket,javaScriptBlock,@htmlPreproc,smartyZone,smartyZoneComment

syntax region  javaScriptStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=javaScriptSpecial,@htmlPreproc,smartyZone,smartyZoneComment
syntax region  javaScriptStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=javaScriptSpecial,@htmlPreproc,smartyZone,smartyZoneComment



if version >= 508 || !exists("did_smarty_syn_inits")
  if version < 508
    let did_smarty_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink smartyTagName Identifier
  HiLink smartyProperty Constant 
  " if you want the text inside the braces to be colored, then
  " remove the comment in from of the next statement
  "HiLink smartyZone Include 
  HiLink smartyInFunc Function
  
  HiLink smartyBlock Constant
  HiLink smartyString Constant
  
  HiLink smartyPipe Special
  HiLink smartyNumeric Special
  HiLink smartyDot SpecialChar
  
  HiLink smartyVariable Identifier
  HiLink smartyControlTag Identifier
  
  HiLink smartyZoneComment Comment
  delcommand HiLink
endif 

let b:current_syntax = "smarty"

if main_syntax == 'smarty'
  unlet main_syntax
endif

