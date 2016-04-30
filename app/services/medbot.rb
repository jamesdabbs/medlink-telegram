Medbot = Bot.new(
  error_handler: Handlers::Error,
  handlers: [
    Handlers::Callbacks,
    Handlers::Start,
    Handlers::Settings,
    Handlers::RegisterContact,
    Handlers::AskForContact,
    Handlers::Help,

    Handlers::ShowSupplyList,
    Handlers::OutstandingOrders,

    # Multi-message state-based order flow
    Handlers::StartOrder,
    Handlers::ContinueOrder,
    Handlers::FinishOrder,

    # All-in-one order handler
    Handlers::TakeOrder,

    Handlers::Fallback
  ]
)
