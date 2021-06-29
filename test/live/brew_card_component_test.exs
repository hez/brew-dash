defmodule BrewDashWeb.Live.BrewCardComponenttest do
  use ExUnit.Case, async: true
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe
  alias BrewDashWeb.BrewCardComponent

  describe "card component display_name/1 with recipe and brew" do
    setup do
      {:ok, brew: %Brew{recipe: %Recipe{name: "test"}, name: "test", batch_number: "0"}}
    end

    test "same name, brew name isn't shown when it matches recipe name", %{brew: brew} do
      assert BrewCardComponent.display_name(brew) == "test (#0)"
    end

    test "same name, brew name isn't displayed and batch number being nil", %{brew: brew} do
      brew = %{brew | batch_number: nil}
      assert BrewCardComponent.display_name(brew) == "test"
    end

    test "different names, brew name is shown when it doesn't matche recipe name", %{brew: brew} do
      brew = %{brew | name: "testing recipe"}
      assert BrewCardComponent.display_name(brew) == "test - testing recipe (#0)"
    end

    test "different names, brew name is displayed and batch number being nil", %{brew: brew} do
      brew = %{brew | name: "testing recipe", batch_number: nil}
      assert BrewCardComponent.display_name(brew) == "test - testing recipe"
    end
  end

  describe "card component display_name/1 without recipe" do
    setup do
      {:ok, brew: %Brew{recipe: nil, name: "test brew", batch_number: "0"}}
    end

    test "only brew name is display, it handles recipe being nil", %{brew: brew} do
      assert BrewCardComponent.display_name(brew) == "test brew (#0)"
    end

    test "only brew name is display, it handles recipe and batch number being nil", %{brew: brew} do
      brew = %{brew | batch_number: nil}
      assert BrewCardComponent.display_name(brew) == "test brew"
    end
  end
end
