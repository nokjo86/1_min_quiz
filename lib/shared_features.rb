module Features
  def add_question()
    require 'csv'
    puts "Please enter your question"
    print ">"
    question=gets.chomp
    puts "Please enter option 1"
    print ">"
    answer_1=gets.chomp
    puts "Please enter option 2"
    print ">"
    answer_2=gets.chomp
    puts "Please enter option 3"
    print ">"
    answer_3=gets.chomp  
    
    i=0
    while i == 0
      system("clear")
      puts "-"*27
      puts question
      puts answer_1
      puts answer_2
      puts answer_3
      puts "-"*27
      puts
      puts "Which is the correct answer (1-3)"
      print ">" 
      input=gets.chomp.to_i
      if input.between?(1,3) 
        correct_answer=input
        i+=1
      end
    end
    CSV.open("questions.csv","a") do |csv|
    csv<<[question,answer_1,answer_2,answer_3,correct_answer]
    sleep 1
    puts "Question saved"
    sleep 1
    puts csv
    gets
    end
    load './joyce_quiz_app_gem.rb'
  end
end