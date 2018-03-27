class Oystercard

  MINIMUM_AMOUNT = 1
  MAXIMUM_BALANCE = 90

  attr_reader :balance

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise "Insufficient funds" if @balance < MINIMUM_AMOUNT
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end
end
