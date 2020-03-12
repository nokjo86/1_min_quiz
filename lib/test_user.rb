class TestUser
  attr_accessor :number_qs, :total_correct_answers, :finish_time, :accuracy
  attr_reader :first_name, :last_name, :user_id
  @@users=[]
  @@no_users=0
  def initialize(first_name,last_name)
    @first_name=first_name
    @last_name=last_name
    @user_id=first_name.downcase+"_"+last_name.downcase
    @number_qs = 0
    @total_correct_answers = 0
    @@users<<@user_id
    if File.file?("tester_summary.csv")==false
      CSV.open("tester_summary.csv","a+") do |csv|
        csv<<["user_id","first_name","last_name","number_qs","total_correct_answers","accuracy","time"]
      end
      @@no_users+=1
    end
  end
end
