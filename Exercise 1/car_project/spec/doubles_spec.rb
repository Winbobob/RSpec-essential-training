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

	describe 'with message expectations' do

		let(:chant){double('Chant')}
		let(:dbl){double('Multi-step Process')}

		it 'expects a call and allows a response' do
			expect(chant).to receive(:hey!).and_return('Ho!')
			chant.hey!
		end

		it 'does not matter with order' do 
			expect(dbl).to receive(:step1)
			expect(dbl).to receive(:step2)

			dbl.step2
			dbl.step1
		end

		it 'works with #ordered when order matters' do
			expect(dbl).to receive(:step1).ordered
			expect(dbl).to receive(:step2).ordered

			dbl.step1
			dbl.step2
		end
	end

	describe 'with arguments will match' do

		let(:dbl){double('Customer List')}
		it 'expects arguments will match' do
			expect(dbl).to receive(:sort).with('name')
			dbl.sort('name')
		end

		it 'passes when any arguments are allowed' do
			#the default if you don't use #with
			expect(dbl).to receive(:sort).with(any_args)
			dbl.sort('2016', '01', '01')
		end

		it 'allows contraining only some arguments' do
			expect(dbl).to receive(:sort).with('2016', anything, anything)
			dbl.sort('2016', 'year of', 'Monkey')
		end

		it 'allows using other matchers' do
			expect(dbl).to receive(:sort).with(a_string_starting_with('A'), an_object_eq_to('asc') | an_object_eq_to('desc'), boolean)
			dbl.sort('Alex', 'desc', true)
		end
	end

	describe 'with spying abilities' do


		before(:each) do
			@dbl = spy('Chant')
			allow(@dbl).to receive(:hey!).and_return('Ho!')
		end

		it 'can expect a call after it is received' do
			@dbl.hey!
			expect(@dbl).to have_received(:hey!)
		end

		it 'can use message contraints' do
			@dbl.hey!
			@dbl.hey!
			expect(@dbl).to have_received(:hey!).twice
			@dbl.hey!
			expect(@dbl).to have_received(:hey!).with(no_args).exactly(3).times
		end

		it 'can expect any message already sent to a declared spy' do
			customer = spy('Customer')
			#Notice that we don't stub :send_invoice
			#allow(customer).to receive(:send_invoice)
			customer.send_invoice
			expect(customer).to have_received(:send_invoice)
		end

		it 'can expect only allowed messages on partia; doubles' do
			class Customer
				def send_invoice
					true
				end
			end
			customer = Customer.new
			#Must stub :send_invoice to start spying
			allow(customer).to receive(:send_invoice)
			customer.send_invoice
			expect(customer).to have_received(:send_invoice)
		end

		describe 'using let and a before hook' do
			let(:order) do
				spy('Order', :process_line_items => nil,
							 :charge_credit_card => true,
							 :send_confirmation_email => true)
			end

			before(:each) do
				order.process_line_items
				order.charge_credit_card
				order.send_confirmation_email
			end

			it 'calls #process_line_items on the order' do
				expect(order).to have_received(:process_line_items)
			end

			it 'calls #charge_credit_card' do
				expect(order).to have_received(:charge_credit_card)
			end

			it 'calls #send_confirmation_email' do
				expect(order).to have_received(:send_confirmation_email)
			end
		end
	end
end