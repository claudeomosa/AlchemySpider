defmodule AlchemySpiderTest do
  use ExUnit.Case
  doctest AlchemySpider

  test "greets the world" do
    assert AlchemySpider.hello() == :world
  end
end
