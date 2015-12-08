require_relative '../../lib/game'
require_relative '../../lib/space_ship'

describe Game do

  it 'instantiates a new world' do
    sp = Game.new displayer: double
    expect(sp.world).not_to be_nil
  end

  it 'adds a spaceship to the new world' do
    sp = Game.new displayer: double
    expect(sp.world.objects.first).to be_a SpaceShip
  end

  it 'instantiates a displayer' do
    sp = Game.new displayer: double

    expect(sp.displayer).not_to be_nil
  end
end
