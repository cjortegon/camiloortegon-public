<meta name="date" content="2021-9-5" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/mac_plant.jpeg" />
<meta name="language" content="en" />
<meta name="tags" content="apple,mac" />

# Set-up Environment variables in Mac

Adding environment variables in Mac computers is not always the same, so let's solve this once and for all.

You probably have tried to add them using `terminal` with `export MY_ENV=my_value`, but you have figured out that with this method they are removed once you end that terminal session.

Then you discover that you can edit either `.profile` or `.bash_profile`. So you placed this command inside the file to make sure the environment variable starts with your *bash* session. But in the most recent versions of Mac, these files seem not to be working fine. This happens because you need to tell bash that it needs to add the environment file as "source". To do so, just edit one the following files with this command:

Open or create with `nano` or `vi` a hidden file either `.zshenv` or `.zshrc`.

>   
    source ~/.profile
    source ~/.bash_profile

You are all set, close Terminal and re-open it. All the environment variables that you have placed before inside these source files will be added for every bash session.
