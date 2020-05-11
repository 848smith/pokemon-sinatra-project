class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :element_type
      t.integer :cp
      t.integer :user_id
      t.string :fast_move
      t.string :power_move
      t.integer :attack
      t.integer :defense
      t.integer :hp
    end
  end
end
