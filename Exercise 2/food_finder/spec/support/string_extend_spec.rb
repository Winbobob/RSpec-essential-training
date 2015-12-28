describe 'String' do

  describe "#titleize" do

    let(:str){String.new('zhewei is hard-working')}
    let(:str1){String.new('zhewei')}
    let(:str2){String.new('ZHEWEI IS HARD-WORKING')}
    let(:str3){String.new('It is a nice day today!')}
    let(:str4){String.new('yOUnG AnD bEAuTiFUl')}

    it "capitalizes each word in a string" do
      expect(str.titleize).to eq('Zhewei Is Hard-working')
    end
    
    it "works with single-word strings" do
      expect(str1.titleize).to eq('Zhewei')
      expect(''.titleize).to eq('')
      expect(' '.titleize).to eq('')
    end
    
    it "capitalizes all uppercase strings" do
      expect(str2.titleize).to eq('Zhewei Is Hard-working')
    end
    
    it "capitalizes mixed-case strings" do
      expect(str3.titleize).to eq('It Is A Nice Day Today!')
      expect(str4.titleize).to eq('Young And Beautiful')
    end
  end
  
  describe '#blank?' do

    it "returns true if string is empty" do
      expect('').to be_blank
    end

    it "returns true if string contains only spaces" do
      expect(' ').to be_blank
      expect('         ').to be_blank
    end

    it "returns true if string contains only tabs" do
    # Get a tab using a double-quoted string with \t
    # example: "\t\t\t"
      expect("\t").to be_blank
      expect("\t\t\t\t").to be_blank
    end

    it "returns true if string contains only spaces and tabs" do
      expect("\t ").to be_blank
      expect("\t \t \t \t   \t").to be_blank
    end
    
    it "returns false if string contains a letter" do
      expect('a').not_to be_blank
      expect('a    a').not_to be_blank
      expect('     a').not_to be_blank
      expect("\ta").not_to be_blank
      expect("\t  \t  \t  a").not_to be_blank
    end

    it "returns false if string contains a number" do
      expect('2').not_to be_blank
      expect('2    2').not_to be_blank
      expect('     2').not_to be_blank
      expect("\t2").not_to be_blank
      expect("\t  \t  \t  2").not_to be_blank
    end
    
  end
  
end
