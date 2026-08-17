# texchanges
# Completion list for TeXstudio and TeXmaker.
# Install: Options > Completion > add this file, then enable texchanges.cwl.

#include:xcolor
#include:ulem

# Change commands
\txadd{text}
\txadd[options]{text}
\txremove{text}
\txremove[options]{text}
\txreplace{old}{new}
\txreplace[options]{old}{new}
\txhighlight{text}
\txhighlight[options]{text}
\txcomment{note}
\txcomment[options]{note}

# Short aliases, installed only when no other package defines them
\add{text}#*
\remove{text}#*
\replace{old}{new}#*
\highlight{text}#*
\comment{note}#*

# Authors
\txdefineauthor{id}
\txdefineauthor[name={name},color=color]{id}
\txsetanonymousname{name}

# Reports
\txlistofchanges
\txlistofchanges[options]
\txreportline{type}{status}{author}{id}{excerpt}#*
\txsummaryentry{key}{count}#*

# Localized strings, redefine to override
\txlistchangesname#*
\txsummaryname#*
\txcompactsummaryname#*
\txauthorname#*
\txaddedname#*
\txremovedname#*
\txreplacedname#*
\txhighlightedname#*
\txcommentedname#*
\txstatusname#*
\txpendingname#*
\txacceptedname#*
\txrejectedname#*
\txnochangesname#*

# Runtime setters
\txsetaddedmarkup{code}
\txsetdeletedmarkup{code}
\txsethighlightmarkup{code}
\txsetcommentmarkup{code}
\txsetauthormarkup{code}
\txsetauthormarkupposition{left|right}
\txsetauthormarkuptext{id|name}
\txsettruncatewidth{length}
\txsetsummarywidth{length}
\txsetsummarytowidth{text}
\txsetlocextension{extension}
\txsetsocextension{extension}

# Mode reflection
\texchangesmode#*

# changes compatibility, enabled with compat=changes
\definechangesauthor[name={name},color=color]{id}#*
\added{text}#*
\added[options]{text}#*
\deleted{text}#*
\deleted[options]{text}#*
\replaced{new}{old}#*
\replaced[options]{new}{old}#*
\listofchanges#*
\txcompatadded[options]{text}#*
\txcompatdeleted[options]{text}#*
\txcompatreplaced[options]{new}{old}#*
\txcompathighlight[options]{text}#*
\txcompatcomment[options]{note}#*

#keyvals:\usepackage/texchanges#c
review
final
original
draft
mode=#review,final,original
markup=#texchanges,default,underlined,bfit,nocolor
addedmarkup=#colored,uline,uuline,uwave,dashuline,dotuline,bf,it,sl,em
deletedmarkup=#colored,sout,xout,uline,uuline,uwave,dashuline,dotuline,bf,it,sl,em
highlightmarkup=#background,uuline,uwave
commentmarkup=#inline,todo,margin,footnote,uwave
authormarkup=#superscript,subscript,brackets,footnote,none
authormarkupposition=#left,right
authormarkuptext=#id,name
defaultcolor=#%<color%>
compat=#none,changes
commandnameprefix=#none,ifneeded,always
#endkeyvals

#keyvals:\txadd,\txremove,\txreplace,\txhighlight,\txcomment
author=#%<author-id%>
id=#%<change-id%>
comment=#%<note%>
status=#pending,accepted,rejected
#endkeyvals

#keyvals:\txlistofchanges
style=#list,summary,compactsummary
title=#%<title%>
show=#added,removed,replaced,highlighted,commented
status=#pending,accepted,rejected
author=#%<author-id%>
#endkeyvals
