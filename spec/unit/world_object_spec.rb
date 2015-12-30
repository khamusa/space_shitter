require 'world_object'

describe WorldObject do

  let(:dummy_klass) { Class.new { include WorldObject }}

  describe "#initialize" do
    it 'accepts 3 parameters' do
      expect { dummy_klass.new(0, 0, {}) }.not_to raise_error
    end

    it 'has an optional third parameter' do
      expect { dummy_klass.new(0, 0) }.not_to raise_error
    end

    it 'saves the x position as anchor_x' do
      an_object = dummy_klass.new(22, 0)
      expect(an_object.anchor_x).to eq(22)
    end

    it 'saves the y position as anchor_y' do
      an_object = dummy_klass.new(0, 33)
      expect(an_object.anchor_y).to eq(33)
    end

    it 'saves the char map supplied in the options' do
      an_object = dummy_klass.new(0, 0, char_map: 123)
      expect(an_object.char_map).to eq(123)
    end

    it 'sets a default char map as the X char' do
      an_object = dummy_klass.new(0, 33)
      expect(an_object.char_map).to eq( { [0,0] => "X" })
    end
  end

  describe 'anchor_x and anchor_y reader methods' do
    it 'returns coordinates rounded to the closest number' do
      an_object = dummy_klass.new(0.333, 33.777)
      expect(an_object.anchor_x).to eq(0)
      expect(an_object.anchor_y).to eq(34)
    end

    it 'stores a real number internally' do
      an_object = dummy_klass.new(0.5, 1.5)
      x = an_object.instance_variable_get(:@anchor_x)
      expect(x).to eq(0.5)
      y = an_object.instance_variable_get(:@anchor_y)
      expect(y).to eq(1.5)
    end
  end

  describe '#move' do
    it 'moves the object' do
      an_object = dummy_klass.new(0, 0)
      an_object.move(2, 4)

      expect(an_object.anchor_x).to eq 2
      expect(an_object.anchor_y).to eq 4
    end

    it 'accepts any real number as moving parameter' do
      an_object = dummy_klass.new(0.5, 0.8)
      an_object.move(1.5, 3.2)

      expect(an_object.anchor_x).to eq 2
      expect(an_object.anchor_y).to eq 4
    end
  end
end
