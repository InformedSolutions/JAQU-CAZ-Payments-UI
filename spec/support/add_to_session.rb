# frozen_string_literal: true

module AddToSession
  def add_vrn_to_session(vrn: 'CU57ABC', country: 'UK')
    add_to_session(vrn: vrn, country: country)
  end

  def add_details_to_session(details: {}, weekly_possible: false)
    add_to_session(
      **compliance_details(details),
      weekly_possible: weekly_possible
    )
  end

  def add_full_payment_details(details: {}, weekly: false)
    add_to_session(
      **compliance_details(details),
      weekly_possible: weekly,
      dates: payment_dates(details, weekly),
      weekly: weekly,
      total_charge: payment_total_charge(details, weekly),
      chargeable_zones: 2
    )
  end

  def add_to_session(data = {})
    encoded_data = RackSessionAccess.encode(vehicle_details: data.stringify_keys)
    put RackSessionAccess.path, params: { data: encoded_data }
  end

  private

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
      la_name: details[:la_name] || 'Leeds',
      daily_charge: details[:daily_charge] || 15
    }
  end
end
