describe 'Doubles' do

	let(:dbl){double('Chant')}
	let(:dbl2){double('Person')}
	let(:dbl3){double('Person', :full_name => 'Eva X', :initials => 'EX')}
	let(:die){double('Die')}

	it 'allows stubbing methods' do
		allow(dbl).to receive(:hey!)  #stubbing method
		expect(dbl).to respond_to(:hey!)
	end

	it 'allows stubbing a response with a block' do
		#When I say 'Hey!', you say 'Ho!'
		allow(dbl).to receive(:hey!){'Ho!'}
		expect(dbl.hey!).to eq('Ho!')
	end

	it 'allows stubbing responses with #and_return' do
		#This is my perferred syntax
		#When I say 'Hey!', you say 'Ho!'
		allow(dbl).to receive(:hey!).and_return('Ho!')
		expect(dbl.hey!).to eq('Ho!')
	end

	it 'allows stubbing multiple methods with hash syntax' do
		#Note this uses #receive_messages, not #receive
		allow(dbl2).to receive_messages(:full_name => 'Eva X', :initials => 'EX')
		expect(dbl2.full_name).to eq('Eva X')
		expect(dbl2.initials).to eq('EX')
	end

	it 'allows stubbing methods with a hash argument to #double' do
		expect(dbl3.full_name).to eq('Eva X')
		expect(dbl3.initials).to eq('EX')
	end

	it 'allows stubbing multiple repsonses with #and_return' do
		allow(die).to receive(:roll).and_return(1,5,2,6)
		expect(die.roll).to eq(1)
		expect(die.roll).to eq(5)
		expect(die.roll).to eq(2)
		expect(die.roll).to eq(6)
		expect(die.roll).to eq(6) #continues returning last value
	end

	describe 'with partial test doubles' do

		before(:all) do
			class Customer
				attr_accessor :name
				def self.find
					#database lookup, returns one object
				end

				def self.all
					#database lookup, returns array of objects
				end
			end
		end

		let(:time_2016){Time.new(2016, 1, 1, 0, 0, 0)}
		it 'allows stubbing instance methods on Ruby classes' do
			allow(time_2016).to receive(:year).and_return(1992)

			expect(time_2016.to_s).to eq('2016-01-01 00:00:00 -0500')
			expect(time_2016.year).to eq(1992)
		end

		it 'allows stubbing instance methods on custom classes' do
			class SuperHero
				attr_accessor :name
			end

			hero = SuperHero.new
			hero.name = 'Superman'
			allow(hero).to receive(:name).and_return('Mark Watney')
			expect(hero.name).to eq('Mark Watney')
		end

		it 'allows stubbing class methods on Ruby classes' do
			allow(Time).to receive(:now).and_return(time_2016)
			
			expect(Time.now).to eq(time_2016)
			expect(Time.now.to_s).to eq('2016-01-01 00:00:00 -0500')
			expect(Time.now.year).to eq(2016)
		end

		it 'allows stubbing database calls a mock object' do
			dbl = double('Mock Customer')
			allow(dbl).to receive(:name).and_return('Alex')
			allow(Customer).to receive(:find).and_return(dbl)

			customer = Customer.find
			expect(customer.name).to eq('Alex')
		end

		it 'allows stubbing database calls with many mock objects' do
			c1 = double('First Customer', :name => 'Alex')
			c2 = double('Second Customer', :name => 'Ann')

			allow(Customer).to receive(:all).and_return([c1,c2])

			customers = Customer.all
			expect(customers[1].name).to eq('Ann')
		end
	end
end