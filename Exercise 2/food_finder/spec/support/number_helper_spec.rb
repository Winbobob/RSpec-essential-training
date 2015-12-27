# encoding: UTF-8

describe 'NumberHelper' do

  include NumberHelper
  
  describe '#number_to_currency' do
    
    context 'using default values' do
      
      it "correctly formats an integer" do
        expect(number_to_currency(2)).to eq('$2.00')
        expect(number_to_currency(2, {:unit => '￥'})).to eq('￥2.00')
        expect(number_to_currency(2000, {:precision => 3})).to eq('$2,000.000')
        expect(number_to_currency(2000, {:delimiter => '?'})).to eq('$2?000.00')
        expect(number_to_currency(2000, {:separator => '*', :precision => 3})).to eq('$2,000*000')
        expect(number_to_currency(-1000000)).to eq('$-1,000,000.00')
        expect(number_to_currency(0)).to eq('$0.00')
        expect(number_to_currency(000)).to eq('$0.00')
        expect(number_to_currency(001)).to eq('$1.00')
      end

      it "correctly formats a float" do
        expect(number_to_currency(2.13)).to eq('$2.10')
        expect(number_to_currency(2.13, {:unit => '￥'})).to eq('￥2.10')
        expect(number_to_currency(2.13, {:precision => 4})).to eq('$2.1300')
        expect(number_to_currency(2016.13, {:delimiter => '?'})).to eq('$2?016.10')
        expect(number_to_currency(2016.13, {:separator => '*'})).to eq('$2,016*10')
        expect(number_to_currency(2.1364)).to eq('$2.10')
        expect(number_to_currency(0.000)).to eq('$0.00')
      end

      it "correctly formats a string" do
        expect(number_to_currency('alex')).to eq('$a,lex.00')
        expect(number_to_currency('aa', {:unit => '￥'})).to eq('￥aa.00')
        expect(number_to_currency('aa', {:precision => 3})).to eq('$aa.000')
        expect(number_to_currency('aabbcc', {:delimiter => '?'})).to eq('$aab?bcc.00')
        expect(number_to_currency('aabbcc', {:separator => '*'})).to eq('$aab,bcc*00')
        expect(number_to_currency('    ')).to eq('$ ,   .00')
        expect(number_to_currency(' ')).to eq('$ .00')
        expect{number_to_currency('')}.to raise_error
      end
      
      it "uses delimiters for very large numbers" do
        expect(number_to_currency(1000000000)).to eq('$1,000,000,000.00')
      end

      it "does not have delimiters for small numbers" do
        expect(number_to_currency(1)).to eq('$1.00')
      end
    end
    
    context 'using custom options' do
      
      it 'allows changing the :unit' do
        expect(number_to_currency(3.14, {:unit => '!'})).to eq('!3.10')
        expect(number_to_currency(2, {:unit => '@'})).to eq('@2.00')
        expect(number_to_currency('abc', {:unit => '*'})).to eq('*abc.00')
      end

      it 'allows changing the :precision' do
        expect(number_to_currency(2, {:precision => 1})).to eq('$2.0')
        expect(number_to_currency(12.34, {:precision => 4})).to eq('$12.3400')
        expect(number_to_currency('abc', {:precision => 5})).to eq('$abc.00000')
      end
      
      it 'omits the separator if :precision is 0' do
        expect(number_to_currency(2, {:precision => 0})).to eq('$2')
        expect(number_to_currency(2.13, {:precision => 0})).to eq('$2')
        expect(number_to_currency('abc', {:precision => 0})).to eq('$abc')
      end
      
      it 'allows changing the :delimiter' do
        expect(number_to_currency(2000, {:delimiter => '~'})).to eq('$2~000.00')
        expect(number_to_currency(1234.12, {:delimiter => '@'})).to eq('$1@234.10')
        expect(number_to_currency('abcd', {:delimiter => '^'})).to eq('$a^bcd.00')
      end
      
      it 'allows changing the :separator' do
        expect(number_to_currency(2000, {:separator => '~'})).to eq('$2,000~00')
        expect(number_to_currency(1234.12, {:separator => '@'})).to eq('$1,234@10')
        expect(number_to_currency('abcd', {:separator => 5.to_s})).to eq('$a,bcd500')
      end
            
      it 'correctly formats using multiple options' do
        expect(number_to_currency(1234.578, {:unit => '￥', :precision => 3, :delimiter => '@', :separator => '%'})).to eq('￥1@234%570')
      end
    end
  end
end
