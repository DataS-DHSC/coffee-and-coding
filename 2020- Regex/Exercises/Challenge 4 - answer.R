### CHALLENGE 4: Usernames at least 8 characters long, using only letters and numbers ###

test_names <- c('username',
                'username12',
                'Username12',
                'user_name12',
                'username!',
                'UserName 12')

stringr::str_extract_all(test_names, '^[a-zA-Z0-9]{8,}$')
