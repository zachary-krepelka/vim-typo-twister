" FILENAME: typo-twister.vim
" AUTHOR: Zachary Krepelka
" DATE: Thursday, October 19th, 2023
" ABOUT: Typo correction for the Vim text editor
" ORIGIN: https://github.com/zachary-krepelka/vim-typo-twister.git
" UPDATED: Monday, December 2nd, 2024 at 4:29 AM

" Variables {{{1

if exists('g:loaded_typo_twister')

	finish

endif

let g:loaded_typo_twister = 1

let s:words = get(g:, 'easy_to_mistype_words', ['the'])

" Functions {{{1

function! s:permute(word)

	function! s:swap(list, i, j)
		let l:saved     = a:list[a:i]
		let a:list[a:i] = a:list[a:j]
		let a:list[a:j] = l:saved
	endfunction

	let l:delimiter = ''
	let l:permutations = []

	" Helper uses Heap's algorithm.

	function! s:helper(arr, num) closure
		if a:num == 0
			call add(l:permutations, join(a:arr, l:delimiter))
		else
			for i in range(a:num)
				call s:helper(a:arr, a:num - 1)
				call s:swap(
					\ a:arr,
					\ a:num % 2 == 0 ? 0 : i,
					\ a:num)
			endfor
			call s:helper(a:arr, a:num - 1)
		endif
	endfunction

	call s:helper(split(a:word, '\zs'), strlen(a:word) - 1)

	return l:permutations

endfunction

function! s:abbreviate_all_word_permutations(right)

	for l:wrong in s:permute(a:right)[1:]

		exec 'ab' l:wrong a:right

	endfor

endfunction

function! s:twist(words)

	echo 'Please Wait'

	for l:word in a:words

		call s:abbreviate_all_word_permutations(l:word)

	endfor

	redraw

	echo 'Finished'

endfunction

" Commands {{{1

command! -nargs=* Twist {

	call s:twist(empty(<q-args>) ? s:words : split(<q-args>, ' '))
}

" Menus {{{1

if has("gui_running") && has("menu") && &go =~# 'm'

	amenu <silent> &Plugin.Typo\ Twister.&Twist :Twist<CR>
	amenu <silent> &Plugin.Typo\ Twister.&Help :tab help typo-twister<CR>

endif
