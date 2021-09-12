defmodule GrainFather.BrewTest do
  use ExUnit.Case, async: true
  alias GrainFather.Brew

  describe "parsing metadata out of notes" do
    test "tap_number is nil if not note" do
      assert Brew.parse_tap_number(nil) == nil
    end

    test "no matching string in notes" do
      assert Brew.parse_tap_number("this is some notes\nwithout a tap_number") == nil
    end

    test "should set it equal to the value in the note" do
      assert GrainFather.Brew.parse_tap_number(
               "this is some notes\nwith a [tap_number: 22]some other info]"
             ) == "22"
    end
  end
end
