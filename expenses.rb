require_relative "guess"

class Expenses < Guess
  EXPENSE_PATH = "./expenses.yml"

  def initialize
    super(EXPENSE_PATH)
  end

  def extract
    super(:expense)
  end
end

class Income < Guess
  INCOME_PATH = "./income.yml"

  def initialize
    super(INCOME_PATH)
  end

  def extract
    super(:income)
  end
end

class Fluctuation
  attr_reader :label, :expires

  def initialize(args = {})
    @label = args[:label]
    @amount = args[:amount]
    @amount *= -1 if (args[:type] == :expense)
    @starts = args[:starts]
    @expires = args[:expires]
  end

  def started?(date)
    (@starts.nil? || date >= @starts)
  end

  def expired?(date)
    (!@expires.nil? && date > @expires)
  end
end

class MonthlyFluctuation < Fluctuation
  def initialize(args = {})
    @day = args[:day]
    super
  end

  def apply(date)
    return 0 if !started?(date) || expired?(date)
    if (date.day == @day)
      @amount
    else
      0
    end
  end
end

class DailyFluctuation < Fluctuation
  def apply(date)
    return 0 if !started?(date) || expired?(date)
    @amount
  end
end

class OneOffFluctuation < Fluctuation
  def initialize(args = {})
    @date = args[:date]
    super
  end

  def apply(date)
    return 0 if !started?(date) || expired?(date)
    if (date == @date)
      @amount
    else
      0
    end
  end

  def expired?(date)
    super(date) || (date > @date)
  end
end
