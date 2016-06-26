require 'spec_helper'
require 'world_object'

describe WorldObject do

  let(:dummy_klass) do
    Class.new do
      include WorldObject
    end
  end

  let(:xpos) { 0.333 }
  let(:ypos) { 33.777 }
  let(:an_object) { dummy_klass.new(xpos, ypos) }

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

  describe '#position' do
    it 'returns rounded coordinates to closest number' do
      expect(an_object.position).to eq([0, 34])
    end

    it 'stores a real number internally' do
      an_object.move(0.2, -0.28)
      expect(an_object.position).to eq([1, 33])
    end
  end

  describe '#anchor_x' do
    it 'returns the same value as the x coordinate of #position' do
      expect(an_object.anchor_x).to eq(an_object.position[0])
    end
  end

  describe '#ancor_y' do
    it 'returns the same value as the y coordinate of #position' do
      expect(an_object.anchor_y).to eq(an_object.position[1])
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

  describe '#obj_left_viewport!' do
    let(:an_instance) { an_instance = dummy_klass.new(0,0) }
    it 'is defined' do
      expect { an_instance.obj_left_viewport! }.
        not_to raise_error(NoMethodError)
    end

    it 'accepts a direction parameter' do
      expect { an_instance.obj_left_viewport!(:left) }.
        not_to raise_error(ArgumentError)
    end

    it 'destroys itself by default' do
      expect(an_instance).to receive(:destroy!)
      an_instance.obj_left_viewport!(:left)
    end
  end
end
