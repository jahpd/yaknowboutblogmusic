if Rails.env == 'development'
   RubyPython.start :python_exe => "python2.7"
else
   RubyPython.start :python_exe => "python2.6"
end

