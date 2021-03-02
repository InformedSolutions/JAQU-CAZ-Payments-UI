# frozen_string_literal: true

module AddToSession
  def add_transaction_id_to_session(transaction_id)
    encoded_data = RackSessionAccess.encode(transaction_id: transaction_id)
    put_encoded_data_to_session(encoded_data)
  end

  def add_vrn_to_session(vrn: 'CU57ABC', country: 'UK')
    add_vehicle_details_to_session(vrn: vrn, country: country)
  end

  def add_possible_fraud_vrn_to_session(vrn: 'CU57ABC', country: 'Non-UK')
    add_vehicle_details_to_session(vrn: vrn, country: country)
  end

  def add_undetermined_taxi_to_session(vrn: 'CU57ABC', country: 'UK')
    add_vehicle_details_to_session(vrn: vrn, country: country, undetermined_taxi: true)
  end

  def add_details_to_session(details: {}, weekly_possible: false, weekly_charge_today: false, dates: [])
    add_vehicle_details_to_session(
      **compliance_details(details),
      weekly_possible: weekly_possible,
      weekly_charge_today: weekly_charge_today,
      weekly_dates: dates
    )
  end

  def add_full_payment_details(details: {}, weekly: false, confirm_weekly_charge_today: false)
    add_vehicle_details_to_session(
      **compliance_details(details),
      weekly_possible: weekly,
      dates: payment_dates(details, weekly),
      weekly: weekly,
      total_charge: payment_total_charge(details, weekly),
      chargeable_zones: 2,
      second_week_selected: true,
      confirm_weekly_charge_today: confirm_weekly_charge_today
    )
  end

  def add_to_session(data)
    encoded_data = RackSessionAccess.encode(data)
    put_encoded_data_to_session(encoded_data)
  end

  def add_vehicle_details_to_session(data = {})
    encoded_data = RackSessionAccess.encode(vehicle_details: data.stringify_keys)
    put_encoded_data_to_session(encoded_data)
  end

  def assign_second_week_selected(second_week_selected: true)
    encoded_data = RackSessionAccess.encode(second_week_selected: second_week_selected)
    put_encoded_data_to_session(encoded_data)
  end

  private

  def put_encoded_data_to_session(encoded_data)
    put RackSessionAccess.path, params: { data: encoded_data }
  end

  def payment_dates(details, weekly)
    return details[:dates] if details[:dates]

    weekly ? (1..7).map { |day| "2019-11-0#{day}" } : %w[2019-11-01 2019-11-02]
  end

  def payment_total_charge(details, weekly)
    return 50 if weekly

    daily_charge = details[:daily_charge] || 15
    daily_charge * payment_dates(details, weekly).length
  end

  def compliance_details(details)
    {
      vrn: details[:vrn] || 'CU57ABC',
      country: details[:country] || 'UK',
      la_id: details[:la_id] || SecureRandom.uuid,
      la_name: details[:la_name] || 'Taxidiscountcaz',
      daily_charge: details[:daily_charge] || 15,
      undetermined_taxi: details[:undetermined_taxi] || false
    }
  end
end
