require_relative '../../lib/game'
require_relative '../../lib/world_objects/space_ship'

describe Game do
  let(:a_displayer) do
    double(:world_width => 200, :world_height => 100, :world= => true)
  end

  let(:input_handler) do
    double(:get_player_action => nil)
  end

  it 'instantiates a new world' do
    sp = Game.new displayer: a_displayer, input_handler: input_handler
    expect(sp.world).not_to be_nil
  end

  it 'adds a spaceship to the new world' do
    sp = Game.new displayer: a_displayer, input_handler: input_handler
    expect(sp.world.objects.first).to be_a SpaceShip
  end

  it 'instantiates a displayer' do
    sp = Game.new displayer: a_displayer, input_handler: input_handler

    expect(sp.displayer).not_to be_nil
  end
end
