" FILENAME: typo-twister.vim
" AUTHOR: Zachary Krepelka
" DATE: Thursday, October 19th, 2023

if exists('g:loaded_typo_twister')

	finish

endif

let g:loaded_typo_twister = 1

let s:words = get(g:, 'easy_to_mistype_words', ['the'])

function! s:permutations(word)

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

	for l:wrong in s:permutations(a:right)[1:]

		exec 'ab' l:wrong a:right

	endfor

endfunction

function! s:source()

	echo 'Please Wait'

	for l:word in s:words

		call s:abbreviate_all_word_permutations(l:word)

	endfor

	redraw

	echo 'Finished'

endfunction

command Twist call s:source()
