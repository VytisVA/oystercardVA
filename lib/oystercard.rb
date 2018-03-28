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
    @journey_tracker = {:start_station => [], :end_station => []}
    @entry_station = nil
    @exit_station = nil
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !@entry_station.nil?
  end

  def touch_in(station_name = Station.new)
    raise "Insufficient funds" if @balance < MINIMUM_AMOUNT
    @entry_station = station_name.name
    @journey_tracker[:start_station] << @entry_station
  end

  def touch_out(station_name = Station.new)

    @exit_station = station_name.name
    @journey_tracker[:end_station] << @exit_station
    deduct(MINIMUM_FARE)
    @entry_station = nil 
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
