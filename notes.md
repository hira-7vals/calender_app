1. use an explicit return statement for readiblity, otherwise ruby prefers the last line as the return statement
2. attr_accessor, attr_writer, attr_reader https://www.rubyguides.com/2018/11/attr_accessor/ 
3. freeze; https://stackoverflow.com/questions/1023146/is-it-good-style-to-explicitly-return-in-ruby
4. mixins give you the ability to share code; modules are a great way to group services, concerns and constants together 
5. for mixins --> inside a class you can include multiple modules and then use their functionality after you instantiate an object
6. https://www.webascender.com/blog/tutorial-classes-inheritance-modules-mixins-ruby-rails/
7. Proc is similar to a lambda function or a block of code 
8. length and size are aliases of each other, while count can also give the number of occurences of a character
