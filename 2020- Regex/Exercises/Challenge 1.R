### CHALLENGE 1: Words that start with a consonant and end with a vowel ###

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
