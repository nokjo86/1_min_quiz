require_relative 'shared_features'
require_relative 'test_user'
include Features
require 'csv'
require 'tty-font'
require 'tty-prompt'
require 'date'
require 'colorize'

def name_check(name)
  pass=0
  fedup_level=0
    while pass == 0 && fedup_level < 5
      if name.include?(" ")
        puts "Please try again, honestly I prefer one word only" 
        fedup_level+=1
        name=gets.chomp.strip
      elsif name.match? /\A[a-zA-Z'-]*\z/ 
    pass+=1 
        return name
      else
        puts "Interesting name?! Please try again"
        fedup_level+=1
        name=gets.chomp.strip
      end
  end
  puts "You are HOPELESS...Bye!"
  exit
end

def prep_qs()
  csv_text = File.read('questions.csv')
  puts csv_text
  csv_text=csv_text.chop
  csv = CSV.parse(csv_text, headers: true)
  question_list=[]
  csv.each do |row|
    row_data = row.to_hash
    question_list<<row_data
  end
  question_list
end

def quiz(user,question_list)
  user.number_qs+=1
  question=question_list.sample
  font = TTY::Font.new(:block)
  prompt = TTY::Prompt.new
  answer = prompt.select(font.write(Time.now.strftime("%k:%M.%S").strip) + "\n\n" + question["question"]) do |quiz|
    quiz.default 1

    quiz.choice question["answer_1"],1
    quiz.choice question["answer_2"],2
    quiz.choice question["answer_3"],3
    system("clear")
  end
  if answer == question["correct_answer"].to_i
    user.total_correct_answers+=1
  end
end

def quiz_start(user,question_list)
  start_time=Time.now
  end_time=start_time+60
  while Time.now < end_time
    quiz(user,question_list)
  end
end

def save(user)
  user.finish_time = Time.now
  user.accuracy=user.total_correct_answers/(user.number_qs*1.0)*100
  user.accuracy=user.accuracy.round(2)
  CSV.open("tester_summary.csv","a") do |csv|
  csv<<[user.user_id,user.first_name,user.last_name,user.number_qs,user.total_correct_answers,user.accuracy,user.finish_time]
  end
end

system('clear')
font = TTY::Font.new(:doom)
puts font.write("1 Min Quiz")
puts
system "echo 'Hello Tester!!!!!!!!!' | lolcat"
puts "First how should I address you?".green
name=gets.chomp.strip
first_name = name_check(name)
puts "Now tell me your last name".green
name = gets.chomp.strip
last_name = name_check(name)
user = TestUser.new(first_name,last_name)

question_list = prep_qs()
quiz_start(user,question_list)
system("clear")
font = TTY::Font.new(:block)
puts font.write("TIMEUP").red
sleep 1.5
system('clear')
save(user)

font = TTY::Font.new(:doom)
puts font.write("1 Min Quiz")
print "Your trivial awarness is "
puts user.accuracy.to_s.colorize(:color => :light_red, :background => :white) + " %" + " based on #{user.number_qs} questions"
prompt = TTY::Prompt.new
answer = prompt.select("") do |finish|
  finish.default 1

  finish.choice "Try again!",1
  finish.choice "Feel like contributing?"+"\n",2
  finish.choice "Back",3
end
case answer
  when 1
  quiz_start(user,question_list)
  when 2
  add_question()
  else
  load 'joyce_quiz_app_gem.rb'
end
