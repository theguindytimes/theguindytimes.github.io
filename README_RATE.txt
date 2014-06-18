Hello!

  So I had to make a few changes to make "letsrate" gem work. 

  In case you get stuck at bundle install please follow the following steps

  -> Goto the directory where all your gems are stored and find the letsrate 
     generator

        -> In my case it was at "/home/saravana/.rvm/gems/ruby-2.0.0-p481/gems/
           letsrate-1.0.9/lib/generators/letsrate"

 -> Open the letrate_generator.rb file

 -> Scroll to the very end to find "create_migration"

 -> Replace it with "create_letsrate_migration"

 -> Now run bundle install.

 Should work fine

