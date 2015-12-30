require 'world_object'
require 'world_objects/movement/horizontal'

class Enemy
  include WorldObject
  include WorldObjects::Movement::Horizontal
end
