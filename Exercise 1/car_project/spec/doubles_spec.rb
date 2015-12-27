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
end