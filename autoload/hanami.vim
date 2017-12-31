let s:path = escape(expand("<sfile>:p:h"), ' \')

exe 'ruby load "' . s:path . '/hanami.rb"'

function! hanami#GoToSpec()
	ruby go_to_spec
endfunction
function! hanami#GoFromSpec()
	ruby go_from_spec
endfunction
function! hanami#ToggleSpec()
	ruby toggle_spec
endfunction
function! hanami#GoToController()
	ruby go_to_controller
endfunction
function! hanami#GoToView()
	ruby go_to_view
endfunction
function! hanami#GoToTemplate()
	ruby go_to_template
endfunction
