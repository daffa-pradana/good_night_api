module QueryCounter
  def count_queries
    queries = []
    callback = ->(_name, _start, _finish, _id, payload) do
      # Only track real SQL queries, skip schema
      unless payload[:sql].match?(/SCHEMA|TRANSACTION/)
        queries << payload[:sql]
      end
    end

    ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
      yield
    end

    queries
  end

  def expect_max_queries(max)
    queries = count_queries { yield }

    if queries.size > max
      message = "\n=== Query Limit Exceeded ===\n" \
                "Expected <= #{max} queries, but got #{queries.size}\n\n" \
                + queries.each_with_index.map { |sql, i| "#{i + 1}. #{sql}" }.join("\n") \
                + "\n============================\n"

      raise RSpec::Expectations::ExpectationNotMetError, message
    end

    expect(queries.size).to be <= max
  end
  # def expect_max_queries(max)
  #   queries = []

  #   subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*, payload|
  #     unless payload[:name].in?(%w[SCHEMA TRANSACTION])
  #       queries << payload[:sql].squish
  #     end
  #   end

  #   yield

  #   if queries.size > max
  #     puts "\n=== Query Limit Exceeded ==="
  #     puts "Expected <= #{max} queries, but got #{queries.size}"
  #     queries.each_with_index do |sql, i|
  #       puts "#{i + 1}. #{sql}"
  #     end
  #     puts "============================\n"
  #   end

  #   expect(queries.size).to be <= max
  # ensure
  #   ActiveSupport::Notifications.unsubscribe(subscriber)
  # end
end
