dispatch = Handlers::Dispatch.build(
  callbacks: {
    show_request_history:    Handlers::ShowRequestHistory,
    show_supply_list:        Handlers::ShowSupplyList,
    show_outstanding_orders: Handlers::OutstandingOrders,
    start_new_order:         Handlers::StartOrder,
    expand_message_history:  Handlers::ExpandMessageHistory,
    resolve_support:         Handlers::ResolveSupport,
    response_created:        Handlers::ResponseCreated,
    check_delivery:          Handlers::CheckDelivery
  },
  handlers: [
    Handlers::Start,
    Handlers::Settings,
    Handlers::RegisterContact,
    Handlers::AskForContact,
    Handlers::Help,
    Handlers::PageSupport,

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

recorder = ResponseRecorder.new(
  error_handler: Handlers::Error.new(dispatch),
  persist: ->(receipt) { receipt.save! validate: false }
)

Medbot = Bot.new(
  dispatch: dispatch,
  recorder: recorder,
  medlink:  Medlink::Client.new(app_token: Figaro.env.medlink_token!),
  telegram: Bot::Client.build
)
