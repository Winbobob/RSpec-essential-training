require 'car'

descirbe 'Car' do 
	descirbe 'attributes' do
		it "allows reading and writing for :make" do
			car = Car.new
			car.make = 'Test'
			expect(car.make).to eq('Test')
		end

		it "allows reading and writing for :year" do
			car = Car.new
			car.year = 9999
			expect.(car.year).to eq(9999)
		end

		it "allows reading and writing for :color" do
			car = Car.new
			car.color = 'foo'
			expect(car.color).to eq('foo')
		end

		it "allows reading for :wheels" do
			car = Car.new
			expect(car.color).to eq(4)
		end
	end

	descirbe '.color' do
	end

	descirbe '#fullname' do
	end
end