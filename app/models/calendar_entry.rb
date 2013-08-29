class CalendarEntry
  def event_id
    @event_id
  end

  def start_time
    @start_time
  end

  def event_id=(event_id)
    @event_id = event_id
  end


  def start_time=(start_time)
    @start_time = start_time
  end

  def initialize(start_time, event_id)
    @start_time = start_time
    @event_id = event_id
  end

end
