import Config

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  closespider_itemcount: 100,

  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    Crawly.Middlewares.RobotsTxt,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    # An item is expected to have all fields defined in the fields list
    {Crawly.Pipelines.Validate, fields: [:url]},

    # Use the following field as an item uniq identifier (pipeline) drops
    # items with the same urls
    {Crawly.Pipelines.DuplicatesFilter, item_id: :url},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "jl", folder: "/tmp"}
  ]
