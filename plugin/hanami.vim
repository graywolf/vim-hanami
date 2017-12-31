if exists('g:loaded_hanami') || &cp
	finish
endif

if !has('ruby')
	call s:ErrMsg('Error: vim-hanami requires vim compiled with +ruby')
	finish
endif

if exists('g:hanami_devel')
	if !exists('g:hanami_devel_runtimepath')
		let &rtp .= ',' . expand('<sfile>:p:h:h')
		let g:hanami_devel_runtimepath = 1
	endif
endif

let g:loaded_hanami = 1

command! -nargs=0 HanamiGoToSpec call hanami#GoToSpec()
command! -nargs=0 HanamiGoFromSpec call hanami#GoFromSpec()
command! -nargs=0 HanamiToggleSpec call hanami#ToggleSpec()
command! -nargs=0 HanamiGoToController call hanami#GoToController()
command! -nargs=0 HanamiGoToView call hanami#GoToView()
command! -nargs=0 HanamiGoToTemplate call hanami#GoToTemplate()
