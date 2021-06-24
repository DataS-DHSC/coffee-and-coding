### CHALLENGE 2: Words in ALL CAPS ###

test_words <- c('Hello',
                'hAvE',
                'a',
                'gO!',
                '(it',
                'WILL',
                'work).',
                'You',
                'Got', 
                'This')

stringr::str_extract_all(test_words, 'regex_here')
