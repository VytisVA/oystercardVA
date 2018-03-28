require 'oystercard'

describe Oystercard do

  let(:entry_station) { double('station', :station_name => 'Aldgate', :name => 'Aldgate') }
  let(:exit_station) { double('station', :station_name => 'Whitechapel', :name => 'Whitechapel') }
  
  before(:each) do
    @topped_up_card = described_class.new
    @topped_up_card.top_up 10
    @touched_in_card = described_class.new
    @touched_in_card.top_up 10 

  end


  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  it 'has an empty list of journeys' do
    expect(subject.journey_tracker[:start_station]).to be_empty
    expect(subject.journey_tracker[:end_station]).to be_empty
  end


  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

    describe '#deduct' do
      # it { is_expected.to respond_to(:deduct).with(1).argument }

      it 'deducts an amount from the balance' do
        subject.top_up(20)
        expect{ subject.send(:deduct, 3) }.to change{ subject.balance }.by -3
      end
    end

      describe '#in_journey?' do
        it 'is initially not in journey' do
          expect(subject).not_to be_in_journey

        end
      end

        describe '#touch_in' do
          it 'can touch in' do
            station = Station.new

            expect { @topped_up_card.touch_in(station) }.to change{ @topped_up_card.in_journey? }.from(false).to(true)
          end

          it "throws an error if the balance is less than #{Oystercard::MINIMUM_AMOUNT}" do
            station = Station.new
            expect { subject.touch_in(station) }.to raise_error "Insufficient funds"
          end

          it 'can track your journey' do
             subject.journey_tracker = [entry_station]
            expect(subject.journey_tracker).to contain_exactly(entry_station)
          end 
        end

        describe '#touch_out' do
          it 'can touch out' do
            station = Station.new
            @touched_in_card.touch_in(station)
            expect { @touched_in_card.touch_out(station) }.to change{ @touched_in_card.in_journey? }.from(true).to(false)  
          end

          it 'adds entry to have one journey' do
            subject.top_up(10)
            subject.touch_in(entry_station)
            expect(subject.journey_tracker[:start_station]).to contain_exactly(entry_station.station_name)
          end  

          it 'add exit stations to have one journey' do
            subject.top_up(10)
            subject.touch_in(entry_station) 
            subject.touch_out(exit_station)
            expect(subject.journey_tracker[:end_station]).to contain_exactly(exit_station.station_name)
          end  

          #let(:exit_station) { double ('station', :station_name => "Whitechapel") }

          it 'deducts the correct fare' do
            station = Station.new
            expect { @touched_in_card.touch_out(station) }.to change{ @touched_in_card.balance }.by -Oystercard::MINIMUM_FARE
          end    
        end
end
