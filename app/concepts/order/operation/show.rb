module Order::Operation
  class Show < Trailblazer::Operation

    step :is_valid_order?
    step :get_order_amount
    step :is_self_pickup
    step :update_order_amount
    fail :set_errors
    pass :build_response

    def is_valid_order?(ctx, params:, **)
      ctx[:order] = Order.where(id: params[:id]).first
    end

    def get_order_amount(ctx, order:,  **)
      ctx[:bill] = OrderItem.select("sum(items.price) as total")
                            .joins(:item)
        .where(order_id: order.id).first.as_json
    end

    def is_self_pickup(ctx, order:, bill:, **)
      bill unless order.self_pickup
      
      bill["total"] += bill["total"]*0.05
    end

    def update_order_amount(ctx, bill:, order:,  **)
      order.update(price: bill["total"])
    end

    def set_errors(ctx, **)
      ctx[:errors] = 'Invalid Order'
    end

    def build_response(ctx, order:, bill:,  **)
      ctx[:response] = { order: order, total: bill }
    end
  end
end
