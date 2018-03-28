require 'oystercard'

describe Oystercard do

  let(:station) { double('station', :station_name => 'Aldgate') }

  
  before(:each) do
    @topped_up_card = described_class.new
    @topped_up_card.top_up 10
    @touched_in_card = described_class.new
    @touched_in_card.top_up 10 
    @touched_in_card.touch_in(station)
  end


  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
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
            expect { @topped_up_card.touch_in(station) }.to change{ @topped_up_card.in_journey? }.from(false).to(true)
          end

          it "throws an error if the balance is less than #{Oystercard::MINIMUM_AMOUNT}" do
            expect { subject.touch_in(station) }.to raise_error "Insufficient funds"
          end

          it 'can track your journey' do
             subject.journey_tracker = [station]
            expect(subject.journey_tracker).to contain_exactly(station)
          end 
        end

        describe '#touch_out' do
          it 'can touch out' do
            expect { @touched_in_card.touch_out }.to change{ @touched_in_card.in_journey? }.from(true).to(false)
          end

          it 'deducts the correct fare' do
            expect { @touched_in_card.touch_out }.to change{ @touched_in_card.balance }.by -Oystercard::MINIMUM_FARE
          end    
        end
end
