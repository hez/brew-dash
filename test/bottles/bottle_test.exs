defmodule BrewDash.Bottles.BottleTest do
  use BrewDash.DataCase, async: true
  import BrewDash.Factory
  alias BrewDash.Bottles.Bottle

  describe "remove/1" do
    test "with 1 in quantity it gets marked as drunk" do
      bottle = insert(:bottle)
      Bottle.remove(bottle)
      refute is_nil(Bottle.get!(bottle.id).drunk_at)
    end

    test "with 1 in quantity it removes the location" do
      bottle = insert(:bottle)
      Bottle.remove(bottle)
      assert is_nil(Bottle.get!(bottle.id).location)
    end

    test "with more then 1 in quantity, inventory gets subtracted" do
      original_quantity = 10
      bottle = insert(:bottle, quantity: original_quantity)
      {:ok, new_bottle} = Bottle.remove(bottle)
      assert Bottle.get!(bottle.id).quantity == original_quantity - 1
      assert new_bottle.quantity == 1
    end

    test "with more then 1 in quantity, a new entry gets created" do
      original_quantity = 10
      bottle = insert(:bottle, quantity: original_quantity)
      {:ok, new_bottle} = Bottle.remove(bottle)
      assert new_bottle.id != bottle.id
      assert bottle.company == new_bottle.company
      assert bottle.name == new_bottle.name
      assert bottle.vintage == new_bottle.vintage
    end

    test "with more then 1 in quantity, drunk at is set on new bottle and not changed for original" do
      original_quantity = 10
      bottle = insert(:bottle, quantity: original_quantity)
      {:ok, new_bottle} = Bottle.remove(bottle)
      refute is_nil(new_bottle.drunk_at)
      assert is_nil(bottle.drunk_at)
    end

    test "errors when quantity is less then asked removal number" do
      original_quantity = 10
      bottle = insert(:bottle, quantity: original_quantity)

      assert {:error, "Error asked to remove more then is avaible"} ==
               Bottle.remove(bottle, original_quantity + 1)
    end
  end
end
