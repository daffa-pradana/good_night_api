module V1
  class SleepRecordPresenter
    def initialize(object)
      @object = object
    end

    def as_json(*)
      {
        user: {
          id: @object.user.id,
          name: @object.user.name
        },
        sleep_record: {
          clocked_in_at: @object.clocked_in_at,
          clocked_out_at: @object.clocked_out_at,
          duration: @object.duration_in_words
        }
      }
    end

    def self.as_array_json(collection)
      collection.map { |record| new(record).as_json }
    end
  end
end
