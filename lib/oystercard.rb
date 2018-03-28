require_relative 'station'

class Oystercard

  MINIMUM_AMOUNT = 1
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 3

  attr_reader :balance
  attr_accessor :journey_tracker

  

  def initialize
    @balance = 0
    @in_journey = false
    @journey_tracker = []
    @entry_station = nil
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !@entry_station.nil?
  end

  def touch_in(station_name)
    raise "Insufficient funds" if @balance < MINIMUM_AMOUNT
    @entry_station = Station.new
    @journey_tracker << @entry_station
  end

  def touch_out

    @entry_station = nil
    deduct(MINIMUM_FARE)

  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
