require 'car'

describe 'Car' do 
	describe 'attributes' do

		#use "subject" instead of "let" if variable is subject of example
		#subject {Car.new}

		#"let" is better than "before" for setting up instance variables (lazy exectuation)
		let(:car) {Car.new}

		#before(:example) do
		#	@car = Car.new 
		#execute before each example,
		#SHOULD use INSTANCE variables
		#end

		it "allows reading and writing for :make" do
			car.make = 'Test'
			expect(car.make).to eq('Test')
		end

		it "allows reading and writing for :year" do
			car.year = 9999
			expect(car.year).to eq(9999)
		end

		it "allows reading and writing for :color" do
			car.color = 'foo'
			expect(car.color).to eq('foo')
		end

		it "allows reading for :wheels" do
			expect(car.wheels).to eq(4)
		end

		it "allows writing and writing for :doors" do
			car.doors = 1
			expect(car.doors).to eq(1)
		end
	end

	describe '#initialize' do

		let(:car){Car.new}
		let(:car1){Car.new({:doors => 2})}

		it 'defaults to 4 doors' do
			expect(car.doors).to eq(4)
		end

		it 'accepts an option for doors' do
			expect(car1.doors).to eq(2)
		end

		it 'defaults to 4 if option is neither 2 or 4' do
			door_counts = []
			[0,1,3,5,6].each do |n|
				car = Car.new({:doors => n})
				door_counts << car.doors
			end
			expect(door_counts).to all( eq(4) )
		end
	end

	describe '.color' do

		let(:colors) {['blue', 'black','red','green']}
		it "returns an array of color names" do
			expect(Car.colors).to match_array(colors)
		end
	end

	describe '#full_name' do

		let(:acura) {Car.new(:make => 'Acura', :year => '2005', :color => 'red')}
		let(:car) {Car.new}

		it "returns a string in the expected format" do
			expect(acura.full_name).to eq('2005 Acura (red)')
		end

		#context is equal to describe
		context 'when initialized with no arguments' do
			it "returns a string using default values" do
				expect(car.full_name).to eq('2007 Volvo (unknown)')
			end
		end
	end

	describe '#coupe?' do

		let(:car){Car.new({:doors => 2})}
		let(:car1){Car.new({:doors => 4})}

		it 'returns true if it has 2 doors' do
			expect(car.coupe?).to be(true)
		end

		it 'returns false if it does not have 2 doors' do
			expect(car1.coupe?).to be(false)
		end

	end

	describe '#sedan?' do

		let(:car){Car.new({:doors => 4})}
		let(:car1){Car.new({:doors => 2})}

		it 'returns true if it has 4 doors' do
			expect(car.sedan?).to be(true)
		end

		it 'returns false if it does not have 4 doors' do
			expect(car1.sedan?).to be(false)
		end
	end
end