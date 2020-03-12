# require "joyce_quiz_app_gem/version"

require 'tty-font'
require 'tty-prompt'

def pic1   
  puts"
          .   :   .  
      '.   .  :  .   .'
    ._   '._.-'''-._.'   _.
      '-..'         '..-' 
  --._ /.==.     .==.\\ _.--
      ;/_o__\\   /_o__\\;
  -----|`     ) (     `|-----
      _: \\_) (\\_/) (_/ ;_
  --'  \\  '._.=._.'  /  '--
    _.-''.  '._.'  .''-._
    '    .''-.(_).-''.    '
      .'   '  :  '   '.
          '    :   '
              '"
end

system('clear')
font = TTY::Font.new(:doom)
puts font.write("1 Min Quiz")
prompt = TTY::Prompt.new
user_type = prompt.select("What's your role?") do |menu|
  menu.default 1

  menu.choice 'Tester',1
  menu.choice 'Creator'+"\n",2
  menu.choice 'Exit',3
end
sleep 1
system ("clear")
if user_type==1
  load 'tester.rb'
  elsif user_type==2
    load 'creator.rb'
  else 
    puts
    system "echo '      Have a good day' | lolcat"
    pic1()
    sleep 1
    exit
end



