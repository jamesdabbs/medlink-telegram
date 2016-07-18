recorder = ResponseRecorder.new(
  # The error handler doesn't need a reference back to dispatch, but
  # this seems inelegant ...
  error_handler: Handlers::Error.new(nil),
  persist: ->(receipt) { receipt.save! validate: false }
)

callbacks = CallbackRegistry.build(
  show_request_history:    Handlers::ShowRequestHistory,
  show_supply_list:        Handlers::ShowSupplyList,
  show_outstanding_orders: Handlers::OutstandingOrders,
  start_new_order:         Handlers::StartOrder,
  expand_message_history:  Handlers::ExpandMessageHistory,
  resolve_support:         Handlers::ResolveSupport
)

dispatch = Handlers::Dispatch.new(
  handlers: [
    Handlers::Callbacks,
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
  ],
  callbacks: callbacks
)

Medbot = Bot.new(
  dispatch: dispatch,
  recorder: recorder,
  telegram: Bot::Client.build
)
