require 'car'

describe 'Car' do 
	describe 'attributes' do

		before(:example) do
			@car = Car.new #execute before each example, and shoule use instance variables
		end

		it "allows reading and writing for :make" do
			@car.make = 'Test'
			expect(@car.make).to eq('Test')
		end

		it "allows reading and writing for :year" do
			@car.year = 9999
			expect(@car.year).to eq(9999)
		end

		it "allows reading and writing for :color" do
			@car.color = 'foo'
			expect(@car.color).to eq('foo')
		end

		it "allows reading for :wheels" do
			expect(@car.wheels).to eq(4)
		end

		it "allows writing for :doors"
	end

	describe '.color' do
		it "returns an array of color names" do
			c = ['blue', 'black','red','green']
			expect(Car.colors).to match_array(c)
		end
	end

	describe '#full_name' do
		it "returns a string in the expected format" do
			@acura = Car.new(:make => 'Acura', :year => '2005', :color => 'red')
			expect(@acura.full_name).to eq('2005 Acura (red)')
		end

		#context is equal to describe
		context 'when initialized with no arguments' do
			it "returns a string using default values" do
				car = Car.new
				expect(car.full_name).to eq('2007 Volvo (unknown)')
			end
		end
	end
end