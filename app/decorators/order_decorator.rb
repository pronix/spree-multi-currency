Order.class_eval do
  extend MultiCurrency
  multi_currency :item_total, :total,
                 :rate_at_date => lambda{ |t| t.created_at },
                 :only_read => true


  def update_totals
    # update_adjustments
    self.payment_total = payments.completed.map(&:amount).sum
    self.item_total = line_items.map(&:raw_amount).sum
    self.adjustment_total = adjustments.map(&:amount).sum
    self.total = read_attribute(:item_total) + adjustment_total
  end


  def update!
    update_totals
    update_payment_state

    # give each of the shipments a chance to update themselves
    shipments.each { |shipment| shipment.update!(self) }#(&:update!)
    update_shipment_state
    update_adjustments
    # update totals a second time in case updated adjustments have an effect on the total
    update_totals
    update_attributes_without_callbacks({
      :payment_state => payment_state,
      :shipment_state => shipment_state,
      :item_total => read_attribute(:item_total),
      :adjustment_total => adjustment_total,
      :payment_total => payment_total,
      :total => read_attribute(:total)
    })

    #ensure checkout payment always matches order total
    if payment and payment.checkout? and payment.amount != total
      payment.update_attributes_without_callbacks(:amount => total)
    end

    update_hooks.each { |hook| self.send hook }
  end


end
