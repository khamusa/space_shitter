require 'spec_helper'
require_relative '../../lib/game'
require_relative '../../lib/world_objects/space_ship'

describe Game do
  let(:a_displayer) do
    double(:world_width => 200, :world_height => 100, :world= => true)
  end

  let(:input_handler) do
    double(:get_player_action => nil)
  end

  let(:game) { Game.new displayer: a_displayer, input_handler: input_handler }
  let(:loop_count) { 5 }

  it 'instantiates a new world' do
    expect(game.world).not_to be_nil
  end

  it 'adds a spaceship to the new world' do
    expect(game.world.objects.first).to be_a SpaceShip
  end

  it 'instantiates a displayer' do
    expect(game.displayer).not_to be_nil
  end

  describe '#start' do
    before do
      @loop_count = loop_count
      allow(a_displayer).to receive(:say_bye)
      allow(game).to receive(:main_loop) do
        @loop_count -= 1
        raise Interrupt.new('You lose!') if @loop_count == 0
      end
    end

    it 'runs the main loop until an interrupt is fired' do
      expect(game).to receive(:main_loop).exactly(loop_count).times
      game.start
    end

    context 'handling an interrupt' do
      it 'asks the displayer to say bye' do
        expect(a_displayer).to receive(:say_bye)
        game.start
      end
    end
  end

  describe '#main_loop' do
    before do
      allow(a_displayer).to receive(:game_tick)
      allow(game.world).to receive(:game_tick)
      allow(input_handler).to receive(:get_player_actions).and_return([])
    end

    subject { game.main_loop }

    it 'triggers a game tick for the displayer' do
      expect(a_displayer).to receive(:game_tick).once
      game.send(:main_loop)
    end

    it 'triggers a game tick for the world object' do
      expect(game.world).to receive(:game_tick).once
      game.send(:main_loop)
    end

    it 'handles player actions' do
      expect(game).to receive(:process_user_action)
      game.send(:main_loop)
    end

    it 'sleeps' do
      expect(game).to receive(:sleep)
      game.send(:main_loop)
    end
  end
end
