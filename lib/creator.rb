require_relative 'shared_features'
include Features
require 'colorize'
require 'tty-table'
require 'csv'
require 'highline'

def continue
  print "Press any key to continue"
  gets
end

def review()
  if File.exist?('tester_summary.csv') == false
    then puts "No Data recorded"
    sleep 2
    menu()
  end

  csv_text = File.read('tester_summary.csv')
  csv = CSV.parse(csv_text, headers: true)
  user_complete_list=[]
  csv.each do |row|
    row_data = row.to_hash
    user_complete_list<<row_data
  end
  user_list=[]
  user=[]
  user_complete_list.each do |record|
    record.each do |k,v|
      if k == "user_id" || k == "total_correct_answers" || k =="accuracy"
        then 
        user.push(v)
      end
    end
  user_list<<user
  user=[]
  end

  table = TTY::Table.new ['User ID'.yellow,'Correct Answers'.yellow,'Accuracy(%)'.yellow], user_list
  puts table.render(:ascii)
  puts
  puts
  continue
  menu()
end

def login()
  user1 = []
  pwd=[]
  File.readlines('test.txt', chomp: true).each.with_index(1) do |line, line_number|
    user1 << line if line_number == 1
    pwd << (line_number == 2 ? line : next)
  end
  cli = HighLine.new
  default=user1[0]
  username = cli.ask("Enter your username: ") { |q| q.default = default }
  require 'io/console'
  print "Enter your password: "
  password = STDIN.noecho(&:gets).chomp
  sleep 1
  if password==pwd[0]
    then menu()
    else system("clear")
      login()
  end
end
 
def menu()
  prompt = TTY::Prompt.new
  select = prompt.select("What would you like to do today") do |menu|
    menu.default 1

    menu.choice "Review results",1
    menu.choice "Create new question?",2
    menu.choice "Let's destroy EVERYTHING".red+"\n".red,3
    menu.choice "Back",4
    system("clear")
  end
  case select
    when 1
    review()
    when 2
    add_question()
    when 4
    load 'joyce_quiz_app_gem.rb'
    else
    system('clear')
    puts "Please type YES to confirm"
    print ">"
    input=gets.chomp
      if input == "YES"
      File.delete('tester_summary.csv') if File.exist?('tester_summary.csv')
      end
    menu()
  end
end

login()
