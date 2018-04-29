require_relative "expenses.rb"

fluctuations = []
fluctuations += Expenses.new.extract()
fluctuations += Income.new.extract()

#start_date = Date.new(2015, 11, 23)
#money = 253.6

#start_date = Date.new(2015, 12, 23)
#money = 1619.75

#start_date = Date.new(2015, 12, 27)
#money = 1196.39

# start_date = Date.new(2015, 12, 31)
# money = 1206.07

start_date = Date.new(2016, 01, 04)
money = 1042.26

alerts = []
end_date = Date.strptime(ARGV[0], "%Y-%m-%d")

start_date.upto end_date do |date|
  labels = ""
  fluctuations.delete_if do |f|
    amount = f.apply(date)
    unless amount == 0
      money += amount
      labels += "[#{f.label}] "
    end
    f.expired?(date)
  end
  if (money < 0)
    alerts.push "#{date} you go under at #{money}"
  end
  printf "%-20s %15.2f %s\n", date, money, labels
end

alerts.each { |a| puts a }
