module SweetDate
class Event
    # Returns the list of events
    # params:
    
    # return example:
    # {"events":[{"calendar_id":"c1","id":"e1","name":"Team Sync"}],"status":"ok"}
    # error example:
    # {"message":"unauthorized","status":"error"}
    def self.list(params)
      # TODO: implement EVENTS.LIST
    end
    
    # Gets a single event by ID
    # params:
    #   - id: string (required)
    # return example:
    # {"event":{"calendar_id":"c1","id":"e1","name":"Team Sync"},"status":"ok"}
    # error example:
    # {"message":"not found","status":"error"}
    def self.get(params)
      # TODO: implement EVENTS.GET
    end
    
    # Creates a new event
    # params:
    #   - all_day: boolean (optional)
    #   - calendar_id: string (required)
    #   - color_theme: string (optional)
    #   - description: string (optional)
    #   - end_time: datetime (required)
    #   - location: string (optional)
    #   - name: string (required)
    #   - recurrence_rule: string (optional)
    #   - start_time: datetime (required)
    #   - status: string (required)
    #   - visibility: string (required)
    # return example:
    # {"event":{"calendar_id":"c1","id":"e2","name":"New Event"},"status":"ok"}
    # error example:
    # {"message":"validation failed","status":"error"}
    def self.create(params)
      # TODO: implement EVENTS.CREATE
    end
    
    # Updates an existing event
    # params:
    #   - all_day: boolean (optional)
    #   - calendar_id: string (optional)
    #   - color_theme: string (optional)
    #   - description: string (optional)
    #   - end_time: datetime (optional)
    #   - id: string (required)
    #   - location: string (optional)
    #   - name: string (optional)
    #   - recurrence_rule: string (optional)
    #   - start_time: datetime (optional)
    #   - status: string (optional)
    #   - visibility: string (optional)
    # return example:
    # {"event":{"id":"e1","name":"Updated Event"},"status":"ok"}
    # error example:
    # {"message":"not found or invalid input","status":"error"}
    def self.update(params)
      # TODO: implement EVENTS.UPDATE
    end
    
    # Deletes an event
    # params:
    #   - id: string (required)
    # return example:
    # {"event":{"id":"e1"},"status":"ok"}
    # error example:
    # {"message":"not found","status":"error"}
    def self.delete(params)
      # TODO: implement EVENTS.DELETE
    end
    
    # Create event user association with role and status
    # params:
    #   - event_id: string (required)
    #   - role: string (required)
    #   - status: string (required)
    #   - user_id: string (required)
    # return example:
    # {"event_user":{"event_id":"e1","id":"eu1","role":"organizer","status":"accepted","user_id":"u1"},"status":"ok"}
    # error example:
    # {"message":"invalid input","status":"error"}
    def self.create_event_user(params)
      # TODO: implement EVENTS.CREATE_EVENT_USER
    end
    
    # Get an event user by ID
    # params:
    #   - id: string (required)
    # return example:
    # {"event_user":{"id":"eu1"},"status":"ok"}
    # error example:
    # {"message":"not found","status":"error"}
    def self.get_event_user(params)
      # TODO: implement EVENTS.GET_EVENT_USER
    end
    
    # List all event users
    # params:
    
    # return example:
    # {"event_users":[{"event_id":"e1","id":"eu1","role":"presenter","status":"invited","user_id":"u1"}],"status":"ok"}
    # error example:
    # {"message":"unauthorized","status":"error"}
    def self.list_event_users(params)
      # TODO: implement EVENTS.LIST_EVENT_USERS
    end
    
    # Update an event user
    # params:
    #   - id: string (required)
    #   - role: string (optional)
    #   - status: string (optional)
    # return example:
    # {"event_user":{"id":"eu1","status":"declined"},"status":"ok"}
    # error example:
    # {"message":"not found or invalid update","status":"error"}
    def self.update_event_user(params)
      # TODO: implement EVENTS.UPDATE_EVENT_USER
    end
    
    # Delete an event user
    # params:
    #   - id: string (required)
    # return example:
    # {"event_user":{"id":"eu1"},"status":"ok"}
    # error example:
    # {"message":"not found","status":"error"}
    def self.delete_event_user(params)
      # TODO: implement EVENTS.DELETE_EVENT_USER
    end
    
  end
end
