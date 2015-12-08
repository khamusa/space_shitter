require_relative '../../space_shooter.rb'

describe 'the space shooter game initializer' do
  it 'initializes a game' do
    sp = SpaceShooter.new
    expect(sp.game).not_to be_nil
  end
end
