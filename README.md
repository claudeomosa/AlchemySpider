# AlchemySpider

## UFC Fighter Scraper

This Elixir project uses the Crawly library to scrape UFC fighter details from the UFC website. The scraper takes a fighter's name as input and generates all possible combinations of the names to find the correct URL for the fighter's profile.

### Project Structure

- `scraper.ex`: Defines the `Scraper` module that implements the Crawly spider to scrape fighter details.

### Prerequisites

- Elixir
- Mix
- Crawly
- Floki

## Installation

1. **Clone the Repository**
   
   ```bash
     git clone git@github.com:claudeomosa/AlchemySpider.git
   ```
   
2. **Install Dependencies**

   ```bash
     mix deps.get
   ```

3. **Run the Crawler**
   
   With the following command run the crawler with a fighters name, i.e 
   ```bash
     iex -S mix run -e "Crawly.Engine.start_spider(Scraper, crawl_id: 'adesanya israel')"
   ```
   Demo:
   

https://github.com/claudeomosa/AlchemySpider/assets/56362108/015b9a0a-6263-4ebf-b194-3bdf95022f9e

