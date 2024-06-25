defmodule Scraper do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "https://www.ufc.com/athlete"

  @impl Crawly.Spider
  def init(fighter) do
    [crawl_id: name] = fighter
    names = String.split(to_string(name), " ")
    combinations = generate_combinations(names)

    # Generate start URLs for all combinations
    start_urls = Enum.map(combinations, fn combo -> "https://www.ufc.com/athlete/#{combo}" end)
    IO.puts("Start URLs:\n#{Enum.join(start_urls, "\n")}\n")
    [start_urls: start_urls]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # Parse response body to document
    case response.status_code do
      200 -> parse_fighter(response)
      _ ->
        IO.inspect("Error, status code: #{response.status_code}")
        %Crawly.ParsedItem{items: [], requests: []}
    end
  end

  defp parse_fighter(response) do
    {:ok, document} = Floki.parse_document(response.body)

    fighter =
      document
      |> Floki.find(".hero-profile__info")
      |> Enum.map(&extract_fighter_details/1)

      IO.inspect(fighter, label: "Fighter")
    %Crawly.ParsedItem{items: fighter, requests: []}
  end

  defp extract_fighter_details(fighter_elem) do
    fighter_name = Floki.find(fighter_elem, ".hero-profile__name") |> Floki.text()
    fighter_nickname = Floki.find(fighter_elem, ".hero-profile__nickname") |> Floki.text()
    fighter_division = Floki.find(fighter_elem, ".hero-profile__division-title") |> Floki.text()

    |> String.trim()
    |> String.replace("\"", "")
    |> String.replace("  ", " ")
    fighter_record = Floki.find(fighter_elem, ".hero-profile__division-body") |> Floki.text()
    fighter_stats_elem = Floki.find(fighter_elem, ".hero-profile__stats .hero-profile__stat")
    fighter_stats = fighter_stats_elem
    |> Enum.map(&extract_stat/1)
    |> Enum.into(%{})

    %{
      Name: fighter_name,
      Nickname: fighter_nickname,
      Record: fighter_record,
      Division: fighter_division,
      Stats: fighter_stats
    }
  end

  defp extract_stat(stat_elem) do
    stat_name = Floki.find(stat_elem, ".hero-profile__stat-text") |> Floki.text()
    stat_value = Floki.find(stat_elem, ".hero-profile__stat-numb") |> Floki.text()

    {stat_name, stat_value}
  end

  defp generate_combinations(names) do
    base_combinations =
      names
      |> Enum.reduce([], fn name, acc -> acc ++ Enum.map(acc, &(&1 <> "-" <> name)) ++ [name] end)

    reversed_combinations =
      names
      |> Enum.reverse()
      |> Enum.reduce([], fn name, acc -> acc ++ Enum.map(acc, &(&1 <> "-" <> name)) ++ [name] end)

    base_combinations ++ reversed_combinations
  end
end
