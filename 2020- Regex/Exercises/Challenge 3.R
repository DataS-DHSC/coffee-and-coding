### CHALLENGE 3: Words that start with a consonant and end with a vowel ###

test_numbers <- c('07765204912',
                  '09125839053',
                  '078 9285 7192',
                  '0207 210 4850',
                  '00442072104850',
                  '00447871655397',
                  'Tel: 07765204912')

stringr::str_extract_all(test_numbers, 'regex_here')
